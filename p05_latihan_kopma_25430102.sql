-- p05_latihan_kopma_25430102.sql
-- Bukti constraint bekerja (langkah D.3, D.4) dan latihan E1, E2.
-- JALANKAN SATU PERINTAH PER SATU di mysql (paste, Enter). Perintah bertanda "HARUS DITOLAK"
-- akan menghasilkan ERROR, dan itu memang yang diharapkan. Jalankan p05_ddl_kopma_25430102.sql lebih dulu.

USE kopma_102;

-- Data induk secukupnya (dua petugas, dua barang)
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES
  ('K01', 'Sari',  'kasir'),
  ('G01', 'Budi',  'gudang');

INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang) VALUES
  ('ATK-001', 'Pulpen',  'ATK',     4000, 40),
  ('MKN-001', 'Roti',    'makanan', 5000, 20);

-- ===== Bukti 1: kunci tamu (HARUS DITOLAK: petugas 99 tidak ada) -> ERROR 1452
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0199', NOW(), 99, NULL, 5000);

-- ===== Bukti 2: CHECK (HARUS DITOLAK: stok negatif, AB-03) -> ERROR 4025
UPDATE barang SET stok_barang = -1 WHERE id_barang = 1;

-- ===== Bukti 3: UNIQUE (HARUS DITOLAK: kode kembar) -> ERROR 1062
INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang)
VALUES ('ATK-001', 'Duplikat', 'ATK', 1000);

-- ===== Bukti 4: bukti SHOW CREATE TABLE
SHOW CREATE TABLE penjualan;

-- ===== D.4 langkah 6: ubah struktur tanpa membuat ulang tabel
ALTER TABLE barang ADD COLUMN tgl_kedaluwarsa DATE NULL AFTER stok_min_barang;
DESCRIBE barang;
ALTER TABLE barang DROP COLUMN tgl_kedaluwarsa;   -- dibatalkan setelah dicoba
DESCRIBE barang;

-- ===== Latihan E1: stok_min_barang tidak boleh negatif
ALTER TABLE barang ADD CONSTRAINT ck_barang_stok_min CHECK (stok_min_barang >= 0);
-- HARUS DITOLAK -> ERROR 4025
UPDATE barang SET stok_min_barang = -5 WHERE id_barang = 1;

-- ===== Latihan E2: ON DELETE SET NULL pada fk_penjualan_anggota
ALTER TABLE penjualan DROP FOREIGN KEY fk_penjualan_anggota;
ALTER TABLE penjualan ADD CONSTRAINT fk_penjualan_anggota FOREIGN KEY (id_anggota)
  REFERENCES anggota (id_anggota) ON DELETE SET NULL;
SHOW CREATE TABLE penjualan;

-- ===== Pembuktian DROP TABLE dengan urutan terbalik (untuk Titik Analisis 3)
-- HARUS DITOLAK karena penjualan masih dirujuk detail_penjualan -> ERROR 1451
DROP TABLE penjualan;
