# Database GDSS ELECTRE–Borda

Implementasi basis data relasional berdasarkan seluruh bagian `docs/08_ERD_DAN_STRUKTUR_DATABASE.md`. Tahap ini hanya mencakup database; tidak membuat backend, API, atau mesin hitung ELECTRE–Borda.

**DATA DUMMY / SIMULASI — bukan hasil survei atau benchmark platform AI.**

## 1. Berkas dan urutan penggunaan

| Berkas | Fungsi |
|---|---|
| `gdss_mysql_schema.sql` | Membuat database `gdss_electre_borda`, sembilan tabel, indeks, foreign key, CHECK constraint, dan trigger validasi. |
| `gdss_mysql_seed.sql` | Mengisi skenario `demo-v1` sesuai `../data/demo.json`; tidak menghapus atau menimpa skenario yang sudah ada. |
| `03_verify_database.sql` | Menguji struktur, jumlah data seed, aturan integritas, dan cascade. Data uji dibatalkan dengan ROLLBACK. |
| `HASIL_VERIFIKASI.md` | Hasil eksekusi nyata, kesesuaian seed, dan batas verifikasi. |

Nama folder `Database` mengikuti permintaan pengguna. Lokasi `database/gdss_mysql_schema.sql` dan skrip `scripts/init_mysql.py` pada dokumen 08 adalah contoh rancangan lama; skrip Python tersebut tidak dibuat pada tahap database ini. Dokumen 05 masih menyebut SQLite untuk prototipe lama; implementasi ini mengikuti MySQL/MariaDB dan ERD sembilan tabel pada dokumen 08, bukan tabel snapshot SQLite.

## 2. Prasyarat

- MariaDB 10.4 atau lebih baru, atau MySQL 8.0.16 atau lebih baru agar CHECK constraint benar-benar ditegakkan. Eksekusi nyata dilakukan pada MariaDB 10.4.32; MySQL belum diuji langsung.
- Engine InnoDB dan character set `utf8mb4`.
- Akun lokal dengan hak membuat database, tabel, indeks, dan trigger. Verifikasi tambahan membutuhkan hak membuat/mengeksekusi/menghapus stored procedure.
- Gunakan database baru untuk instalasi awal. `CREATE TABLE IF NOT EXISTS` tidak mengubah struktur tabel lama dan bukan mekanisme migrasi.

## 3. Import melalui phpMyAdmin (XAMPP/Laragon)

1. Aktifkan layanan MySQL/MariaDB dari control panel XAMPP/Laragon. Untuk phpMyAdmin, aktifkan juga web server-nya.
2. Buka phpMyAdmin dan tab **Import** pada tingkat server. Akun harus boleh menjalankan CREATE DATABASE.
3. Import `gdss_mysql_schema.sql` terlebih dahulu. Database `gdss_electre_borda` dibuat otomatis.
4. Pilih database tersebut, lalu import `gdss_mysql_seed.sql` satu kali pada database baru.
5. Opsional: import `03_verify_database.sql`. Hasil yang diharapkan adalah `verification_status = PASS`.

Tidak ada password yang ditulis di dalam berkas SQL. Kredensial mengikuti akun MySQL/MariaDB milik pengguna.

## 4. Import melalui MySQL CLI

Jalankan dari root proyek dengan Bash/Git Bash atau Command Prompt; sintaks pengalihan `<` berikut bukan sintaks PowerShell.

```bash
mysql --default-character-set=utf8mb4 -h 127.0.0.1 -P 3306 -u root -p < Database/gdss_mysql_schema.sql
mysql --default-character-set=utf8mb4 -h 127.0.0.1 -P 3306 -u root -p < Database/gdss_mysql_seed.sql
mysql --default-character-set=utf8mb4 -h 127.0.0.1 -P 3306 -u root -p < Database/03_verify_database.sql
```

Jika `mysql` belum tersedia di PATH, contoh untuk XAMPP Windows:

```bash
"C:/xampp/mysql/bin/mysql.exe" --default-character-set=utf8mb4 -h 127.0.0.1 -P 3306 -u root -p < Database/gdss_mysql_schema.sql
"C:/xampp/mysql/bin/mysql.exe" --default-character-set=utf8mb4 -h 127.0.0.1 -P 3306 -u root -p < Database/gdss_mysql_seed.sql
"C:/xampp/mysql/bin/mysql.exe" --default-character-set=utf8mb4 -h 127.0.0.1 -P 3306 -u root -p < Database/03_verify_database.sql
```

`-p` meminta password secara interaktif; untuk akun yang memang tanpa password, cukup tekan Enter. Jangan menambahkan `--force`: hentikan import jika terjadi error dan periksa penyebabnya. Sesuaikan host, port, dan username dengan konfigurasi lokal.

### Jika demo-v1 sudah ada

Seed dirancang untuk import pertama. Import ulang harus ditolak karena primary key skenario sudah ada; data tidak otomatis di-reset. Jangan menghapus `demo-v1` bila penilaian atau riwayatnya masih diperlukan. Buat backup terlebih dahulu sebelum reset yang disengaja. Semua foreign key memakai ON DELETE CASCADE sehingga penghapusan skenario juga menghapus data anak dan riwayatnya.

## 5. Struktur sembilan tabel

| Tabel | Peran | Data setelah seed |
|---|---|---:|
| `scenarios` | Metadata skenario dan penanda dummy/real | 1 |
| `alternatives` | Platform AI dalam skenario | 4 |
| `criteria` | Kriteria, benefit/cost, skala, satuan | 6 |
| `decision_makers` | Penilai simulasi, bukan akun login | 3 |
| `criteria_weights` | Bobot mentah kriteria per DM | 18 |
| `alternative_evaluations` | Matriks keputusan X per DM | 72 |
| `calculation_runs` | Snapshot input/output dan metadata komputasi | 0 |
| `borda_results` | Ringkasan peringkat kelompok per run | 0 |
| `electre_dm_results` | Outdegree, average rank, poin Borda per DM | 0 |

Seed berisi ChatGPT, Gemini, Claude, dan Perplexity; lima kriteria benefit berskala 1–5 dan satu kriteria cost berupa waktu simulasi 1–60 menit; tiga penilai DM01–DM03. Bobot dan seluruh skor diambil dari `data/demo.json`, bukan hasil pengukuran produk.

Tabel hasil sengaja kosong. Database tidak menghitung ELECTRE atau Borda dan tidak memuat hasil perhitungan buatan. Backend nantinya mengisi ketiga tabel hasil secara atomik setelah perhitungan berhasil.

## 6. Integritas dan aturan bisnis

- Kolom, tipe, nullable, primary key, dan foreign key mengikuti kamus data pada dokumen 08.
- Semua 14 foreign key menggunakan ON DELETE CASCADE.
- Kode alternatif/kriteria/DM unik dalam masing-masing skenario.
- Kombinasi `(dm_id, criteria_id)` dan `(dm_id, alternative_id, criteria_id)` unik.
- Hasil Borda unik per `(run_id, alternative_id)`; hasil individu unik per `(run_id, dm_id, alternative_id)` untuk mencegah duplikasi ringkasan.
- Bobot harus lebih besar dari nol; skor berada pada rentang min_val sampai max_val, termasuk batasnya. Diperiksa saat INSERT dan UPDATE.
- Entitas yang direlasikan harus berada pada skenario yang sama. scenario_id alternatif, kriteria, DM, dan run tidak bisa dipindahkan lewat UPDATE; buat entitas baru untuk skenario lain.
- Perubahan skala kriteria ditolak bila mengecualikan nilai yang sudah tersimpan.
- Status run dibatasi ke `unique`, `tie`, atau `no_discrimination`.
- `input_hash` harus berupa 64 karakter heksadesimal. Database memvalidasi format, bukan menghitung atau membuktikan bahwa hash cocok dengan payload.
- `scenario_json` dan `result_json` tetap bertipe MEDIUMTEXT sesuai ERD, dengan validasi JSON pada INSERT/UPDATE. Struktur lengkap payload dan kebenaran hasil menjadi tugas backend.
- `rank` menggunakan backtick dalam SQL karena merupakan kata khusus pada beberapa versi MySQL.
- Matriks R/V/C/D/F/G/E tidak dibuat menjadi tabel tambahan; seluruh hasil perantara disimpan pada snapshot result_json sesuai rancangan audit.

## 7. Catatan untuk tahap backend berikutnya

- ID string `A1`, `C1`, dan `DM01` di JSON dipetakan ke kolom `code`; foreign key memakai ID INT internal. Jangan menganggap ID auto-increment selalu dimulai dari 1 atau berurutan tanpa celah.
- Saat menyusun kembali input, ambil data menurut kode/urutan yang disepakati; urutan SELECT tanpa ORDER BY tidak dijamin. Simpan urutan input utuh di scenario_json.
- Validasi kelengkapan seluruh matriks dan bobot, jumlah minimum/maksimum entitas, norma kolom bukan nol, finite number, serta aturan algoritma dilakukan backend sebelum menyimpan hasil.
- Simpan calculation_runs, borda_results, dan electre_dm_results dalam satu transaksi. Format hash/JSON saja tidak membuktikan kebenaran hasil ELECTRE–Borda.
- Untuk penggunaan serentak, lakukan penguncian baris kriteria dalam transaksi sebelum mengubah skala atau mengisi evaluasi. Pengujian tahap ini bersifat berurutan/lokal, bukan pengujian konkurensi.
- Verifikasi SQL sebaiknya dilakukan pada database uji, bukan saat transaksi aplikasi sedang berlangsung: START TRANSACTION dapat mengakhiri transaksi sebelumnya. ROLLBACK tidak memundurkan counter AUTO_INCREMENT; celah ID setelah pengujian adalah normal.
- Snapshot menyimpan keadaan input/output saat perhitungan sehingga dapat dibaca meskipun nama atau nilai master berubah. Penghapusan master tetap mengikuti cascade sebagaimana diminta ERD; backup diperlukan jika riwayat harus dipertahankan sebelum penghapusan.

## 8. Lingkup perubahan

Seluruh deliverable berada di folder ini. Dokumen sumber, dataset asli, workbook, dan berkas frontend/backend tidak diubah. Pengujian memakai instance MariaDB sementara yang terpisah dari direktori data XAMPP pengguna; hasil import ke layanan XAMPP utama tidak diasumsikan otomatis terjadi.
