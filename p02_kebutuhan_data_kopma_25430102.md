# Dokumen Kebutuhan Data - Koperasi Mahasiswa Sejahtera (Kopma)

## 1. Latar belakang dan aktivitas organisasi

Kopma menjual alat tulis, makanan ringan, dan minuman di lingkungan kampus. Pembeli bisa anggota atau umum. Mahasiswa mendaftar sebagai anggota dengan NIM, nama, program studi, dan nomor HP, lalu mendapat nomor anggota berformat A-xxxx. Anggota aktif mendapat diskon 5% untuk setiap nota. Tiga kasir bekerja bergantian per sif untuk mencatat penjualan dan mencetak nota. Setiap sore petugas gudang memeriksa stok, dan bila stok suatu barang di bawah batas minimum ia memesan ke pemasok. Setiap awal bulan ketua menerima laporan omzet, barang terlaris, stok menipis, dan anggota paling aktif.

## 2. Aktor dan proses bisnis

| Kode | Proses bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan anggota | Kasir (atas permintaan mahasiswa) | Mahasiswa ingin menjadi anggota |
| PB-02 | Mencatat penjualan | Kasir | Pembeli membayar di kasir |
| PB-03 | Memesan barang ke pemasok | Petugas gudang | Stok di bawah batas minimum |
| PB-04 | Menerima barang dari pemasok | Petugas gudang | Barang datang bersama faktur |
| PB-05 | Menyusun laporan bulanan | Ketua koperasi | Awal bulan |
| PB-06 | Menukarkan poin loyalitas | Kasir | Anggota ingin menukar poin saat membayar |
| PB-07 | Mengelola data pemasok | Petugas gudang | Ada pemasok baru atau data pemasok berubah |
| PB-08 | Mengubah status keanggotaan | Ketua koperasi | Anggota sudah lulus atau tidak aktif lagi |

## 3. Dokumen sumber yang dianalisis

- **Narasi studi kasus** Kopma.
- **Kutipan wawancara** dengan ketua, petugas gudang, dan kasir. Ketua mengeluh sulit mengecek nota lama karena harga naik, petugas gudang menyebut stok di buku catatan kadang minus, kasir menyebut anggota sering lupa membawa kartu sehingga dicari lewat NIM.
- **Nota penjualan** Kopma, yang elemennya dibedah pada bagian 4.

## 4. Entitas kandidat dan elemen data

| Entitas kandidat | Elemen data utama | Sumber |
|---|---|---|
| Anggota | nomor anggota, NIM, nama, program studi, nomor HP, status aktif, poin_anggota | Formulir pendaftaran |
| Barang | kode, nama, kategori, harga jual, stok, batas minimum stok | Daftar barang, faktur |
| Penjualan | nomor nota, tanggal-jam, kasir, anggota (opsional), bayar | Nota penjualan |
| Detail penjualan | nomor nota, barang, qty, harga saat transaksi | Nota penjualan |
| Petugas | kode petugas, nama, peran (kasir/gudang/ketua) | Wawancara |
| Pemasok | kode, nama, telepon, alamat | Faktur pemasok |
| Pembelian dan detailnya | nomor faktur, tanggal, pemasok, barang, qty, harga beli | Faktur pemasok |
| Penukaran poin | no_penukaran_poin, tgl_penukaran_poin, jumlah_poin_penukaran, potongan_penukaran, no_anggota, kode_petugas | Ketentuan poin loyalitas |

## 5. Aturan bisnis

| Kode | Aturan bisnis |
|---|---|
| AB-01 | Setiap nota memiliki nomor unik dan minimal satu baris barang. |
| AB-02 | Penjualan boleh tanpa anggota (pembeli umum); jika ada, anggota harus berstatus aktif untuk memperoleh diskon 5%. |
| AB-03 | Stok barang tidak boleh negatif; penjualan ditolak bila qty melebihi stok tersedia. |
| AB-04 | Harga jual yang dipakai pada nota disimpan per baris dan tidak berubah meski harga barang kemudian naik. |
| AB-05 | NIM anggota unik; pencarian anggota dapat dilakukan lewat nomor anggota atau NIM. |
| AB-06 | Pesanan pembelian dibuat bila stok kurang dari batas minimum barang tersebut. |
| AB-07 | Anggota aktif mendapat 1 poin untuk setiap kelipatan Rp10.000 belanja (dihitung setelah diskon). Sisa di bawah Rp10.000 tidak menjadi poin dan tidak dibawa ke transaksi berikutnya. Pembeli umum tidak mendapat poin. |
| AB-08 | Penukaran poin hanya untuk anggota aktif dengan saldo minimal 50 poin, dalam kelipatan 50. Setiap 50 poin menjadi potongan Rp5.000 yang langsung mengurangi total pembayaran di nota yang sedang berjalan. |
| AB-09 | Saldo poin_anggota tidak boleh negatif. Penukaran ditolak kalau poin yang ditukar melebihi saldo. |

## 6. Kebutuhan informasi

| Kode | Kebutuhan informasi | Data yang diperlukan |
|---|---|---|
| KI-01 | Omzet dan jumlah nota per hari dan per bulan | Penjualan, detail penjualan |
| KI-02 | Lima barang terlaris per bulan berdasarkan qty | Detail penjualan, barang |
| KI-03 | Barang dengan stok di bawah batas minimum | Barang |
| KI-04 | Sepuluh anggota dengan belanja terbesar per bulan | Penjualan, detail penjualan, anggota |
| KI-05 | Sepuluh anggota dengan saldo poin terbanyak saat ini | Anggota (no_anggota, nama_anggota, poin_anggota) |
| KI-06 | Rekap penukaran poin per bulan: total poin yang ditukar dan total potongan yang dikeluarkan | Penukaran poin |

## 7. Matriks CRUD

| Proses | Anggota | Barang | Penjualan | Detail | Pemasok | Pembelian | Penukaran poin |
|---|---|---|---|---|---|---|---|
| PB-01 Mendaftarkan anggota | C | | | | | | |
| PB-02 Mencatat penjualan | R, U | R, U | C | C | | | |
| PB-03 Memesan barang ke pemasok | | R | | | R | C | |
| PB-04 Menerima barang dari pemasok | | U | | | R | U | |
| PB-05 Menyusun laporan bulanan | R | R | R | R | | R | R |
| PB-06 Menukarkan poin loyalitas | R, U | | U | | | | C |
| PB-07 Mengelola data pemasok | | | | | C | | |
| PB-08 Mengubah status keanggotaan | U | | | | | | |

## 8. Kamus data awal

| Elemen | Arti | Contoh | Aturan | Penanggung jawab |
|---|---|---|---|---|
| no_anggota | Nomor anggota koperasi | A-0457 | Unik, format A- dan 4 digit | Ketua |
| nim_anggota | NIM anggota | 2301010123 | Unik, 10 digit | Ketua |
| no_hp_anggota | Nomor HP anggota | 0812xxxx | Data pribadi, akses terbatas | Ketua |
| no_nota_penjualan | Nomor nota penjualan | PJ-2609-0142 | Unik per nota | Kasir |
| harga_satuan_detail_penjualan | Harga jual saat transaksi | 4000 | Bilangan bulat >= 0 (rupiah) | Kasir |
| stok_barang | Jumlah barang tersedia | 35 | Bilangan bulat >= 0 (AB-03) | Petugas gudang |
| poin_anggota | Saldo poin aktif anggota | 12 | Bilangan bulat >= 0 | Ketua |
| no_penukaran_poin | Nomor unik satu kali penukaran poin | PK-2610-0007 | Unik per penukaran | Kasir |
| tgl_penukaran_poin | Tanggal dan jam penukaran | 2026-10-06 10:15 | Terisi otomatis | Kasir |
| jumlah_poin_penukaran | Poin yang ditukar | 50 | Kelipatan 50, tidak melebihi saldo | Kasir |
| potongan_penukaran | Potongan harga dalam rupiah | 5000 | Rp5.000 untuk setiap 50 poin | Kasir |

## 9. Kebutuhan non-fungsional data

- **Volume:** sekitar 150 nota per hari.
- **Retensi:** data transaksi disimpan minimal lima tahun.
- **Privasi:** nomor HP anggota adalah data pribadi dan hanya boleh dilihat oleh ketua, sejalan dengan kewajiban pengendali data dalam Undang-Undang Pelindungan Data Pribadi.

## 10. Isu kualitas data yang diantisipasi

- **Harga lama hilang** karena harga hanya tersimpan di data barang (diatasi dengan AB-04).
- **Stok negatif** di buku catatan (diatasi dengan AB-03).
- **Anggota sulit dicari** ketika lupa membawa kartu (diatasi dengan pencarian lewat NIM, AB-05).