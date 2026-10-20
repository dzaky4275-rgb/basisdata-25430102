# Normalisasi Kopma - Pertemuan 04

- **Nama:** Muhammad Alif Dzaky
- **NIM:** 25430102

Notasi relasi: **huruf tebal** = kunci primer, tanda `*` = kunci tamu.

## 1. Titik awal: relasi UNF

Titik awalnya spreadsheet lama Kopma. Satu nota menyimpan grup berulang barang, ditulis dalam kurung kurawal.

```
NOTA_UNF (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas,
          no_anggota, nama_anggota,
          { kode_barang, nama_barang, qty_detail_penjualan,
            harga_satuan_detail_penjualan, subtotal_detail_penjualan },
          jumlah_penjualan, diskon_penjualan, total_penjualan)
```

## 2. Dari UNF ke 1NF

Grup berulang dihilangkan: satu baris untuk setiap barang di setiap nota. Kunci primer menjadi komposit (no_nota_penjualan, kode_barang).

```
NOTA_1NF (**no_nota_penjualan**, **kode_barang**, tgl_penjualan, kode_petugas,
          nama_petugas, no_anggota, nama_anggota, nama_barang,
          qty_detail_penjualan, harga_satuan_detail_penjualan,
          subtotal_detail_penjualan, jumlah_penjualan, diskon_penjualan,
          total_penjualan)
```

## 3. Anomali pada NOTA_1NF

| Anomali | Contoh pada Kopma |
|---|---|
| Ubah | Nama anggota tertulis di setiap baris barang pada nota. Kalau ejaan nama diperbaiki di sebagian baris saja, nama yang sama jadi tertulis dua cara |
| Sisip | Barang baru belum bisa dicatat sebelum ada nota yang memuatnya, karena kunci primernya memuat no_nota_penjualan |
| Hapus | Kalau satu-satunya nota yang memuat sebuah barang dihapus, nama barang itu ikut hilang |

## 4. Dependensi fungsional

Dependensi diturunkan dari aturan bisnis Pertemuan 2, bukan dari isi contoh data.

| FD | Dependensi | Dasar |
|---|---|---|
| FD1 | no_nota_penjualan -> tgl_penjualan, kode_petugas, no_anggota | AB-01 |
| FD2 | kode_petugas -> nama_petugas | satu kode petugas satu nama |
| FD3 | no_anggota -> nama_anggota | AB-05 |
| FD4 | kode_barang -> nama_barang | satu kode barang satu nama |
| FD5 | (no_nota_penjualan, kode_barang) -> qty_detail_penjualan, harga_satuan_detail_penjualan | AB-04 |
| FD6 | qty_detail_penjualan, harga_satuan_detail_penjualan -> subtotal_detail_penjualan | nilai turunan |

Satu dependensi yang sengaja kutolak: `kode_barang -> harga_satuan_detail_penjualan`. Walaupun contoh data menunjukkan harga pulpen selalu Rp4.000, AB-04 menyatakan harga di nota boleh berbeda dari harga barang saat ini. Contoh data hanya bisa membantah dependensi, tidak bisa membuktikannya.

## 5. Menuju 2NF

FD1 dan FD4 hanya bergantung pada sebagian kunci komposit. Keduanya dipisah:

- penjualan, berkunci no_nota_penjualan (dari FD1),
- barang, berkunci kode_barang (dari FD4),
- sisanya menjadi detail penjualan, berkunci (no_nota_penjualan, kode_barang).

## 6. Menuju 3NF

Di relasi penjualan ada dua rantai dependensi:

- no_nota_penjualan -> kode_petugas -> nama_petugas
- no_nota_penjualan -> no_anggota -> nama_anggota

Petugas dan anggota dipisah menjadi relasi sendiri.

## 7. Keputusan nilai turunan

| Nilai turunan | Keputusan | Alasan |
|---|---|---|
| subtotal_detail_penjualan | Tidak disimpan | Bisa dihitung dari qty dan harga satuan. Kalau disimpan, bisa tidak cocok dengan hasil hitungan |
| jumlah_penjualan | Tidak disimpan | Jumlah dari subtotal semua baris detail |
| total_penjualan | Tidak disimpan di tabel operasional | Dihitung dari detail dan status anggota (diskon), sehingga tidak mungkin tidak konsisten |

## 8. Hasil 3NF dan perbandingan dengan skema kanonik

Hasil dengan kunci alami:

```
PENJUALAN (**no_nota_penjualan**, tgl_penjualan, kode_petugas*, no_anggota*, bayar_penjualan)
DETAIL_PENJUALAN (**no_nota_penjualan***, **kode_barang***, qty_detail_penjualan, harga_satuan_detail_penjualan)
BARANG (**kode_barang**, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang)
PETUGAS (**kode_petugas**, nama_petugas, peran_petugas)
ANGGOTA (**no_anggota**, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota)
```

Perbandingan dengan skema kanonik Kopma (Tabel 4.2):

| Tabel | Kunci primer kanonik | Kunci unik kanonik | Kunci tamu kanonik |
|---|---|---|---|
| petugas | id_petugas | kode_petugas | - |
| anggota | id_anggota | no_anggota, nim_anggota | - |
| barang | id_barang | kode_barang | - |
| pemasok | id_pemasok | - | - |
| penjualan | id_penjualan | no_nota_penjualan | id_petugas, id_anggota (boleh NULL) |
| detail_penjualan | (id_penjualan, id_barang) | - | id_penjualan, id_barang |
| pembelian | id_pembelian | - | id_pemasok |
| detail_pembelian | (id_pembelian, id_barang) | - | id_pembelian, id_barang |

Perbedaan utamanya hanya kunci pengganti `id_*` sebagai kunci primer, sedangkan kode alami seperti no_nota_penjualan menjadi kunci unik. Struktur kolom dan ketergantungannya sama. Tabel pemasok, pembelian, dan detail_pembelian tidak muncul di spreadsheet nota, tapi sudah ada di skema kanonik karena berasal dari faktur pemasok.

## 9. Pemeriksaan BCNF

| Tabel | Penentu | Kunci kandidat? | Hasil |
|---|---|---|---|
| petugas | id_petugas, kode_petugas | ya, keduanya | BCNF |
| anggota | id_anggota, no_anggota, nim_anggota | ya, ketiganya | BCNF |
| barang | id_barang, kode_barang | ya, keduanya | BCNF |
| pemasok | id_pemasok | ya | BCNF |
| penjualan | id_penjualan, no_nota_penjualan | ya, keduanya | BCNF |
| detail_penjualan | (id_penjualan, id_barang) | ya | BCNF |
| pembelian | id_pembelian | ya | BCNF |
| detail_pembelian | (id_pembelian, id_barang) | ya | BCNF |

Tidak ada penentu yang bukan kunci kandidat, jadi semua tabel memenuhi BCNF. Kunci pengganti `id_*` tidak menghapus dependensi fungsional, jadi pemeriksaan tetap dilakukan dengan kunci alami (misalnya nim_anggota di anggota).
