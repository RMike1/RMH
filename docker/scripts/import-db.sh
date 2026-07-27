
#!/bin/bash
mkdir -p DB_to_export
if [ ! -f DB_to_export/openclinic_sync.sql ]; then
  echo "❌ DB_to_export/openclinic_sync.sql not found. Place it there before running this."
  exit 1
fi
docker exec -i openclinic-db mysql -uroot -proot < DB_to_export/openclinic_sync.sql
echo "✅ Imported ocadmin_dbo, ocstats_dbo, openclinic_dbo from DB_to_export/openclinic_sync.sql"