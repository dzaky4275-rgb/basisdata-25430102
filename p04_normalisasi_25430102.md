# Normalisasi Proyek - Perpustakaan Pusat MAD (Pertemuan 04)

- **Nama:** Muhammad Alif Dzaky
- **NIM:** 25430102

Notasi relasi: **huruf tebal** = kunci primer, tanda `*` = kunci tamu. Semua dependensi diturunkan dari aturan bisnis di `p02_kebutuhan_data_25430102.md`, dan AB-09 dari `Pertemuan 3`.

## 1. Dokumen sumber

Titik awalnya Slip Peminjaman Perpustakaan Pusat MAD dari Pertemuan 2:

```
SLIP PEMINJAMAN - Perpustakaan Pusat MAD
No. Peminjaman : PJ-2610-0007
Tanggal pinjam : 07-10-2026
Jatuh tempo    : 21-10-2026
Anggota        : ANG-0012 / 25430215 / Rina Aulia
Petugas        : PTG-02 / Dewi
Koleksi yang dipinjam:
  1. KL-0101-02  Dasar Basis Data
  2. KL-0230-01  Jurnal Sistem Informasi Vol. 4
Total koleksi  : 2
```

Karena denda baru muncul saat pengembalian, aku juga memakai Kuitansi Pengembalian sebagai sumber kedua (bagian 8).

## 2. Relasi UNF

```
SLIP_UNF (no_peminjaman, tgl_pinjam_peminjaman, tgl_tenggat_peminjaman,
          no_anggota, nim_anggota, nama_anggota, kode_petugas, nama_petugas,
          { kode_eksemplar, kode_koleksi, judul_koleksi, jenis_koleksi,
            kondisi_pinjam_detail_peminjaman },
          total_koleksi)
```

## 3. Dari UNF ke 1NF

Grup berulang koleksi dihilangkan: satu baris untuk setiap eksemplar di setiap slip. Kunci primer menjadi komposit (no_peminjaman, kode_eksemplar).

```
SLIP_1NF (**no_peminjaman**, **kode_eksemplar**, tgl_pinjam_peminjaman,
          tgl_tenggat_peminjaman, no_anggota, nim_anggota, nama_anggota,
          kode_petugas, nama_petugas, kode_koleksi, judul_koleksi,
          jenis_koleksi, kondisi_pinjam_detail_peminjaman, total_koleksi)
```

## 4. Anomali pada SLIP_1NF

| Anomali | Contoh pada perpustakaan |
|---|---|
| Ubah | Nama anggota ditulis di setiap baris eksemplar. Kalau nama diperbaiki di satu baris saja, anggota yang sama punya dua nama |
| Sisip | Koleksi baru belum bisa dicatat sebelum ada slip yang memuatnya, karena kunci primernya memuat no_peminjaman |
| Hapus | Kalau satu-satunya slip yang memuat sebuah eksemplar dihapus, data judul koleksi itu ikut hilang |

## 5. Dependensi fungsional dan aturan yang mendasarinya

| FD | Dependensi | Dasar |
|---|---|---|
| FD1 | no_peminjaman -> tgl_pinjam_peminjaman, kode_petugas, no_anggota | slip peminjaman, AB-01 (satu transaksi untuk satu anggota) |
| FD2 | tgl_pinjam_peminjaman -> tgl_tenggat_peminjaman | AB-02 dan AB-08 (tenggat = pinjam + 14 hari), nilai turunan |
| FD3 | kode_petugas -> nama_petugas, peran_petugas | kamus data (kode petugas unik), PB-08 |
| FD4 | no_anggota -> nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota | kamus data (no anggota unik), AB-07 |
| FD5 | nim_anggota -> no_anggota | kamus data (NIM unik) |
| FD6 | kode_koleksi -> judul_koleksi, jenis_koleksi, pengarang_koleksi, tahun_terbit_koleksi | PB-02, kamus data |
| FD7 | kode_eksemplar -> kode_koleksi, status_eksemplar, kondisi_eksemplar | AB-06, PB-02 |
| FD8 | (no_peminjaman, kode_eksemplar) -> kondisi_pinjam_detail_peminjaman | atribut entitas asosiatif (Pertemuan 3), AB-09 |
| FD9 | no_peminjaman -> no_pengembalian, dan sebaliknya | AB-03 (satu peminjaman dikembalikan sekaligus, jadi paling banyak satu pengembalian) |
| FD10 | no_pengembalian -> no_peminjaman, tgl_kembali_pengembalian, denda_pengembalian, status_denda_pengembalian, tgl_lunas_pengembalian, kode_petugas | AB-03, AB-05 |
| FD11 | tgl_kembali_pengembalian dan tgl_tenggat_peminjaman -> hari_terlambat_pengembalian | AB-03, nilai turunan |
| FD12 | hari_terlambat_pengembalian -> denda_pengembalian (hari x Rp3.000) | AB-03, nilai turunan |

Dua dependensi yang sengaja kutolak, karena contoh data hanya bisa membantah, tidak bisa membuktikan:

- `nama_anggota -> no_anggota`: dua anggota bisa saja bernama sama.
- `kode_koleksi -> status_eksemplar`: status dimiliki setiap eksemplar, bukan setiap judul (AB-06).

## 6. Menuju 2NF

Kunci komposit (no_peminjaman, kode_eksemplar). FD1 dan FD7 hanya bergantung pada sebagian kunci, jadi dipisah:

- peminjaman, berkunci no_peminjaman (dari FD1),
- eksemplar beserta atribut koleksinya, berkunci kode_eksemplar (dari FD7),
- sisanya menjadi detail peminjaman, berkunci (no_peminjaman, kode_eksemplar), dengan atribut kondisi_pinjam_detail_peminjaman (FD8).

## 7. Menuju 3NF

Rantai dependensi yang dipisah:

- no_peminjaman -> no_anggota -> nim_anggota, nama_anggota: anggota dipisah.
- no_peminjaman -> kode_petugas -> nama_petugas: petugas dipisah.
- kode_eksemplar -> kode_koleksi -> judul_koleksi, jenis_koleksi: koleksi dipisah dari eksemplar.
- no_peminjaman -> tgl_pinjam_peminjaman -> tgl_tenggat_peminjaman: diselesaikan dengan keputusan nilai turunan di bagian 9, yaitu tgl_tenggat tidak disimpan.

## 8. Dokumen sumber kedua: kuitansi pengembalian

```
KUITANSI_UNF (no_pengembalian, no_peminjaman, tgl_kembali_pengembalian,
              hari_terlambat_pengembalian, denda_pengembalian,
              status_denda_pengembalian, tgl_lunas_pengembalian,
              kode_petugas, nama_petugas)
```

Semua nilainya atomik dan tidak ada grup berulang, jadi relasi ini sudah 1NF dengan kunci no_pengembalian. Kuncinya tunggal, jadi tidak ada ketergantungan parsial (2NF terpenuhi). Rantai no_pengembalian -> kode_petugas -> nama_petugas dipisah ke relasi petugas yang sama dengan di atas (3NF).

## 9. Keputusan nilai turunan

| Nilai turunan | Keputusan | Alasan | Risiko dan penjagaannya |
|---|---|---|---|
| tgl_tenggat_peminjaman | Tidak disimpan, dihitung dari tgl_pinjam + 14 hari | AB-08 menetapkan rumus tetap. Menyimpannya membuat rantai tgl_pinjam -> tgl_tenggat di satu tabel dan bisa tidak cocok kalau tanggal pinjam dikoreksi | Kalau masa pinjam suatu saat berubah, tenggat transaksi lama ikut berubah. Karena AB-02 tetap 14 hari, risikonya kuterima, dan snapshot baru dibuat kalau aturan berubah |
| hari_terlambat_pengembalian | Tidak disimpan, dihitung dari tgl_kembali dikurangi tenggat | Selalu bisa dihitung ulang dari dua tanggal | Tidak ada, karena tidak ada salinan yang bisa bertentangan |
| denda_pengembalian | **Disimpan**, dihitung sekali saat pengembalian dicatat (PB-06) | Denda adalah potret historis: jumlah yang ditagih saat itu. Status pelunasan merujuk ke jumlah itu, dan kalau tarif Rp3.000 berubah, denda lama tidak boleh ikut berubah | Nilainya tidak boleh diubah setelah dicatat, kecuali status dan tanggal lunas. Di tabel pengembalian tidak ada atribut lain yang menentukannya (hari terlambat dan tenggat tidak disimpan di situ), jadi 3NF tetap terjaga |
| total_koleksi | Tidak disimpan, dihitung dari jumlah baris detail_peminjaman | Bisa dihitung langsung, batas maksimal 5 dijaga AB-01 dan AB-09 | Tidak ada |

## 10. Skema 3NF dan perbandingan dengan ERD

Hasil dengan kunci alami:

```
ANGGOTA (**no_anggota**, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota)
KOLEKSI (**kode_koleksi**, judul_koleksi, jenis_koleksi, pengarang_koleksi, tahun_terbit_koleksi)
EKSEMPLAR (**kode_eksemplar**, kode_koleksi*, status_eksemplar, kondisi_eksemplar)
PETUGAS (**kode_petugas**, nama_petugas, peran_petugas)
PEMINJAMAN (**no_peminjaman**, tgl_pinjam_peminjaman, no_anggota*, kode_petugas*)
DETAIL_PEMINJAMAN (**no_peminjaman***, **kode_eksemplar***, kondisi_pinjam_detail_peminjaman)
PENGEMBALIAN (**no_pengembalian**, no_peminjaman* (unik), tgl_kembali_pengembalian, denda_pengembalian, status_denda_pengembalian, tgl_lunas_pengembalian, kode_petugas*)
```

Skema ini sama dengan ERD Pertemuan 3, dengan perbedaan kunci pengganti `id_*` sebagai kunci primer dan kode alami sebagai kunci unik.

## 11. Pemeriksaan BCNF

| Tabel | Penentu | Kunci kandidat? | Hasil |
|---|---|---|---|
| anggota | id_anggota, no_anggota, nim_anggota | ya, ketiganya | BCNF |
| koleksi | id_koleksi, kode_koleksi | ya, keduanya | BCNF |
| eksemplar | id_eksemplar, kode_eksemplar | ya, keduanya | BCNF |
| petugas | id_petugas, kode_petugas | ya, keduanya | BCNF |
| peminjaman | id_peminjaman, no_peminjaman | ya, keduanya | BCNF |
| detail_peminjaman | (id_peminjaman, id_eksemplar) | ya | BCNF |
| pengembalian | id_pengembalian, no_pengembalian, id_peminjaman | ya, ketiganya | BCNF |

Semua tabel memenuhi BCNF. Catatan penting: di pengembalian, `id_peminjaman` juga kunci kandidat karena satu peminjaman paling banyak punya satu pengembalian (FD9), jadi di skema DDL nanti ia harus diberi constraint UNIQUE.

## 12. Perubahan pada ERD proyek

Hasil normalisasi mengubah ERD Pertemuan 3. Versi baru ada di `p04_erd_25430102.drawio`.

| Perubahan | Alasan |
|---|---|
| `tgl_tenggat_peminjaman` dihapus dari tabel peminjaman | Dihitung dari tgl_pinjam + 14 hari (bagian 9) |
| `hari_terlambat_pengembalian` dihapus dari tabel pengembalian | Dihitung dari dua tanggal (bagian 9) |
| `denda_pengembalian` tidak lagi ditandai turunan | Disimpan sebagai potret historis (bagian 9) |
| `id_peminjaman` di pengembalian diberi tanda unik (FK,U) | Satu peminjaman paling banyak satu pengembalian (FD9) |
