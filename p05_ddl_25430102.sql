-- p05_ddl_25430102.sql
-- DDL proyek Perpustakaan Pusat MAD (Pertemuan 5). Dapat dijalankan ulang dari basis data kosong.
-- Dibuat dari ERD (Modul 3), hasil normalisasi (Modul 4), dan kamus data (Modul 2).
-- Nilai turunan tgl_tenggat_peminjaman, hari_terlambat_pengembalian, dan total_koleksi TIDAK dibuat
-- sebagai kolom (keputusan Modul 4). denda_pengembalian disimpan sebagai potret historis.

USE perpus_102;

DROP TABLE IF EXISTS pengembalian;
DROP TABLE IF EXISTS detail_peminjaman;
DROP TABLE IF EXISTS peminjaman;
DROP TABLE IF EXISTS eksemplar;
DROP TABLE IF EXISTS koleksi;
DROP TABLE IF EXISTS anggota;
DROP TABLE IF EXISTS petugas;

-- ========== TABEL INDUK ==========

CREATE TABLE petugas (
  id_petugas    SMALLINT                          NOT NULL AUTO_INCREMENT,
  kode_petugas  CHAR(6)                           NOT NULL,       -- contoh PTG-02
  nama_petugas  VARCHAR(100)                      NOT NULL,
  peran_petugas ENUM('layanan','koleksi','kepala') NOT NULL,
  CONSTRAINT pk_petugas PRIMARY KEY (id_petugas),
  CONSTRAINT uq_petugas_kode UNIQUE (kode_petugas)
) ENGINE=InnoDB;

CREATE TABLE anggota (
  id_anggota         INT                      NOT NULL AUTO_INCREMENT,
  no_anggota         CHAR(8)                  NOT NULL,           -- contoh ANG-0012
  nim_anggota        CHAR(8)                  NOT NULL,           -- 8 digit sesuai NIM sebenarnya
  nama_anggota       VARCHAR(100)             NOT NULL,
  prodi_anggota      VARCHAR(60)              NOT NULL,
  no_hp_anggota      VARCHAR(15)              NOT NULL,           -- data pribadi; wajib karena dipakai pengingat (AB-04)
  status_anggota     ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',  -- AB-07
  tgl_daftar_anggota DATE                     NOT NULL,
  CONSTRAINT pk_anggota PRIMARY KEY (id_anggota),
  CONSTRAINT uq_anggota_no  UNIQUE (no_anggota),
  CONSTRAINT uq_anggota_nim UNIQUE (nim_anggota),
  CONSTRAINT ck_anggota_no  CHECK (no_anggota  REGEXP '^ANG-[0-9]{4}$'),
  CONSTRAINT ck_anggota_nim CHECK (nim_anggota REGEXP '^[0-9]{8}$')
) ENGINE=InnoDB;

CREATE TABLE koleksi (
  id_koleksi           INT                 NOT NULL AUTO_INCREMENT,
  kode_koleksi         CHAR(7)             NOT NULL,              -- contoh KL-0101
  judul_koleksi        VARCHAR(200)        NOT NULL,
  jenis_koleksi        ENUM('buku','jurnal') NOT NULL,
  pengarang_koleksi    VARCHAR(100)        NOT NULL,
  tahun_terbit_koleksi SMALLINT            NOT NULL,
  CONSTRAINT pk_koleksi PRIMARY KEY (id_koleksi),
  CONSTRAINT uq_koleksi_kode UNIQUE (kode_koleksi),
  CONSTRAINT ck_koleksi_tahun CHECK (tahun_terbit_koleksi BETWEEN 1900 AND 2100)
) ENGINE=InnoDB;

CREATE TABLE eksemplar (
  id_eksemplar      INT      NOT NULL AUTO_INCREMENT,
  kode_eksemplar    CHAR(10) NOT NULL,                            -- contoh KL-0101-02
  id_koleksi        INT      NOT NULL,
  status_eksemplar  ENUM('tersedia','dipinjam','rusak','hilang') NOT NULL DEFAULT 'tersedia',  -- AB-06
  kondisi_eksemplar ENUM('baik','rusak_ringan','rusak_berat')    NOT NULL DEFAULT 'baik',
  CONSTRAINT pk_eksemplar PRIMARY KEY (id_eksemplar),
  CONSTRAINT uq_eksemplar_kode UNIQUE (kode_eksemplar),
  CONSTRAINT fk_eksemplar_koleksi FOREIGN KEY (id_koleksi)
    REFERENCES koleksi (id_koleksi)
) ENGINE=InnoDB;

-- ========== TABEL TRANSAKSI ==========

CREATE TABLE peminjaman (
  id_peminjaman        INT      NOT NULL AUTO_INCREMENT,
  no_peminjaman        CHAR(12) NOT NULL,                         -- contoh PJ-2610-0007
  tgl_pinjam_peminjaman DATE    NOT NULL,
  id_anggota           INT      NOT NULL,
  id_petugas           SMALLINT NOT NULL,
  CONSTRAINT pk_peminjaman PRIMARY KEY (id_peminjaman),
  CONSTRAINT uq_peminjaman_no UNIQUE (no_peminjaman),
  CONSTRAINT fk_peminjaman_anggota FOREIGN KEY (id_anggota)
    REFERENCES anggota (id_anggota),
  CONSTRAINT fk_peminjaman_petugas FOREIGN KEY (id_petugas)
    REFERENCES petugas (id_petugas)
) ENGINE=InnoDB;

CREATE TABLE detail_peminjaman (
  id_peminjaman                    INT NOT NULL,
  id_eksemplar                     INT NOT NULL,
  kondisi_pinjam_detail_peminjaman ENUM('baik','rusak_ringan','rusak_berat') NOT NULL DEFAULT 'baik',
  CONSTRAINT pk_detail_peminjaman PRIMARY KEY (id_peminjaman, id_eksemplar),
  CONSTRAINT fk_detail_peminjaman_peminjaman FOREIGN KEY (id_peminjaman)
    REFERENCES peminjaman (id_peminjaman) ON DELETE CASCADE,       -- rincian bagian dari transaksinya
  CONSTRAINT fk_detail_peminjaman_eksemplar FOREIGN KEY (id_eksemplar)
    REFERENCES eksemplar (id_eksemplar)                            -- eksemplar berriwayat tidak boleh dihapus
) ENGINE=InnoDB;

CREATE TABLE pengembalian (
  id_pengembalian           INT           NOT NULL AUTO_INCREMENT,
  no_pengembalian           CHAR(12)      NOT NULL,               -- contoh KB-2610-0005
  id_peminjaman             INT           NOT NULL,
  tgl_kembali_pengembalian  DATE          NOT NULL,
  denda_pengembalian        DECIMAL(12,2) NOT NULL DEFAULT 0,     -- potret historis (AB-03)
  status_denda_pengembalian ENUM('tanpa_denda','belum_lunas','lunas') NOT NULL,   -- AB-05
  tgl_lunas_pengembalian    DATE          NULL,
  id_petugas                SMALLINT      NOT NULL,
  CONSTRAINT pk_pengembalian PRIMARY KEY (id_pengembalian),
  CONSTRAINT uq_pengembalian_no UNIQUE (no_pengembalian),
  CONSTRAINT uq_pengembalian_peminjaman UNIQUE (id_peminjaman),   -- AB-03: paling banyak satu pengembalian (0..1)
  CONSTRAINT fk_pengembalian_peminjaman FOREIGN KEY (id_peminjaman)
    REFERENCES peminjaman (id_peminjaman),
  CONSTRAINT fk_pengembalian_petugas FOREIGN KEY (id_petugas)
    REFERENCES petugas (id_petugas),
  CONSTRAINT ck_pengembalian_denda  CHECK (denda_pengembalian >= 0),
  CONSTRAINT ck_pengembalian_status CHECK (
    (status_denda_pengembalian = 'tanpa_denda' AND denda_pengembalian = 0) OR
    (status_denda_pengembalian IN ('belum_lunas','lunas') AND denda_pengembalian > 0)),
  CONSTRAINT ck_pengembalian_lunas CHECK (
    (status_denda_pengembalian = 'lunas' AND tgl_lunas_pengembalian IS NOT NULL) OR
    (status_denda_pengembalian <> 'lunas' AND tgl_lunas_pengembalian IS NULL))
) ENGINE=InnoDB;

-- ========== ATURAN YANG BELUM BISA DIJAGA CONSTRAINT (dikerjakan di Modul 14) ==========
-- AB-01 dan AB-09 : minimal 1 dan maksimal 5 eksemplar per peminjaman (lintas baris)
-- AB-05           : anggota dengan denda belum lunas tidak boleh meminjam (lintas tabel)
-- AB-06           : eksemplar berstatus dipinjam tidak boleh dipinjam lagi (lintas baris dan status)
-- AB-07           : anggota nonaktif tidak boleh meminjam (lintas tabel)
-- AB-03           : denda = hari terlambat x Rp3.000 (butuh tanggal dari tabel peminjaman)

SHOW TABLES;
