# Hasil Verifikasi Database

Tanggal pengujian: 23 November 2026.

**Status verifikasi akhir: BELUM SELESAI.** Hasil PASS di bawah berasal dari pengujian versi sebelumnya. Pemeriksaan nilai seed secara menyeluruh menemukan nama skenario yang rusak akibat encoding pada import awal. Berkas seed sudah diperbaiki dan skrip verifikasi sudah ditambah pembandingan metadata, 18 bobot, serta 72 skor; versi akhir ini belum diimpor dan diuji ulang. Permintaan reset database uji tidak mendapat konfirmasi, sehingga tidak boleh dianggap disetujui. Jangan menggunakan hasil PASS sebelumnya sebagai bukti kelulusan versi akhir.

## Lingkungan

- Server: MariaDB 10.4.32 dari XAMPP Windows.
- Client: `C:/xampp/mysql/bin/mysql.exe`.
- Host/port: instance MariaDB sementara `127.0.0.1:33317`.
- Database pengujian dibuat pada direktori scratch terpisah; database XAMPP utama tidak diubah.

## Langkah yang berhasil

1. Membuat instance MariaDB sementara.
2. Mengimpor `gdss_mysql_schema.sql` tanpa error.
3. Mengimpor `gdss_mysql_seed.sql` tanpa error.
4. Menjalankan `03_verify_database.sql` tanpa error.
5. Memeriksa ulang jumlah tabel, trigger, dan data setelah verifikasi.

Output verifikasi:

```text
verification_status  details
PASS                 9 tabel, seed, validasi bobot/skor/skenario, dan cascade terverifikasi
```

## Hasil struktur dan seed

```text
tables                 9
triggers               13
scenarios              1
alternatives           4
criteria               6
decision_makers        3
criteria_weights       18
alternative_evaluations 72
runs                   0
```

## Yang diuji oleh skrip verifikasi

- Database memiliki sembilan tabel sesuai ERD.
- Seluruh foreign key memiliki ON DELETE CASCADE.
- Seed `demo-v1` memiliki jumlah entitas dan transaksi yang sesuai `data/demo.json`.
- Bobot nol ditolak.
- Skor di luar `min_val`–`max_val` ditolak.
- Evaluasi lintas-skenario ditolak.
- Perubahan rentang kriteria yang mengecualikan skor tersimpan ditolak.
- Pemindahan alternatif ke skenario lain ditolak.
- Hash yang bukan format SHA-256 heksadesimal 64 karakter ditolak.
- Snapshot JSON yang tidak valid ditolak saat INSERT dan UPDATE.
- Hasil Borda lintas-skenario ditolak.
- Penghapusan skenario menghapus data anak terkait melalui cascade, termasuk bobot, evaluasi, run, dan ringkasan hasil.
- Semua data uji dibatalkan dengan ROLLBACK; seed tetap tersisa dan tabel hasil tetap kosong.

## Batas verifikasi

- Skrip diuji langsung pada MariaDB 10.4.32. MySQL 8 belum diuji pada mesin ini.
- Verifikasi belum menguji backend, API, perhitungan ELECTRE–Borda, atau parity terhadap workbook Excel karena backend belum dibuat.
- Database hanya memeriksa format hash dan validitas JSON; backend tetap harus menghitung hash dari input, memvalidasi isi snapshot, menghitung metode, dan menyimpan hasil dalam transaksi.
- Belum dilakukan uji konkurensi, backup/restore, hak akses multi-user, atau deployment produksi.
