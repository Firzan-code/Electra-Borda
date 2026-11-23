# Proyek UAS — GDSS ELECTRE dan Borda

**Judul:** Implementasi GDSS Menggunakan Metode ELECTRE dan Borda dalam Pemilihan Platform Artificial Intelligence untuk Mendukung Produktivitas Akademik Mahasiswa.

**Status saat ini (Progres 1 — 24 November 2026):** Tahap **Analisis, Perancangan Sistem, Validasi Rumus Excel, ERD, dan Desain UI Figma** telah selesai disusun sebagai fondasi bersama tim. Tahap implementasi aplikasi (Backend, Database fisik, dan Frontend) selanjutnya akan dikerjakan sesuai pembagian peran masing-masing anggota.

---

## Tim & Pembagian Peran

| Nama | NIM | Peran | Fokus Pengerjaan |
|---|---|---|---|
| **Safri Firzan Sururi** | 240605110084 | Ketua / Desain Sistem | Analisis kebutuhan, kebijakan metode, 7 diagram sistem, koordinasi |
| **Erai Bagusalim** | 240605110088 | Backend & Database | Implementasi database MySQL (berdasarkan ERD), mesin hitung ELECTRE–Borda, REST API |
| **Dimas Bagus Hari Murti** | 240605110080 | Frontend | Implementasi antarmuka web 6 tahap berdasarkan desain Figma & kontrak API |

---

## Artefak Progres 1 (Tersedia di Repository Ini)

### 1. Perancangan & Diagram Sistem
| Dokumen | Isi & Fungsi |
|---|---|
| [08 — ERD & Struktur Database](docs/08_ERD_DAN_STRUKTUR_DATABASE.md) | Entity-Relationship Diagram (9 tabel relasional 3NF) & kamus data lengkap |
| [09 — Diagram Sistem Lengkap](docs/09_DIAGRAM_SISTEM_LENGKAP.md) | Arsitektur sistem, Use Case, Activity, Sequence, DFD Level 0 & 1, dan Deployment |
| [05 — Keputusan & Kontrak API](docs/05_KEPUTUSAN_DAN_RENCANA_PROTOTIPE.md) | Kebijakan metode `electre-borda-v1`, spesifikasi dataset, dan kontrak API |
| [04 — Kebutuhan & Scope](docs/04_KEBUTUHAN_DAN_SCOPE_WEB_DUMMY.md) | Ruang lingkup aplikasi web, data dummy, dan kriteria kesesuaian Excel |
| [03 — Roadmap & Task Board](docs/03_ROADMAP_DAN_TASK_BOARD.md) | Urutan tahap pengerjaan dan status tugas tiap anggota |
| [02 — Pembagian Tim & Alur Kerja](docs/02_PEMBAGIAN_TIM_DAN_ALUR_KERJA.md) | Rincian tanggung jawab dan aturan pencatatan kontribusi |
| [01 — Analisis & Rancangan Awal](docs/01_ANALISIS_DAN_RANCANGAN_GDSS_ELECTRE_BORDA.md) | Referensi metodologi awal ELECTRE I dan Borda |

### 2. Acuan Data, Perhitungan Excel & Desain UI
- **Dataset Dummy Acuan:** [`data/demo.json`](data/demo.json) — 4 alternatif platform AI (*ChatGPT, Gemini, Claude, Perplexity*) × 6 kriteria (5 *benefit*, 1 *cost*) × 3 *Decision Maker* simulasi.
- **Workbook Excel Berformula:** [`deliverables/GDSS_ELECTRE_BORDA_Dummy.xlsx`](deliverables/GDSS_ELECTRE_BORDA_Dummy.xlsx) — perhitungan hidup seluruh tahapan ELECTRE per-DM (`R`, `V`, `C`, `D`, threshold, `F`, `G`, `E`, *outdegree*) hingga agregasi Borda (hasil acuan: *Claude* & *Perplexity* seri pada skor 5,0).
- **Desain UI 6 Layar (Figma — Acuan Frontend):** [Buka Kanvas Desain Figma (Editable Layers)](https://www.figma.com/design/3dLA0FcHxcKVQqQB7zYYDa?node-id=3-2)

---

## Panduan Pengerjaan Tahap Berikutnya (Implementasi)

1. **Backend & Database (Erai):**
   - Implementasikan skema MySQL 9 tabel mengacu pada [ERD & Kamus Data](docs/08_ERD_DAN_STRUKTUR_DATABASE.md).
   - Bangun mesin perhitungan ELECTRE–Borda dan REST API mengacu pada [Kontrak API](docs/05_KEPUTUSAN_DAN_RENCANA_PROTOTIPE.md) dan pastikan angka matriks cocok dengan [`GDSS_ELECTRE_BORDA_Dummy.xlsx`](deliverables/GDSS_ELECTRE_BORDA_Dummy.xlsx).
2. **Frontend (Dimas):**
   - Bangun antarmuka web 6 menu (*Data & Bobot, Normalisasi, Concordance/Discordance, Dominasi, Hasil Borda, Riwayat*) mengacu pada [Desain Figma](https://www.figma.com/design/3dLA0FcHxcKVQqQB7zYYDa?node-id=3-2) dan kontrak API backend.
3. **Catatan Data:**
   - Seluruh angka awal merupakan **DATA DUMMY / SIMULASI** untuk demonstrasi metode GDSS, bukan hasil survei mahasiswa atau klaim evaluasi empiris platform AI.
