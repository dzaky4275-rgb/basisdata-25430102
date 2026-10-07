# Dokumen Kebutuhan Data - Perpustakaan Pusat MAD

## 1. Latar belakang dan aktivitas organisasi

Perpustakaan Pusat MAD melayani mahasiswa yang ingin mencari jurnal, membaca, atau meminjam buku dan jurnal. Mahasiswa harus mendaftar sebagai anggota dengan memberikan nama, NIM, program studi, dan nomor HP. Setiap anggota boleh meminjam maksimal 5 koleksi selama 14 hari. Kalau terlambat mengembalikan, anggota membayar denda Rp3.000 per hari, dan anggota yang dendanya belum lunas tidak boleh meminjam lagi. Petugas layanan mengurus pendaftaran, peminjaman, pengembalian, denda, dan menghubungi anggota 2 hari sebelum jatuh tempo. Petugas koleksi mencatat buku dan jurnal baru. Kepala perpustakaan mengelola data petugas dan status anggota, serta menerima laporan peminjaman dan denda.

## 2. Aktor dan proses bisnis

| Kode | Proses bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan anggota | Petugas layanan | Mahasiswa ingin menjadi anggota |
| PB-02 | Mencatat koleksi dan eksemplar baru | Petugas koleksi | Ada buku atau jurnal baru |
| PB-03 | Memeriksa denda anggota | Petugas layanan | Anggota hendak meminjam |
| PB-04 | Mencatat peminjaman | Petugas layanan | Anggota meminjam koleksi |
| PB-05 | Mengingatkan anggota sebelum jatuh tempo | Petugas layanan | 2 hari sebelum jatuh tempo |
| PB-06 | Mencatat pengembalian dan denda | Petugas layanan | Anggota mengembalikan koleksi |
| PB-07 | Melunasi denda | Petugas layanan | Anggota membayar denda yang tertunggak |
| PB-08 | Mengelola data petugas | Kepala perpustakaan | Ada petugas baru atau petugas berhenti |
| PB-09 | Mengubah status keanggotaan | Kepala perpustakaan | Anggota lulus atau tidak aktif lagi |

## 3. Dokumen sumber yang dianalisis

Dokumen sumber fiktif yang kurancang adalah **Slip Peminjaman Perpustakaan Pusat MAD**.

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

| Isian di slip | Disimpan atau dihitung | Keterangan |
|---|---|---|
| No. Peminjaman | Disimpan | Nomor unik transaksi |
| Tanggal pinjam | Disimpan | Dicatat saat meminjam |
| Jatuh tempo | Dihitung | Tanggal pinjam + 14 hari (AB-02, AB-08) |
| Anggota (kode, NIM, nama) | Disimpan kodenya | NIM dan nama diambil dari data anggota |
| Petugas (kode, nama) | Disimpan kodenya | Nama diambil dari data petugas |
| Daftar koleksi | Disimpan | Satu baris per eksemplar yang dipinjam |
| Total koleksi | Dihitung | Jumlah baris koleksi, maksimal 5 (AB-01) |

Isian di slip ini jadi dasar entitas peminjaman dan detail peminjaman.

## 4. Entitas kandidat dan elemen data

| Entitas | Elemen data utama | Sumber |
|---|---|---|
| Anggota | no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota | Formulir pendaftaran |
| Koleksi | kode_koleksi, judul_koleksi, jenis_koleksi (buku/jurnal), pengarang_koleksi, tahun_terbit_koleksi | Daftar pengadaan |
| Eksemplar | kode_eksemplar, kode_koleksi, status_eksemplar, kondisi_eksemplar | Inventaris fisik |
| Petugas | kode_petugas, nama_petugas, peran_petugas | Penugasan staf |
| Peminjaman | no_peminjaman, tgl_pinjam_peminjaman, tgl_tenggat_peminjaman, no_anggota, kode_petugas | Slip peminjaman |
| Detail peminjaman | no_peminjaman, kode_eksemplar | Slip peminjaman |
| Pengembalian | no_pengembalian, no_peminjaman, tgl_kembali_pengembalian, hari_terlambat_pengembalian, denda_pengembalian, status_denda_pengembalian, tgl_lunas_pengembalian, kode_petugas | Kuitansi pengembalian |

## 5. Aturan bisnis

| Kode | Aturan bisnis |
|---|---|
| AB-01 | Setiap anggota boleh meminjam maksimal 5 koleksi dalam satu transaksi. |
| AB-02 | Masa pinjam 14 hari. |
| AB-03 | Keterlambatan dikenai denda Rp3.000 per hari untuk satu transaksi, bukan per koleksi. Semua koleksi dalam satu transaksi dikembalikan bersamaan. |
| AB-04 | Anggota dihubungi lewat nomor HP 2 hari sebelum jatuh tempo. |
| AB-05 | Anggota yang dendanya belum lunas tidak boleh meminjam sampai lunas. |
| AB-06 | Eksemplar yang berstatus dipinjam tidak dapat dipinjam lagi sampai dikembalikan. |
| AB-07 | Anggota yang berstatus nonaktif tidak boleh meminjam. |
| AB-08 | Tanggal tenggat adalah tanggal pinjam ditambah 14 hari. |

## 6. Kebutuhan informasi

| Kode | Kebutuhan informasi | Data yang diperlukan |
|---|---|---|
| KI-01 | Daftar anggota yang dendanya belum lunas | Pengembalian, anggota |
| KI-02 | Sepuluh anggota paling aktif meminjam per bulan | Peminjaman, anggota |
| KI-03 | Peminjaman yang jatuh tempo dalam 2 hari, lengkap dengan nomor HP anggota untuk pengingat | Peminjaman, detail peminjaman, anggota |
| KI-04 | Lima koleksi yang paling sering dipinjam per bulan | Detail peminjaman, eksemplar, koleksi |
| KI-05 | Daftar eksemplar yang rusak atau hilang | Eksemplar, koleksi |

## 7. Matriks CRUD

| Proses | Anggota | Koleksi | Eksemplar | Petugas | Peminjaman | Detail peminjaman | Pengembalian |
|---|---|---|---|---|---|---|---|
| PB-01 Mendaftarkan anggota | C | | | | | | |
| PB-02 Mencatat koleksi dan eksemplar baru | | C | C | | | | |
| PB-03 Memeriksa denda anggota | R | | | | | | R |
| PB-04 Mencatat peminjaman | R | R | R, U | R | C | C | |
| PB-05 Mengingatkan anggota sebelum jatuh tempo | R | | | | R | R | |
| PB-06 Mencatat pengembalian dan denda | | | U | R | R | R | C |
| PB-07 Melunasi denda | R | | | | | | R, U |
| PB-08 Mengelola data petugas | | | | C | | | |
| PB-09 Mengubah status keanggotaan | U | | | | | | |

## 8. Kamus data awal

| Elemen | Arti | Contoh | Aturan | Penanggung jawab |
|---|---|---|---|---|
| no_anggota | Nomor anggota perpustakaan | ANG-0012 | Unik, format ANG- dan 4 digit | Kepala perpustakaan |
| nim_anggota | NIM anggota | 25430215 | Unik, 8 digit angka | Kepala perpustakaan |
| nama_anggota | Nama lengkap anggota | Rina Aulia | Wajib diisi | Kepala perpustakaan |
| prodi_anggota | Program studi anggota | Ilmu Komputer | Wajib diisi | Kepala perpustakaan |
| no_hp_anggota | Nomor HP anggota untuk pengingat | 0812xxxx | Data pribadi, akses terbatas (bagian 9) | Kepala perpustakaan |
| status_anggota | Status anggota | aktif | Hanya aktif atau nonaktif (AB-07) | Kepala perpustakaan |
| tgl_daftar_anggota | Tanggal anggota mendaftar | 2026-10-01 | Terisi otomatis saat mendaftar | Petugas layanan |
| kode_koleksi | Kode unik satu judul koleksi | KL-0101 | Unik, format KL- dan 4 digit | Petugas koleksi |
| judul_koleksi | Judul buku atau jurnal | Dasar Basis Data | Wajib diisi | Petugas koleksi |
| jenis_koleksi | Jenis koleksi | buku | Hanya buku atau jurnal | Petugas koleksi |
| pengarang_koleksi | Pengarang atau penerbit koleksi | Budi Santoso | Wajib diisi | Petugas koleksi |
| tahun_terbit_koleksi | Tahun terbit koleksi | 2022 | Bilangan bulat 4 digit | Petugas koleksi |
| kode_eksemplar | Kode unik satu buku fisik | KL-0101-02 | Unik, kode koleksi dan nomor urut | Petugas koleksi |
| status_eksemplar | Status eksemplar | tersedia | Tersedia, dipinjam, rusak, atau hilang (AB-06) | Petugas koleksi |
| kondisi_eksemplar | Kondisi fisik eksemplar | baik | Baik, rusak ringan, atau rusak berat | Petugas koleksi |
| kode_petugas | Kode unik petugas | PTG-02 | Unik, format PTG- dan 2 digit | Kepala perpustakaan |
| nama_petugas | Nama petugas | Dewi | Wajib diisi | Kepala perpustakaan |
| peran_petugas | Peran petugas | layanan | Layanan, koleksi, atau kepala | Kepala perpustakaan |
| no_peminjaman | Nomor unik satu transaksi peminjaman | PJ-2610-0007 | Unik per transaksi, minimal 1 eksemplar | Petugas layanan |
| tgl_pinjam_peminjaman | Tanggal pinjam | 2026-10-07 | Terisi otomatis saat transaksi | Petugas layanan |
| tgl_tenggat_peminjaman | Tanggal jatuh tempo | 2026-10-21 | Tanggal pinjam + 14 hari (AB-08) | Petugas layanan |
| no_pengembalian | Nomor unik satu pengembalian | KB-2610-0005 | Unik per pengembalian | Petugas layanan |
| tgl_kembali_pengembalian | Tanggal koleksi dikembalikan | 2026-10-23 | Tidak boleh sebelum tanggal pinjam | Petugas layanan |
| hari_terlambat_pengembalian | Jumlah hari terlambat | 2 | Bilangan bulat >= 0 | Petugas layanan |
| denda_pengembalian | Denda dalam rupiah | 6000 | Hari terlambat x 3000 (AB-03), >= 0 | Petugas layanan |
| status_denda_pengembalian | Status denda | belum lunas | Tanpa denda, belum lunas, atau lunas (AB-05) | Petugas layanan |
| tgl_lunas_pengembalian | Tanggal denda dilunasi | 2026-10-24 | Kosong selama belum lunas | Petugas layanan |

## 9. Kebutuhan non-fungsional data

- **Parameter P:** (02 mod 9) + 1 = 3. Maka batas item per transaksi P + 2 = 5, denda harian P = Rp3.000, dan perkiraan volume harian 40 + 5 x 3 = 55 transaksi.
- **Data pribadi dan akses:** nomor HP anggota adalah data pribadi. Hanya petugas layanan dan kepala perpustakaan yang boleh melihatnya, karena dipakai untuk pengingat jatuh tempo. Petugas koleksi tidak boleh melihatnya. Pembatasan ini sejalan dengan Undang-Undang Pelindungan Data Pribadi.
- **Retensi:** data peminjaman dan pengembalian disimpan minimal 3 tahun supaya riwayat denda tetap bisa dicek.

## 10. Isu kualitas data yang diantisipasi

- **Eksemplar terpinjam dua kali** kalau status eksemplar tidak diperbarui (dicegah AB-06).
- **Anggota menunggak tetap bisa meminjam** kalau status denda tidak diperiksa sebelum meminjam (dicegah AB-05 dan PB-03).
- **Tanggal tenggat dan denda salah hitung** kalau dihitung manual (dicegah AB-02, AB-03, dan AB-08).
- **Pengingat gagal** kalau nomor HP salah atau kosong (dicegah dengan nomor HP wajib diisi saat mendaftar).