-- p01_lingkungan_25430102.sql
CREATE DATABASE IF NOT EXISTS kopma_102
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'mhs_102'@'localhost' IDENTIFIED BY '<password_kerja>';
GRANT ALL PRIVILEGES ON kopma_102.* TO 'mhs_102'@'localhost';

-- akun tamu: hanya boleh membaca
CREATE USER IF NOT EXISTS 'tamu_102'@'localhost' IDENTIFIED BY '<password_tamu>';
GRANT SELECT ON kopma_102.* TO 'tamu_102'@'localhost';

-- basis data dan akun proyek
CREATE DATABASE IF NOT EXISTS perpus_102
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'dev_102'@'localhost' IDENTIFIED BY '<password_dev>';
GRANT ALL PRIVILEGES ON perpus_102.* TO 'dev_102'@'localhost';
