#!/bin/bash
mkdir -p DB_to_export
if [ ! -f DB_to_export/openclinic_sync.sql ]; then
  echo "❌ DB_to_export/openclinic_sync.sql not found. Place it there before running this."
  exit 1
fi
docker exec -i openclinic-db mysql -uroot -proot openclinic < DB_to_export/openclinic_sync.sql
echo "✅ Imported DB from DB_to_export/openclinic_sync.sql"