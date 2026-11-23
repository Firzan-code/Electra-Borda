# Keputusan dan rencana prototipe progres

Status: keputusan implementasi baseline oleh asisten untuk menindaklanjuti permintaan melanjutkan pengerjaan menjelang progres minggu depan. Bukan klaim persetujuan dosen atau review anggota. Detail dapat direvisi melalui perubahan terdokumentasi; hasil tidak dipilih untuk menguntungkan platform tertentu.

## Target dan batas milestone

Bangun satu alur yang benar-benar berjalan: data dummy → ELECTRE per DM → Borda → tabel web → simpan/buka hasil → cocokkan workbook berformula. Ini prototipe lokal, bukan aplikasi produksi atau laporan UAS final. Tidak melakukan deployment publik, login, integrasi API AI, survei atau pembelian layanan.

Urutan: spesifikasi/kontrak → TDD mesin → workbook dan parity → API/database → UI → tes end-to-end → panduan demo. Pengembangan UI boleh paralel setelah kontrak ini ditulis; semua pekerjaan tetap dalam workspace ini. Deadline kalender spesifik belum diberikan, hanya kebutuhan progres minggu depan.

## Stack dan arsitektur

- Python 3.11, Flask 3.1.3; SQLite bawaan Python.
- Frontend HTML/CSS/JavaScript tanpa framework/build/CDN agar offline setelah dependensi terpasang.
- `openpyxl==3.1.5` untuk membentuk workbook; Microsoft Excel COM hanya untuk rekalkulasi/validasi di mesin pengembang, bukan dependency runtime web.
- Tes menggunakan `unittest` bawaan Python.
- Bind `127.0.0.1:8765`, debug mati, operator lokal tanpa autentikasi. Bukan konfigurasi yang layak diekspos publik.

```text
Browser (input + tabel; tidak menghitung metode)
  -> Flask API -> core.py (metode murni) -> JSON hasil
                -> SQLite: runs (snapshot input + hasil + versi + waktu)
Dataset dummy JSON -> generator Excel berformula -> Excel recalculation
                                      -> parity dengan hasil core/API
```

SQLite milestone: `runs(id INTEGER PK, created_at TEXT, input_hash TEXT, scenario_json TEXT, result_json TEXT)`. Satu baris menyimpan snapshot atomik data dummy lengkap dan hasilnya. Ini keputusan penyimpanan snapshot untuk prototipe, belum ERD master alternatif/kriteria/DM yang ternormalisasi. Migrasi awal menggunakan `PRAGMA user_version=1`; perubahan skema berikutnya perlu migrasi baru.

## Aturan metode: `electre-borda-v1`

- R-01: minimal dua alternatif, dua DM, satu kriteria; maksimum sepuluh alternatif/DM/kriteria untuk demo. Semua DM menilai semua alternatif dalam urutan ID yang sama.
- R-02: input numerik finite, bukan bool; nilai numerik dibatasi maksimum 1e9 dalam prototipe. Skala tiap kriteria eksplisit; bobot mentah setiap kriteria positif. Nilai matriks non-negatif dan norma kolom tidak nol, termasuk nol akibat underflow kuadrat floating point. Bobot dinormalisasi per DM.
- R-03: normalisasi vektor per kolom, `R = X/sqrt(sum(X^2))`, lalu `V = R*w`.
- R-04: himpunan concordance memakai benefit `x_a >= x_b`, cost `x_a <= x_b`; discordance komplemennya. Indeks C adalah jumlah bobot. Indeks D adalah maksimum selisih V pada kriteria buruk dibagi maksimum selisih V seluruh kriteria. Himpunan buruk kosong atau baris identik menghasilkan D=0.
- R-05: threshold C/D adalah rata-rata semua pasangan off-diagonal. Diagonal C/D/F/G/E ditulis 0 dan dikecualikan dari threshold.
- R-06: F=1 jika C >= cbar - epsilon; G=1 jika D <= dbar + epsilon; E=F*G. `epsilon=1e-12` adalah konvensi numerik untuk batas floating point, diterapkan sama di Excel/Python. Tidak membulatkan nilai perantara.
- R-07: skor individual adalah outdegree/jumlah baris E, urut turun. Ini kebijakan ekstraksi tambahan, bukan ranking total bawaan ELECTRE I. Seluruh alternatif tetap ikut Borda.
- R-08: posisi seri memakai rata-rata posisi yang ditempati; poin Borda `m - posisi_rata_rata`, skala m−1 hingga 0. Semua DM bobot suara sama. Bukan skor ELECTRE dikalikan bobot posisi Modul 7.
- R-09: total poin Borda dijumlahkan antar-DM; rank akhir memakai competition rank (1,1,3 jika dua teratas seri). Tampilkan semua pemilik skor maksimum. Jika semua total sama, status `no_discrimination`, bukan pemenang tunggal.
- R-10: urutan tampilan boleh mengikuti ID/input, tetapi tidak mengubah poin atau memecah seri. Poin Borda bukan probabilitas atau akurasi platform.
- R-11: tampilan angka enam desimal (bukan pembulatan input komputasi); parity riil `abs(a-b) <= 1e-9 + 1e-9*abs(b)`. Himpunan, flag, outdegree, posisi, poin dan kelompok ranking harus cocok tepat. Uji dekat threshold dan permutasi dilakukan.

## Dataset baseline

`data/demo.json`: empat label platform ChatGPT, Gemini, Claude, Perplexity; tiga DM berkode DM01–DM03, bukan tiga anggota tim. Enam kriteria: ketepatan isi, relevansi, keterlacakan referensi, kemudahan penggunaan, kecukupan akses (benefit skala 1–5), waktu penyelesaian simulasi (cost, menit, 1–60). Nama platform hanya label; tidak ada penilaian produk nyata.

Angka input disimpan sebelum hasil dihitung. Kriteria/bobot/matriks dapat diedit untuk demo; penambahan/penghapusan jumlah entitas melalui UI ditunda. Uji seri, cost, data salah dan permutasi memakai fixture tes, bukan memanipulasi seed agar pemenangnya diinginkan.

## Kontrak JSON

Input skenario:

```json
{"id":"demo-v1","name":"Skenario akademik simulasi","data_kind":"dummy",
 "alternatives":[{"id":"A1","name":"ChatGPT"}],
 "criteria":[{"id":"C1","name":"Ketepatan isi","type":"benefit","unit":"skor","min":1,"max":5}],
 "decision_makers":[{"id":"DM01","name":"Penilai simulasi 01","weights":[30],"matrix":[[4]]}]}
```

Contoh ini hanya menunjukkan bentuk payload; jumlah entitasnya belum memenuhi minimum validasi.

Respons perhitungan (ID/array mengikuti urutan input):

```text
{method_version, input_hash, data_kind:"dummy", alternatives, criteria,
 decision_makers:[{id,name,weights,normalized_weights,matrix,norms,R,V,C,D,F,G,E,
 concordance_sets: array[m][m] of criterion-ID arrays,
 discordance_sets: array[m][m] of criterion-ID arrays,
 threshold_c,threshold_d,outdegree,average_ranks,borda_points,no_discrimination}],
 borda:{totals,ranks,winner_ids,status}}
```

API:
- `GET /api/seed` → skenario seed.
- `GET /api/latest` → `{run:null}` atau `{run:{id,created_at,scenario,result}}`.
- `POST /api/calculate` JSON `{scenario: ...}` → `{run:{id,created_at,scenario,result}}`; validasi sebelum simpan; invalid 400 `{error: pesan}`.
- `GET /api/runs` → `{runs:[{id,created_at,name,input_hash}]}` terbaru dahulu.
- `GET /api/runs/<id>` → `{run:...}` atau 404.
- `GET /api/workbook` → workbook **dataset acuan**, bukan ekspor input yang sedang diedit; label ini wajib jelas di UI.
- `GET /api/health` → status dan method version.

## Komposisi UI

Surface utama **Compare/Inspect**: sidebar tahap, topbar judul+skenario, badge dummy, pemilih DM, toolbar hitung/seed/Excel. Area utama tabel lebar yang bisa di-scroll; bukan hero dan kartu dekoratif. Warna netral terang dengan aksen hijau gelap; font Segoe UI dipilih karena angka/tabel terbaca dan tersedia offline di Windows, angka tabular dengan monospace hanya pada matriks. Teks Indonesia.

Tab: Data & Bobot; Normalisasi; Concordance/Discordance; Dominasi; Borda; Riwayat. Angka hasil hanya dari API. Edit apa pun menandai hasil kedaluwarsa dan menonaktifkan tampilan hasil sampai hitung berhasil. Reset seed memerlukan konfirmasi dan tidak menghapus riwayat. Loading/error/empty dan tombol keyboard focus wajib. Nama input dirender dengan textContent/escaping, bukan HTML mentah.

## Penerimaan milestone

- Tes core mereproduksi acuan Modul 4 dan kasus benefit/cost/seri serta menolak input salah.
- Excel mempunyai formula seluruh tahap, cache dihitung oleh Excel asli, parity seluruh DM dan Borda lulus untuk seed dan input yang diubah.
- API nyata menghitung, menyimpan snapshot SQLite, dan membacanya kembali; error tidak menyimpan hasil palsu.
- Browser menampilkan semua tahap, memilih DM, mengedit/menghitung ulang, menandai stale, serta membuka riwayat.
- Tidak melaporkan selesai sebelum tes nyata; temuan dan batas yang tersisa ditulis di dokumen progres.

## Kepemilikan dan kejujuran

Area desain Safri; backend/database Erai; frontend Dimas. Implementasi saat ini dibantu AI terpusat. Tidak menyatakan ketiganya sudah mereview atau menulis perubahan ini. Tidak membuat commit beridentitas anggota atau push remote.
