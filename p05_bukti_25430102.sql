-- p05_bukti_25430102.sql
-- Bukti constraint proyek bekerja. Jalankan p05_ddl_25430102.sql lebih dulu.
-- JALANKAN SATU PERINTAH PER SATU di mysql (login sebagai dev_102). Yang bertanda
-- "HARUS DITOLAK" akan menghasilkan ERROR, dan itu memang yang diharapkan.

USE perpus_102;

-- Data induk secukupnya
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES ('PTG-02', 'Dewi', 'layanan');
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, tgl_daftar_anggota)
  VALUES ('ANG-0012', '25430215', 'Rina Aulia', 'Ilmu Komputer', '081200000001', '2026-10-01');
INSERT INTO koleksi (kode_koleksi, judul_koleksi, jenis_koleksi, pengarang_koleksi, tahun_terbit_koleksi)
  VALUES ('KL-0101', 'Dasar Basis Data', 'buku', 'Budi Santoso', 2022);
INSERT INTO eksemplar (kode_eksemplar, id_koleksi) VALUES ('KL-0101-02', 1);
INSERT INTO peminjaman (no_peminjaman, tgl_pinjam_peminjaman, id_anggota, id_petugas)
  VALUES ('PJ-2610-0007', '2026-10-07', 1, 1);
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar) VALUES (1, 1);

-- Bukti 1: HARUS DITOLAK. Peminjaman untuk anggota 99 yang tidak ada -> ERROR 1452
INSERT INTO peminjaman (no_peminjaman, tgl_pinjam_peminjaman, id_anggota, id_petugas)
  VALUES ('PJ-2610-0099', '2026-10-07', 99, 1);

-- Bukti 2: pengembalian yang sah (denda 2 hari x 3000, belum lunas)
INSERT INTO pengembalian (no_pengembalian, id_peminjaman, tgl_kembali_pengembalian,
                          denda_pengembalian, status_denda_pengembalian, id_petugas)
  VALUES ('KB-2610-0005', 1, '2026-10-23', 6000, 'belum_lunas', 1);

-- Bukti 3: HARUS DITOLAK. Pengembalian kedua untuk peminjaman yang sama (AB-03) -> ERROR 1062
INSERT INTO pengembalian (no_pengembalian, id_peminjaman, tgl_kembali_pengembalian,
                          denda_pengembalian, status_denda_pengembalian, id_petugas)
  VALUES ('KB-2610-0006', 1, '2026-10-24', 0, 'tanpa_denda', 1);

-- Bukti 4: HARUS DITOLAK. Status belum_lunas tetapi denda 0 (AB-05) -> ERROR 4025
UPDATE pengembalian SET denda_pengembalian = 0 WHERE id_pengembalian = 1;

-- Bukti 5: HARUS DITOLAK. NIM tidak 8 digit -> ERROR 4025
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, tgl_daftar_anggota)
  VALUES ('ANG-0013', '123', 'Uji', 'Ilmu Komputer', '081200000002', '2026-10-02');

SHOW CREATE TABLE pengembalian;
