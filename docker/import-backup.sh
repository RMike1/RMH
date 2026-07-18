#!/usr/bin/env bash
# Import OpenClinic SQL dumps into the Docker MySQL container.
# Usage: ./docker/import-backup.sh /path/to/backup_YYYYMMDD_HHMM
set -uo pipefail

BACKUP_DIR="${1:-}"
if [[ -z "$BACKUP_DIR" || ! -d "$BACKUP_DIR" ]]; then
  echo "Usage: $0 /path/to/backup_folder"
  echo "Folder must contain openclinic_dbo_*.sql ocadmin_dbo_*.sql ocstats_dbo_*.sql ikirezi_*.sql"
  exit 1
fi

OPENCLINIC_SQL=$(ls "$BACKUP_DIR"/openclinic_dbo_*.sql 2>/dev/null | head -1)
OCADMIN_SQL=$(ls "$BACKUP_DIR"/ocadmin_dbo_*.sql 2>/dev/null | head -1)
OCSTATS_SQL=$(ls "$BACKUP_DIR"/ocstats_dbo_*.sql 2>/dev/null | head -1)
IKIREZI_SQL=$(ls "$BACKUP_DIR"/ikirezi_*.sql 2>/dev/null | head -1)

if [[ -z "$OPENCLINIC_SQL" || -z "$OCADMIN_SQL" || -z "$OCSTATS_SQL" || -z "$IKIREZI_SQL" ]]; then
  echo "Missing one or more dump files in $BACKUP_DIR"
  exit 1
fi

# Import as root so DEFINER views work. Do NOT use macOS sed on these dumps
# (latin1/binary content causes "illegal byte sequence" and truncates the pipe).
import_sql() {
  local db="$1"
  local file="$2"
  echo "    file: $(basename "$file") -> $db"
  docker exec -i openclinic-db mysql -uroot -proot --force --binary-mode "$db" < "$file" || true
}

echo "==> Ensuring openclinic@localhost exists (required by dump DEFINER clauses)"
docker exec -i openclinic-db mysql -uroot -proot -e "
CREATE USER IF NOT EXISTS 'openclinic'@'%' IDENTIFIED BY 'openclinic_local';
CREATE USER IF NOT EXISTS 'openclinic'@'localhost' IDENTIFIED BY 'openclinic_local';
GRANT ALL PRIVILEGES ON *.* TO 'openclinic'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'openclinic'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
" >/dev/null

echo "==> 1/4 Import openclinic_dbo (view errors until ocadmin exists are OK)"
import_sql openclinic_dbo "$OPENCLINIC_SQL"

echo "==> 2/4 Import ocadmin_dbo"
import_sql ocadmin_dbo "$OCADMIN_SQL"

echo "==> 3/4 Recreate openclinic views (lines 10580-10879)"
# Prefer LC_ALL=C sed for byte-safe slicing; fall back to full re-import of dump with --force
if LC_ALL=C sed -n '10580,10879p' "$OPENCLINIC_SQL" 2>/dev/null \
  | docker exec -i openclinic-db mysql -uroot -proot --force --binary-mode openclinic_dbo; then
  :
else
  echo "    (view slice failed; re-applying openclinic dump with --force)"
  import_sql openclinic_dbo "$OPENCLINIC_SQL"
fi

echo "==> 4/4 Import ocstats_dbo + ikirezi"
import_sql ocstats_dbo "$OCSTATS_SQL"
import_sql ikirezi "$IKIREZI_SQL"

echo "==> Verify"
docker exec -i openclinic-db mysql -uroot -proot -e "
SELECT table_schema, COUNT(*) AS tables
FROM information_schema.tables
WHERE table_schema IN ('ocadmin_dbo','openclinic_dbo','ocstats_dbo','ikirezi')
GROUP BY table_schema;
SELECT COUNT(*) AS users FROM ocadmin_dbo.users;
SELECT COUNT(*) AS labels FROM openclinic_dbo.oc_labels;
"

echo "==> Local URLs + project (Docker localhost:10088)"
docker exec -i openclinic-db mysql -uroot -proot -e "
UPDATE openclinic_dbo.oc_config
SET oc_value = 'http://localhost:10088/openclinic/_common/xml/'
WHERE oc_key IN ('templateSource','datacenterTemplateSource');
UPDATE openclinic_dbo.oc_config
SET oc_value = 'http://localhost:10088/openclinic/documents/'
WHERE oc_key = 'DocumentsURL';
UPDATE openclinic_dbo.oc_config
SET oc_value = 'http://localhost:10088/openclinic'
WHERE oc_key IN ('imageSource','localcontext');
UPDATE ocadmin_dbo.users
SET project = 'openclinic'
WHERE project <> 'openclinic' OR project IS NULL OR project = '';
"

echo "Done. Run: docker compose restart tomcat"
echo "Then open: http://localhost:10088/openclinic/  (logout/login once if already logged in)"
echo "MySQL from host: 127.0.0.1:13306 (openclinic / openclinic_local)"
