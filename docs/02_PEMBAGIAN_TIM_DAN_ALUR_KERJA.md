# Pembagian Tim dan Alur Kerja Terpusat

## 1. Dasar keputusan

Pembagian berikut diberikan langsung oleh pengguna dan dipertahankan persis:

```text
Safri Firzan Sururi_240605110084 : Ketua / desain sistem
Erai Bagusalim_240605110088 : Backend dan database
Dimas Bagus Hari Murti_240605110080 : Frontend
```

Seluruh task dibantu pengerjaannya melalui percakapan Hermes ini. Tidak diperlukan perpindahan percakapan atau penyerahan ke agent milik anggota lain. Penanggung jawab tetap dibedakan agar desain, implementasi, peninjauan, dan persiapan presentasi terstruktur.

**Scope terbaru:** pengguna menetapkan web application dengan data dummy dan workbook Excel ELECTRE; hasil web harus dapat dicocokkan dengan Excel. Lihat [kebutuhan aktif](04_KEBUTUHAN_DAN_SCOPE_WEB_DUMMY.md). Survei dan pengujian platform nyata tidak menjadi tugas wajib.

**Batas keputusan:** pembagian tim dan scope ini bukan persetujuan otomatis atas seluruh usulan metode, stack, daftar platform, jumlah DM simulasi, atau kriteria pada [analisis awal](01_ANALISIS_DAN_RANCANGAN_GDSS_ELECTRE_BORDA.md).

## 2. Tanggung jawab tiap anggota

| Area | Penanggung jawab | Ruang lingkup yang direncanakan | Bukti hasil yang diperlukan |
|---|---|---|---|
| Ketua / desain sistem | Safri Firzan Sururi — 240605110084 | Kebutuhan dan batas proyek; rumusan masalah; alur GDSS; keputusan metode; use case, aktivitas, dan arsitektur; koordinasi integrasi; persetujuan perubahan; konsistensi laporan | Dokumen keputusan, diagram, spesifikasi yang disetujui, hasil review dan penerimaan tahap |
| Backend dan database | Erai Bagusalim — 240605110088 | Mesin ELECTRE dan Borda; validasi input; model data dan relasi; migrasi; penyimpanan sesi/penilai/bobot/penilaian; API; audit perhitungan; ekspor dan pengujian backend | Kode, skema/ERD, migrasi, kontrak API, tes kasus normal/tepi, bukti hasil perhitungan |
| Frontend | Dimas Bagus Hari Murti — 240605110080 | Wireframe; navigasi; form konfigurasi dan penilaian; tampilan matriks/graf/peringkat; penanganan seri dan data belum lengkap; integrasi API; pengujian interaksi dan tampilan | Wireframe, komponen/halaman, koneksi ke API, bukti uji alur pengguna dan tampilan |

Rincian teknis di atas merupakan turunan rencana dari peran yang sudah ditetapkan. Jenis halaman, endpoint, tabel, dan teknologi final baru dikunci pada tahap desain; bukan fitur yang sudah selesai.

### 2.1 Safri — Ketua / desain sistem

- Memastikan ketentuan dosen dan batas keluaran tercatat.
- Menyetujui varian ELECTRE, cara membentuk ranking individual, Borda, serta aturan seri sebelum implementasi.
- Menjaga konsistensi antara metode, basis data, API, tampilan, dan laporan.
- Meninjau hasil setiap tahap dan mengoordinasikan koreksi lintas area.
- Menyiapkan narasi masalah, desain, batas klaim, dan alur demonstrasi.

### 2.2 Erai — Backend dan database

- Memisahkan mesin perhitungan dari framework web dan penyimpanan agar dapat diuji langsung.
- Menyimpan input per decision maker, bobot, parameter, versi perhitungan, dan hasil perantara secara tertelusur.
- Menerapkan validasi kelengkapan, finite values, benefit/cost, bobot, dan pembagian nol sesuai spesifikasi final.
- Menyediakan kontrak API serta penanganan error yang dapat digunakan frontend.
- Memastikan seluruh dataset, hasil API dan simpanan berlabel simulasi; menjaga versi input/hasil dan kesesuaian dengan workbook, tanpa mengaku data mahasiswa nyata.

### 2.3 Dimas — Frontend

- Mendesain halaman berdasarkan kebutuhan yang disepakati, bukan menambahkan fitur tanpa batas.
- Menggunakan hasil backend sebagai sumber perhitungan; tidak membuat rumus ELECTRE/Borda kedua di UI.
- Menampilkan kondisi loading, error, data belum lengkap, seri, dan hasil tanpa pembedaan secara jelas.
- Memastikan tabel panjang, label, navigasi, dan form tetap terbaca pada ukuran layar yang diuji.
- Menyiapkan tampilan demonstrasi dengan label data yang benar.

## 3. Cara seluruh pekerjaan dilakukan di sini

Siklus kerja untuk setiap task:

```text
Pilih task dan penanggung jawab
  -> baca keputusan serta artefak sebelumnya
  -> tulis rancangan/perubahan yang diperlukan
  -> konfirmasi keputusan penting yang masih terbuka
  -> implementasi atau pembuatan artefak
  -> jalankan pemeriksaan nyata
  -> laporkan hasil, bukti, dan keterbatasan
  -> perbarui task board
```

1. Satu task memiliki satu penanggung jawab utama; task lintas area memiliki reviewer yang disebutkan.
2. Hermes membantu seluruh area dalam workspace yang sama. Jika ada delegasi teknis internal, itu tetap bantuan AI, bukan bukti anggota telah mengerjakan sendiri.
3. Untuk perubahan besar, rencana tertulis lebih dahulu. Perubahan identitas, metode, kontrak API, atau scope harus dicatat; jangan mengubah diam-diam agar tes lulus.
4. Satu tahap utama dikerjakan dahulu sampai hasilnya dapat diperiksa. Pekerjaan paralel hanya bila dependensinya sudah tersedia dan file yang disentuh tidak berbenturan.
5. Laporan progres di percakapan cukup menyebut task, perubahan, pemeriksaan yang benar-benar dijalankan, dan hal yang masih terbuka.
6. Tidak mengirim pesan ke anggota, memublikasikan repositori, melakukan deployment berbayar, atau mengumpulkan tugas tanpa instruksi pengguna.

## 4. Aturan pencatatan kontribusi

- Kolom penanggung jawab menunjukkan tanggung jawab area, bukan bukti otomatis siapa yang mengetik setiap baris kode.
- Catat penulisan/pengujian berbantuan AI dan review manusia sesuai kenyataannya serta aturan dosen.
- Jangan membuat commit dengan identitas anggota lain untuk mensimulasikan pembagian kontribusi.
- Jangan menandai review Erai/Dimas/Safri selesai sebelum ada review yang benar-benar dilakukan atau konfirmasi dari anggota/pengguna.
- Bedakan **artefak selesai secara teknis**, **sudah diuji**, dan **sudah ditinjau/disetujui anggota**.

Format catatan kerja yang dipakai ketika eksekusi dimulai:

| Task ID | Penanggung jawab area | Pekerjaan aktual / bantuan AI | Artefak | Bukti uji | Reviewer dan hasil | Status |
|---|---|---|---|---|---|---|
| Belum diisi | — | Diisi berdasarkan aktivitas nyata, bukan estimasi kontribusi | — | — | — | — |

## 5. Batas pemisahan area

- **Desain:** mengatur kebutuhan, diagram, kebijakan metode, dan acceptance criteria.
- **Mesin metode:** menghitung dari input tervalidasi; tidak bergantung pada UI atau database.
- **Backend:** memanggil mesin metode, memvalidasi permintaan, dan mengelola penyimpanan/otorisasi sesuai kebutuhan final.
- **Database:** menjaga struktur, integritas relasi, versi input, serta jejak perhitungan.
- **Frontend:** menampilkan dan mengirim data melalui kontrak API; rumus domain tidak diduplikasi.
- **Laporan/presentasi:** dibuat bersama sesuai area masing-masing; hanya menyatakan hasil yang sudah dibuktikan.

Nama direktori implementasi dan framework belum dibekukan. Pembagian file konkret dibuat saat arsitektur disepakati.

## 6. Hubungan dengan roadmap

Urutan eksekusi, dependensi, task ID, dan syarat selesai ada pada [03 — Roadmap dan Task Board](03_ROADMAP_DAN_TASK_BOARD.md). Belum ada tenggat atau perhitungan persentase kontribusi; keduanya tidak dibuat tanpa keputusan dan bukti.
