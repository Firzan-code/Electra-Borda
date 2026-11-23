# Roadmap dan Task Board Proyek UAS

## 1. Status dan cara membaca

- **Sudah ditetapkan:** judul, anggota/peran, pengerjaan terpusat, **web application**, **data dummy**, Excel berformula ELECTRE dan hasil web yang sesuai Excel.
- **Ketentuan dosen:** menurut pengguna tidak ada ketentuan khusus tambahan; tidak menunggu pedoman lain untuk mulai desain.
- **Sudah tersedia:** analisis awal, pembagian tim, roadmap serta [kebutuhan aktif](04_KEBUTUHAN_DAN_SCOPE_WEB_DUMMY.md).
- **Baseline progres:** metode `electre-borda-v1`, seed `demo-v1`, Flask/SQLite/HTML-JS ditetapkan sebagai keputusan implementasi asisten pada [dokumen 05](05_KEPUTUSAN_DAN_RENCANA_PROTOTIPE.md), bukan klaim persetujuan dosen/review anggota.
- **Sudah diimplementasikan:** mesin hitung, API dan snapshot SQLite; tes awal core/API lulus.
- **Sedang dikerjakan:** workbook, frontend, integrasi, review dan bukti demo. Laporan/presentasi akhir belum selesai.

Dokumen ini merupakan rencana, bukan bukti implementasi. Dokumen 04 menggantikan usulan penelitian empiris pada [analisis awal](01_ANALISIS_DAN_RANCANGAN_GDSS_ELECTRE_BORDA.md). Input simulasi diperbolehkan; kebenaran perhitungannya diuji sungguhan.

Status task: `belum mulai`, `dikerjakan`, `terblokir`, `selesai teknis`, `disetujui`. Selesai teknis harus mempunyai artefak dan bukti pemeriksaan; status disetujui memerlukan review/konfirmasi, bukan otomatis karena file berhasil dibuat.

## 2. Roadmap bertahap

| Tahap | Fokus | Keluaran | Gerbang sebelum lanjut |
|---|---|---|---|
| 0 | Penyiapan koordinasi | README, pembagian tim, roadmap/task board | Identitas dan peran sesuai pesan pengguna; tautan dokumen valid |
| 1 | Kebutuhan dan kebijakan metode | Scope web/dummy/Excel, fitur minimum, kriteria kesesuaian dan keputusan metode | L-01 terdokumentasi; L-02 dikunci sebelum membuat perhitungan UAS |
| 2 | Desain sistem dan dataset simulasi | Spesifikasi metode, use case, activity, arsitektur, ERD, API, wireframe dan definisi data dummy | Stack/kontrak/data disepakati; tidak menunggu survei |
| 3 | Workbook dan validasi perhitungan | Excel UAS berformula ELECTRE–Borda, referensi Python dan kasus uji | Matriks perantara dan hasil cocok; formula hidup setelah perubahan input |
| 4 | Backend dan database | Mesin metode teruji, migrasi, penyimpanan, endpoint, validasi, audit/ekspor sesuai scope | API benar-benar dijalankan; round-trip data dan perhitungan lulus uji |
| 5 | Frontend | Form, navigasi, tampilan per-DM, graf/matriks, Borda, kondisi error/seri | Alur utama berjalan melalui API nyata; mock hanya berlabel dan bukan hasil penelitian |
| 6 | Integrasi dan demo | Uji end-to-end, parity Excel–web, perubahan input dan perbaikan bug | Kriteria dokumen 04 teruji; hasil simulasi selalu berlabel |
| 7 | Laporan, presentasi, paket akhir | Laporan/slide/demo, source, workbook dan README menjalankan aplikasi | Angka berasal dari eksekusi pada dummy yang sama; bukan klaim survei/benchmark nyata |

Urutan utama: **0 → 1 → 2 → 3 → 4 → 5 → 6 → 7**.

Jalur data aktif: **definisi skenario → dataset dummy deterministik → validasi input → pembekuan versi → Excel/Python → web**. Tidak ada gerbang rekrutmen, pilot manusia, survei, atau data utama nyata. Jika dilakukan, sensitivitas adalah uji software atas skenario sintetis.

**Target:** pengguna meminta progres minggu depan. Tanggal/jam progres belum diberikan; target pekerjaan saat ini prototipe lokal yang dapat didemonstrasikan, bukan menyatakan seluruh UAS selesai.

## 3. Task board

Kode: **L** = Safri Firzan Sururi (ketua/desain), **BE** = Erai Bagusalim (backend/database), **FE** = Dimas Bagus Hari Murti (frontend). Task lintas area memakai penanggung jawab utama di bawah dan reviewer terkait. Implementasi dibantu terpusat di sini.

| ID | Tahap | Penanggung jawab | Task dan acceptance criteria | Dependensi | Status |
|---|---:|---|---|---|---|
| L-00 | 0 | Safri | Dokumen koordinasi memuat identitas/peran persis, alur terpusat, roadmap, dan status keputusan terbuka | Pesan pembagian pengguna | Selesai teknis |
| L-01 | 1 | Safri | Dokumentasikan web, dummy, Excel berformula, kesesuaian tabel dan batas klaim; pisahkan kebutuhan pengguna dari rekomendasi | L-00 | Selesai teknis |
| L-02 | 1 | Safri | Kunci varian ELECTRE, threshold, ranking, Borda, bobot DM, seri, presisi/toleransi dan validasi sebelum perhitungan UAS dibuat | L-01 | Selesai teknis |
| L-03 | 2 | Safri | Definisikan alternatif, DM simulasi, kriteria/arah, skala/satuan, bobot dan format dummy; tidak mengaku data empiris | L-02 | Selesai teknis |
| L-04 | 2 | Safri | Arsitektur, use case, activity diagram, stack dan batas antarkomponen terdokumentasi; tidak ada logika keputusan ganda di frontend | L-01, L-02 | Selesai teknis |
| BE-01 | 2 | Erai | ERD, integritas relasi, rancangan migrasi, kontrak request/response/error dan versi hasil ditinjau bersama desain | L-03, L-04 | Selesai teknis |
| FE-01 | 2 | Dimas | Wireframe dan alur layar mencakup input belum lengkap, proses per-DM, agregasi, seri, hasil dan error; field cocok dengan kontrak | L-04, BE-01 | Selesai teknis |
| BE-02 | 3 | Erai | Buat Excel UAS berformula dan hitung ulang; cocokkan bobot, R/V/C/D/F/G/E, threshold, ranking dan Borda dengan referensi Python | L-02, L-05 | Selesai teknis |
| BE-03 | 4 | Erai | Mesin hitung terpisah dari web/database, tervalidasi dan memiliki tes; nilai acuan tidak diubah demi meluluskan tes | BE-02 | Belum mulai (dikerjakan Erai) |
| BE-04 | 4 | Erai | Skenario, input/bobot/parameter dan snapshot hasil lolos uji simpan-baca; versi serta label simulasi dipertahankan | BE-01, L-05 | Belum mulai (dikerjakan Erai) |
| BE-05 | 4 | Erai | Jalankan API data/perhitungan, validasi/error dan hasil kedaluwarsa; runtime tidak bergantung Office; ekspor dinamis opsional | BE-03, BE-04 | Belum mulai (dikerjakan Erai) |
| FE-02 | 5 | Dimas | Layout, navigasi, form dan validasi tampil sesuai wireframe Figma; state loading/error/kosong teruji | FE-01, BE-05 | Belum mulai (dikerjakan Dimas) |
| FE-03 | 5 | Dimas | Tabel ELECTRE/Borda dari API dapat dipetakan ke Excel; tampilkan seri dan matriks E, tanpa hasil hard-code; graf visual opsional | FE-02 | Belum mulai (dikerjakan Dimas) |
| L-05 | 2 | Safri, dibantu tim | Buat dummy acuan deterministik ber-ID/versi dan fixture kasus tepi; cek kelengkapan/skala serta label simulasi | L-03 | Selesai teknis |
| L-06 | 6 | Safri, review Erai/Dimas | Uji demo end-to-end, parity Excel–web pada data dasar/perubahan input, invalid input, seri dan penyimpanan; catat hasil tes software nyata | BE-05, FE-03, BE-02 | Belum mulai |
| L-07 | 7 | Safri, bagian teknis oleh Erai/Dimas | Laporan dan demo konsisten dengan implementasi serta data; kontribusi/review dan bantuan AI dicatat sesuai kenyataan | L-06 | Belum mulai |
| L-08 | 7 | Safri, dibantu tim | Paket akhir sesuai ketentuan; perintah instalasi/menjalankan diuji, seluruh file dapat dibuka, tidak ada rahasia/data pribadi tak perlu | L-07 | Belum mulai |

**Perubahan L-05:** task pilot/data nyata diganti task dataset dummy sesuai arahan pengguna, bukan ditandai selesai. Dependensi BE-02 dan BE-04 menunggu dataset tersebut.

Dependensi adalah batas minimum kesiapan, bukan izin melompati urutan utama. Pengerjaan paralel lintas area dapat diputuskan setelah kontrak disetujui, tetapi tidak diwajibkan dalam alur terpusat ini.

## 4. Keputusan yang perlu dikunci

| ID | Pertanyaan | Posisi sekarang | Dampak |
|---|---|---|---|
| K-01 | Bentuk produk, data dan ketentuan dosen? | Terjawab: web, dummy, Excel ELECTRE dan hasil seperti Excel; tidak ada ketentuan khusus tambahan menurut pengguna | Scope dokumen 04 aktif; deadline belum diberikan |
| K-02 | Borda ordinal atau varian skor × bobot posisi seperti contoh Modul 7? | Analisis merekomendasikan ordinal; belum dikonfirmasi | Mengubah definisi hasil dan implementasi |
| K-03 | Bagaimana graf ELECTRE menjadi ranking dan bagaimana seri ditangani? | Usulan outdegree, seri dipertahankan, poin posisi rata-rata | Harus ditulis sebagai kebijakan tambahan, bukan ranking otomatis ELECTRE |
| K-04 | Alternatif, DM, kriteria dan angka dummy? | Dibekukan pada L-03/L-05; kandidat lama masih usulan | Dataset stabil, skala dan label simulasi jelas |
| K-05 | Framework backend/frontend, database, akses lokal/online dan autentikasi? | Belum dipilih | Menentukan setup, keamanan, migrasi, dan deployment |
| K-06 | Apa klaim hasil yang diperbolehkan? | Demo algoritma pada data dummy, bukan pengukuran platform/manusia nyata | Tidak mengklaim platform terbaik empiris atau peningkatan produktivitas |
| K-07 | Presisi dan toleransi kesesuaian Excel–web? | Dibekukan pada L-02 sebelum nilai acuan dibuat | Nilai diskret harus cocok tepat; bilangan riil mengikuti aturan perbandingan tertulis |

Anggota pengembang **tidak otomatis menjadi DM**. Gunakan kode penilai simulasi; tidak perlu mengarang responden nyata atau memakai NIM anggota sebagai bukti evaluasi.

## 5. Kriteria selesai yang berlaku umum

Sebuah task hanya menjadi `selesai teknis` ketika:

1. Artefaknya tersedia pada path yang disebutkan dan tidak merusak pekerjaan sebelumnya.
2. Identitas, kontrak data, dan kebijakan metode sesuai keputusan yang berlaku.
3. Pemeriksaan yang relevan benar-benar dijalankan dan hasilnya dicatat; untuk dokumen, cek isi/tautan/status; untuk kode, tes; untuk UI, interaksi aplikasi nyata.
4. Data dummy berlabel dan hasil dihitung sungguhan; tidak mengarang hasil eksekusi, fitur berjalan, survei atau benchmark nyata.
5. Bloker dan keterbatasan disampaikan jelas, bukan ditutup dengan status selesai.

Khusus metode: hasil akhir sama saja tidak cukup; matriks perantara, arah cost/benefit, threshold off-diagonal, penanganan nol, seri, dan invariansi terhadap susunan alternatif/DM perlu diuji. Pengurutan berdasarkan ID hanya boleh untuk tampilan, tidak untuk memecah seri substantif.

## 6. Log tahap

| Tahap/task | Hasil yang benar-benar tersedia | Verifikasi | Batas status |
|---|---|---|---|
| Analisis awal | Dokumen 01 | Dibaca sebagai rujukan metodologi | Usulan studi empiris merupakan riwayat di luar scope saat ini |
| L-00 | README + dokumen 02 dan 03 | Identitas, task ID/dependensi, tautan dan konsistensi status diperiksa saat penyiapan | Dokumentasi koordinasi saja; belum implementasi |
| L-01 | Dokumen 04 + sinkronisasi dokumen aktif | Kebutuhan, peta workbook, tautan, dependensi dan status diperiksa | Dokumentasi saja; bukan dataset, workbook UAS atau aplikasi |

**Status milestone progres:** pekerjaan lintas task prototipe berlangsung mengikuti dokumen 05. Task hanya ditandai selesai setelah cakupan acceptance criteria-nya benar-benar diperiksa; review anggota tetap belum dilakukan. Buku kerja, frontend dan parity belum dinyatakan lulus sebelum hasilnya tersedia.
