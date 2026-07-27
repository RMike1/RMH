#!/bin/bash
# Exports the openclinic DB into DB_to_export/ (relative to current working directory)
#!/bin/bash
mkdir -p DB_to_export
docker exec openclinic-db mysqldump -uroot -proot --databases ocadmin_dbo ocstats_dbo openclinic_dbo > DB_to_export/openclinic_sync.sql
echo "✅ Exported ocadmin_dbo, ocstats_dbo, openclinic_dbo to DB_to_export/openclinic_sync.sql"