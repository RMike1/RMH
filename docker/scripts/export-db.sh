#!/bin/bash
# Exports the openclinic DB into DB_to_export/ (relative to current working directory)
mkdir -p DB_to_export
docker exec openclinic-db mysqldump -uroot -proot openclinic > DB_to_export/openclinic_sync.sql
echo "✅ Exported DB to DB_to_export/openclinic_sync.sql"