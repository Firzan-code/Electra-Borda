# Tahap 1 — Kebutuhan dan Scope Web Application

## 1. Keputusan terbaru pengguna

Pernyataan sumber:

> next 1, tidak ada ketentuan khusus dari dosen, tapi bentuk nya adalah web application, menggunakan data dummy, dan harus mencakup metode electre pada excel nya, intinya dia menampilkan hasil seperti di excel

Kebutuhan yang telah dikonfirmasi:

| ID | Kebutuhan | Konsekuensi |
|---|---|---|
| U-01 | Tidak ada ketentuan khusus dari dosen menurut pengguna | Tidak menunggu dokumen pedoman tambahan untuk melanjutkan; jangan mengarang ketentuan baru |
| U-02 | Produk berbentuk web application | Harus dapat digunakan melalui browser, bukan hanya script, notebook, atau Excel |
| U-03 | Menggunakan data dummy | Data simulasi sah untuk tugas ini; survei, rekrutmen mahasiswa, dan pengujian platform nyata bukan syarat |
| U-04 | Menyertakan metode ELECTRE pada Excel | Deliverable mencakup workbook `.xlsx` berformula dengan tahapan ELECTRE, bukan hanya hasil akhir yang ditempel |
| U-05 | Web menampilkan hasil seperti Excel | Input, metode, tabel proses, dan hasil harus dapat dicocokkan; tampilan boleh disesuaikan untuk web |

**Status dokumen:** kebutuhan eksplisit di atas telah dikonfirmasi melalui pesan pengguna. Rincian MVP dan kriteria penerimaan di bawah merupakan penjabaran kebutuhan untuk review, bukan fitur yang sudah dibuat. Spesifikasi algoritma rinci masih harus dikunci melalui task L-02.

**Prioritas sumber:** pesan terbaru pengguna → dokumen 04 ini → roadmap aktif → pembagian tim → analisis awal. Usulan studi empiris dalam dokumen 01 bukan lagi scope aktif.

Judul tetap: **Implementasi GDSS Menggunakan Metode ELECTRE dan Borda dalam Pemilihan Platform Artificial Intelligence untuk Mendukung Produktivitas Akademik Mahasiswa.** Borda tidak dihapus hanya karena kebutuhan Excel terbaru menekankan ELECTRE.

## 2. Tujuan proyek

Membangun aplikasi web untuk mendemonstrasikan alur keputusan kelompok menggunakan data dummy platform AI: input per penilai simulasi → ELECTRE per penilai → ranking turunan → agregasi Borda → rekomendasi **pada skenario simulasi tersebut**. Proses ditampilkan sebagai tabel yang dapat diperiksa terhadap workbook Excel.

Ukuran keberhasilan adalah **kebenaran implementasi, kesesuaian Excel–web, dan keterlacakan perhitungan**, bukan akurasi penilaian platform di dunia nyata atau bukti peningkatan produktivitas mahasiswa.

Label wajib pada aplikasi, workbook, dan laporan hasil:

> DATA DUMMY / SIMULASI — nilai dibuat untuk demonstrasi metode, bukan hasil survei atau benchmark platform AI.

## 3. Arti “menampilkan hasil seperti di Excel”

### 3.1 Kesamaan yang wajib

- Menggunakan dataset/skenario, ID alternatif, ID penilai, kriteria, jenis benefit/cost, bobot, serta kebijakan perhitungan yang sama.
- Menampilkan nilai input, hasil perantara, parameter threshold, dan hasil akhir, bukan hanya kartu pemenang.
- Menjaga urutan label baris/kolom yang dapat dipetakan. Jika tabel diurutkan di UI, pemeriksaan tetap memakai ID, bukan posisi layar semata.
- Menjelaskan rumus dan setidaknya contoh substitusi yang diperlukan untuk menelusuri hasil.
- Menghitung ulang saat input berubah. Data input boleh dummy; **hasil perhitungan tidak boleh di-hard-code** atau berupa screenshot statis.
- Menampilkan seri dan kondisi tidak ada pembedaan secara jujur; tidak memaksakan pemenang tunggal.

### 3.2 Yang tidak diwajibkan

- Meniru huruf kolom, grid, ribbon, warna, atau koordinat sel Excel secara pixel-perfect.
- Mengubah aplikasi menjadi editor spreadsheet umum.
- Menjalankan Microsoft Excel/COM pada server ketika pengguna menekan tombol hitung.
- Mengimpor sembarang file Excel pada MVP.

Workbook merupakan artefak referensi yang dihitung melalui formula Excel. Aplikasi menghitung melalui mesin backend sendiri berdasarkan spesifikasi yang sama, lalu keduanya dibandingkan. Menyalin hasil backend ke semua sel Excel tanpa formula bukan validasi independen.

## 4. Pengguna dan alur minimum

**Pengguna aplikasi:** operator/presenter demo. Decision maker (DM) adalah entitas penilai simulasi yang dipilih melalui UI, bukan akun mahasiswa nyata. Default MVP yang disarankan adalah satu operator lokal tanpa login; kebutuhan akun dan deployment publik dapat ditinjau pada tahap arsitektur.

```text
Buka aplikasi
  -> muat skenario dummy
  -> lihat/ubah alternatif, kriteria, penilai, bobot dan matriks
  -> validasi input
  -> hitung ELECTRE untuk setiap DM
  -> telusuri tabel proses dan ranking individual
  -> lihat agregasi Borda dan hasil kelompok
  -> cocokkan dengan workbook untuk skenario yang sama
```

Perubahan input setelah perhitungan harus menandai hasil lama sebagai tidak berlaku sampai dihitung ulang. Setiap hasil menyimpan versi/snapshot input agar hasil web tidak dibandingkan dengan workbook dari skenario lain.

## 5. Ruang lingkup MVP yang direncanakan

| ID | Fitur | Keluaran dan penerimaan |
|---|---|---|
| F-01 | Muat data dummy yang tetap | Skenario awal ber-ID/versi; pemuatan ulang menghasilkan input yang sama; reset perlu konfirmasi sebelum menimpa perubahan |
| F-02 | Data alternatif dan kriteria | Daftar platform sebagai label simulasi, kriteria, arah benefit/cost, skala/satuan, serta bobot dapat diperiksa dan diedit sesuai desain |
| F-03 | Penilai simulasi | Pilih DM dan lihat matriks serta bobot miliknya; penilaian tiap DM tidak dicampur sebelum ELECTRE |
| F-04 | Validasi input | Input kosong/tidak numerik/non-finite, bobot tidak sah, atau ukuran matriks tidak cocok menghasilkan pesan yang jelas; tidak dianggap nol diam-diam |
| F-05 | Perhitungan ELECTRE lengkap | Semua tahapan pada bagian 6 tersedia per DM dan berasal dari proses hitung |
| F-06 | Agregasi Borda | Poin per DM, total per alternatif, ranking dan seri terlihat; kebijakan rinci mengikuti L-02 |
| F-07 | Penyimpanan skenario | Input, parameter dan hasil yang terkait tersimpan di database; uji simpan-baca diperlukan, bukan hanya state sementara browser |
| F-08 | Kesesuaian dengan Excel | Workbook berformula untuk dataset acuan; tabel Excel–web dipetakan dan diuji hingga hasil akhir |

Mengunduh workbook acuan dari halaman bantuan/validasi dapat dimasukkan sebagai kemudahan. **Ekspor workbook dinamis untuk setiap perubahan input, impor Excel umum, dan halaman pemeriksa sel otomatis di UI bukan kewajiban eksplisit saat ini**; fitur-fitur tersebut tidak menjadi alasan menunda MVP.

## 6. Tabel yang harus tersedia di Excel dan web

Nama simbol final harus konsisten dan dijelaskan; jangan mengandalkan label huruf yang ambigu dari workbook lama.

| Urutan | Blok yang ditampilkan | Isi minimum |
|---|---|---|
| 1 | Data dasar | Alternatif, kriteria, benefit/cost, DM dan penanda data simulasi |
| 2 | Bobot | Bobot mentah dan bobot ternormalisasi per DM |
| 3 | Matriks keputusan X | Nilai setiap alternatif pada setiap kriteria untuk DM terpilih |
| 4 | Normalisasi R | Penyebut normalisasi tiap kolom dan matriks hasil normalisasi |
| 5 | Matriks terbobot V | Perkalian R dengan bobot kriteria |
| 6 | Himpunan concordance/discordance | Kriteria yang mendukung/tidak mendukung setiap pasangan alternatif |
| 7 | Matriks indeks C dan D | Nilai concordance serta discordance untuk pasangan yang valid |
| 8 | Threshold | Nilai ambang dan dasar perhitungannya |
| 9 | Dominasi F dan G | Perbandingan indeks dengan threshold yang dipilih |
| 10 | Aggregate dominance E | Relasi outranking dan diagonal yang ditangani eksplisit |
| 11 | Ringkasan individual | Skor ringkasan/posisi dan seri; tetap dapat menelusuri matriks E |
| 12 | Borda kelompok | Posisi/poin per DM, total, ranking dan rekomendasi simulasi |

Graf outranking visual merupakan tambahan yang berguna, tetapi matriks E yang lengkap sudah wajib sebagai bukti relasi. Jangan menahan MVP hanya untuk graf dekoratif.

### 6.1 Acuan yang telah diperiksa

Workbook Modul 4 dibaca tanpa diubah:

`../../Modul 4/240605110084_Safri Firzan Sururi_Praktikum SI A_Praktikum 4.xlsx`

Sheet `Sheet1` memuat blok berikut:

| Blok acuan Modul 4 | Lokasi data utama |
|---|---|
| Bobot mentah / ternormalisasi | C4:C7 / C12:C15 |
| Matriks numerik X | F11:I14 |
| Matriks R / V | F19:I22 / F26:I29 |
| Himpunan pasangan | K4:L15 / K22:L33 |
| Matriks indeks concordance / discordance | P4:S7 / P20:S23 |
| Threshold concordance / discordance | P9 / P25 |
| Dominasi concordance / discordance | P14:S17 / P29:S32 |
| Aggregate dominance / total baris | W4:Z7 / AA4:AA7 |

Audit baca-saja menggunakan Python menghitung ulang kasus numerik Modul 4, dengan semua kriteria pada matriks yang telah dipetakan diperlakukan benefit. Nilai R, V, C dan D off-diagonal, E, serta threshold cocok dengan cache tersimpan pada kasus itu. Ini **bukan** verifikasi workbook UAS atau aplikasi yang belum dibuat.

Beberapa himpunan dan rujukan formula workbook lama bersifat manual/kasus-spesifik. UAS mengikuti struktur tahapan dan metode yang diverifikasi, **bukan menyalin kelemahan formula lama**. Workbook UAS wajib tetap konsisten setelah perubahan input uji; sel kosong tidak boleh dijadikan pengganti hasil nol tanpa alasan.

## 7. Dataset dummy

- Buat satu dataset acuan yang deterministik, ber-ID/versi, dan dapat dipakai ulang di Excel, backend dan UI.
- Nilai, bobot, dan profil DM adalah sintetis; tidak perlu mencari harga, fitur, atau performa terbaru produk untuk memberi kesan seolah-olah datanya empiris.
- Nama ChatGPT, Gemini, Claude, dan Perplexity dapat dipakai sebagai calon label alternatif sesuai analisis awal; daftar final belum dibekukan.
- DM memakai kode seperti `DM01`, bukan identitas anggota tim atau mahasiswa nyata tanpa kebutuhan.
- Jumlah DM, alternatif, kriteria, skala dan angka dummy ditentukan pada L-03. Anggota pengembang tidak otomatis menjadi DM.
- Jika menggunakan kriteria waktu/biaya, nyatakan satuan dan bahwa nilainya simulasi. Hindari penyebutan durasi/biaya itu sebagai hasil pengukuran atau tarif aktual.
- Tidak perlu dataset acak baru setiap kali tombol hitung ditekan. Variasi kasus uji disimpan sebagai fixture tersendiri dan tetap berlabel dummy.

## 8. Kebijakan metode yang belum dikunci

Rekomendasi analisis awal tetap:

**ELECTRE per DM → graf E → ringkasan outdegree dengan seri → Borda ordinal → hasil kelompok.**

Ini rekomendasi untuk L-02, bukan klaim bahwa pengguna telah menyetujui seluruh formulanya. Pada L-02 perlu dibekukan:

- Varian ELECTRE dan arah benefit/cost; normalisasi/bobot dan definisi discordance.
- Threshold rata-rata off-diagonal atau kebijakan lain yang dipilih sebelum melihat hasil.
- Outdegree sebagai kebijakan tambahan untuk membentuk ranking; ELECTRE tidak otomatis memberi ranking total unik.
- Borda ordinal dibanding varian skor × posisi pada Modul 7; jangan mencampur keduanya.
- Perlakuan seri individual, seri akhir, bobot DM dan batas jumlah alternatif/DM.
- Penanganan pembagian nol, data tidak valid, presisi dan perbandingan dekat threshold.

Tidak ada kebutuhan dosen yang memaksa varian skor × posisi berdasarkan informasi terbaru. Baseline ordinal direkomendasikan, tetapi keputusan metode dicatat tersendiri sebelum implementasi.

## 9. Rencana penerimaan Excel–web

**Semua kriteria di bawah adalah tes yang akan dijalankan, belum hasil tes aplikasi.**

| ID | Skenario penerimaan | Syarat lulus |
|---|---|---|
| AC-01 | Jalankan demo dari awal | Aplikasi bisa dibuka, skenario terisi, label dummy terlihat, perhitungan tidak bergantung pada Office di runtime |
| AC-02 | Cocokkan input | ID, skala, arah kriteria, bobot, nilai matriks dan kebijakan identik antara fixture, workbook dan aplikasi |
| AC-03 | Cocokkan seluruh proses | Bobot, R, V, himpunan, C, D, threshold, F, G, E, skor/rank individual dan Borda sesuai pemetaan, bukan hanya pemenangnya |
| AC-04 | Nilai numerik dan diskret | Bilangan riil dibanding dengan toleransi yang dibekukan di L-02; himpunan, flag biner, keanggotaan kelompok seri dan ranking harus cocok tepat |
| AC-05 | Ubah satu nilai/bobot | Salin perubahan yang sama ke Excel dan web; keduanya menghitung ulang, hasilnya cocok, hasil versi lama tidak disajikan sebagai terbaru |
| AC-06 | Input gagal validasi | Perhitungan ditolak dengan pesan spesifik, tidak ada NaN/Infinity atau hasil palsu |
| AC-07 | Seri dan tanpa pembedaan | Semua alternatif terkait tetap terlihat; tidak ada pemenang yang dipilih karena nama atau urutan baris |
| AC-08 | Simpan dan buka kembali | Skenario dan snapshot hasil terhubung pada input yang benar setelah aplikasi dimuat ulang |
| AC-09 | Workbook hidup | Sel hasil memuat formula/rujukan yang benar, sudah dihitung ulang oleh Excel, tidak menyimpan hasil hard-code atau cache kosong sebagai bukti sukses |
| AC-10 | Demo dan laporan | Angka dapat ditelusuri ke skenario/versi yang sama; tidak mengklaim survei, benchmark nyata, konsensus manusia, atau peningkatan produktivitas |

Tampilan desimal Excel dan web memakai aturan yang sama setelah ditentukan. Pembulatan tampilan tidak boleh dipakai sebagai nilai masukan tahap berikutnya. Tidak menyatakan “persis sama” hanya karena kedua angka terlihat sama setelah dibulatkan.

## 10. Di luar scope awal

- Survei mahasiswa, pilot instrumen empiris, wawancara, dan pengumpulan data utama nyata.
- Pengujian kualitas/biaya/waktu aktual platform AI atau pengukuran produktivitas manusia.
- Integrasi API ChatGPT/Gemini/Claude/Perplexity, pembuatan chatbot, training model ML, pembayaran/langganan.
- Deployment publik, domain berbayar, registrasi pengguna dan manajemen akun kompleks, kecuali nanti diminta.
- Editor Excel penuh, impor bebas format, dan sinkronisasi Office langsung dengan setiap sesi web.

Laporan/presentasi masih disiapkan sebagai bagian roadmap penyerahan proyek, tetapi format khusus, jumlah halaman, dan deadline tidak ditetapkan oleh pengguna saat ini.

## 11. Keluaran tahap 1 dan langkah berikutnya

**Sudah dikerjakan pada tahap ini:** kebutuhan eksplisit dicatat, scope simulasi dan MVP dijabarkan, tabel Excel dipetakan, kriteria penerimaan direncanakan, serta roadmap diselaraskan.

**Belum dikerjakan:** dataset UAS final, workbook UAS, database, aplikasi dan uji Excel–web. Audit baca-saja terhadap Modul 4 tidak boleh dilaporkan sebagai pengujian proyek UAS.

**Task L-01:** selesai teknis pada dokumentasi kebutuhan. **Task L-02:** berikutnya mengunci kebijakan metode. Setelah itu masuk Tahap 2 untuk dataset dummy, stack, ERD, kontrak API dan wireframe. Tidak memulai scaffold/coding atau memilih framework diam-diam dalam tahap ini.
