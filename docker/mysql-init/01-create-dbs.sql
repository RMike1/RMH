
CREATE DATABASE IF NOT EXISTS ocadmin_dbo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS openclinic_dbo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS ocstats_dbo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS ikirezi CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;


CREATE USER IF NOT EXISTS 'openclinic'@'localhost' IDENTIFIED BY 'openclinic_local';

GRANT ALL PRIVILEGES ON ocadmin_dbo.* TO 'openclinic'@'%';
GRANT ALL PRIVILEGES ON openclinic_dbo.* TO 'openclinic'@'%';
GRANT ALL PRIVILEGES ON ocstats_dbo.* TO 'openclinic'@'%';
GRANT ALL PRIVILEGES ON ikirezi.* TO 'openclinic'@'%';
GRANT ALL PRIVILEGES ON ocadmin_dbo.* TO 'openclinic'@'localhost';
GRANT ALL PRIVILEGES ON openclinic_dbo.* TO 'openclinic'@'localhost';
GRANT ALL PRIVILEGES ON ocstats_dbo.* TO 'openclinic'@'localhost';
GRANT ALL PRIVILEGES ON ikirezi.* TO 'openclinic'@'localhost';
FLUSH PRIVILEGES;
