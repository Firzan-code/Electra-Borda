# Analisis dan Rancangan Awal Proyek UAS

## Implementasi GDSS Menggunakan Metode ELECTRE dan Borda dalam Pemilihan Platform Artificial Intelligence untuk Mendukung Produktivitas Akademik Mahasiswa.

**Status:** analisis awal sebagai rujukan metodologi dan riwayat usulan; belum ada implementasi aplikasi atau hasil penelitian.

> **Pembaruan scope dari pengguna:** produk adalah **web application dengan data dummy**, disertai **Excel berformula ELECTRE** dan hasil web yang dapat dicocokkan dengan Excel; tidak ada ketentuan khusus tambahan dari dosen menurut pengguna. Kebutuhan aktif ada pada [04 — Kebutuhan dan Scope Web/Dummy](04_KEBUTUHAN_DAN_SCOPE_WEB_DUMMY.md). Usulan penilai nyata, pilot, survei, protokol pengumpulan data empiris dan pengukuran produktivitas di bawah **tidak menjadi kewajiban atau gerbang proyek saat ini**. Kandidat platform/kriteria dan rincian metode tetap referensi usulan sampai dibekukan pada desain. Jangan membaca dokumen historis ini sebagai pengganti arahan terbaru.

**Prinsip pekerjaan aktif:** sepakati scope dan kebijakan metode; susun dataset dummy deterministik yang berlabel; buat workbook berformula dan verifikasi perhitungannya; implementasikan web yang menampilkan proses serta hasil setara; tulis laporan demonstrasi software, bukan temuan empiris tentang platform AI.

## 1. Dasar analisis dan batas informasi

1. Judul proyek diberikan langsung oleh pengguna dan dipertahankan sebagaimana diberikan.
2. Materi lokal yang telah dibaca: `../../Modul 4/MODUL 4_Elimination and Choice Transaction Reality (ELECTRE).pdf` dan `../../Modul 7/MODUL 7_Group Decision Support System (GDSS).pdf`.
3. Pada pemeriksaan direktori `IS Prak`, belum ditemukan dokumen ketentuan UAS khusus. Aturan wajib tentang teknologi aplikasi, jumlah alternatif, jumlah penilai, keluaran, dan jadwal belum diketahui. Dokumen ini tidak mengarang ketentuan dosen.
4. Literatur metodologi dipakai untuk membedakan karakter outranking ELECTRE dan voting Borda. Bahan ini bukan tinjauan pustaka lengkap dan belum membuktikan kebaruan penelitian.
5. Nama platform yang disebut di bawah hanya calon alternatif. Belum diverifikasi paket, harga, fitur, versi model, atau kualitasnya saat penelitian. Tidak ada klaim bahwa suatu platform sudah lebih baik daripada platform lain.

## 2. Penilaian kelayakan judul

Judul layak untuk proyek UAS sistem pendukung keputusan karena masalahnya memiliki beberapa alternatif, beberapa kriteria yang dapat berkonflik, dan beberapa pengambil keputusan dengan prioritas yang mungkin berbeda.

Pembagian tugas metode yang disarankan:

- **ELECTRE:** mengevaluasi dukungan dan penolakan antarpasangan alternatif menurut penilaian dan bobot kriteria masing-masing decision maker (DM).
- **Borda:** mengagregasikan peringkat individual yang telah dibentuk melalui kebijakan eksplisit menjadi rekomendasi kelompok.
- **GDSS:** menyediakan proses pengisian penilaian secara individual, penyimpanan preferensi, penelusuran perhitungan, agregasi, dan pembahasan hasil kelompok.

Nilai proyek bukan membuat chatbot baru, melatih model AI, atau membuktikan keunggulan algoritma AI. Nilai utamanya adalah model keputusan kelompok yang transparan dan dapat direproduksi.

Kata “mendukung produktivitas” diperlakukan sebagai tujuan penggunaan. Ranking platform saja tidak membuktikan peningkatan produktivitas akademik secara kausal. Klaim peningkatan memerlukan pengukuran tambahan atas waktu dan kualitas pekerjaan dengan rancangan pembanding yang sesuai.

## 3. Rumusan masalah dan keluaran

### 3.1 Rumusan masalah usulan

1. Bagaimana menentukan kriteria dan instrumen evaluasi platform AI untuk tugas akademik dalam ruang lingkup yang dibatasi?
2. Bagaimana hasil perbandingan outranking dan peringkat turunan setiap DM melalui prosedur ELECTRE yang ditetapkan?
3. Bagaimana menghasilkan rekomendasi kelompok menggunakan Borda dengan penanganan seri yang transparan?
4. Seberapa stabil rekomendasi terhadap perubahan bobot, threshold, atau komposisi penilai?

### 3.2 Keluaran yang dapat dipertanggungjawabkan

- Matriks penilaian dan bobot setiap DM beserta asal datanya.
- Matriks normalisasi, pembobotan, concordance, discordance, threshold, dan aggregate dominance setiap DM.
- Graf outranking serta penjelasan bagaimana graf tersebut diubah menjadi urutan untuk Borda.
- Tabel poin Borda dan ranking/rekomendasi kelompok, termasuk seri apabila ada.
- Analisis perbedaan pandangan antarpengambil keputusan dan sensitivitas hasil.
- Aplikasi/prototipe dengan ekspor perhitungan, apabila diwajibkan oleh ketentuan UAS.

**Bukan keluaran yang dapat disimpulkan sekarang:** pemenang platform, persentase akurasi pemilihan, persentase kenaikan produktivitas, atau kesepakatan bulat semua mahasiswa.

## 4. Batasan studi yang disarankan

### 4.1 Alternatif dan unit perbandingan

Baseline usulan: empat platform, misalnya ChatGPT, Gemini, Claude, dan Perplexity. Daftar ini belum final; kelayakan akses seluruh peserta harus diperiksa dahulu. Kegunaan khusus suatu produk tidak otomatis membuat perbandingan tidak sah, tetapi semua alternatif harus diuji terhadap tugas dan kriteria yang sama serta batas perbandingannya dinyatakan.

Satu alternatif harus didefinisikan sebagai:

> platform + paket/tingkat akses + versi/model yang terlihat atau status pemilihan otomatis + pengaturan fitur + waktu/periode pengujian.

Membandingkan satu paket berbayar dengan tiga paket gratis tanpa alasan yang dinyatakan berisiko mengukur perbedaan paket, bukan hanya platform. Baseline yang praktis adalah paket gratis yang dapat diakses semua peserta; akses dan kelayakannya masih harus diverifikasi.

Bila semua biaya langganan sama-sama nol, biaya tidak memberikan informasi pembeda. Jangan memaksakan kolom biaya dengan nilai buatan. Keterbatasan akses/kuota dapat menjadi kriteria tersendiri dengan definisi yang berbeda dari harga.

### 4.2 Pengambil keputusan

Baseline kelayakan UAS: lima mahasiswa nyata yang bersedia mencoba semua alternatif dengan prosedur yang sama. Jumlah ini adalah usulan pilot proyek, bukan hasil perhitungan ukuran sampel atau dasar generalisasi populasi mahasiswa.

- Gunakan satu konteks populasi yang jelas, misalnya satu kelas atau program studi; penetapan konteks masih memerlukan keputusan pengguna.
- Jangan mengarang mahasiswa, dosen, atau pakar hanya untuk memenuhi tabel GDSS.
- Dosen dapat meninjau rubrik, tetapi tidak otomatis perlu dijadikan pemilih dengan suara lebih besar.
- Semua DM mendapat bobot suara setara pada baseline.
- Bobot kriteria dapat berbeda per DM untuk mencerminkan prioritas individual yang benar-benar dikumpulkan.

### 4.3 Tugas akademik bersama

Calon paket tugas yang perlu ditetapkan sebelum pengujian:

1. Menjelaskan konsep kuliah dengan kunci jawaban dan daftar unsur wajib yang sudah disiapkan.
2. Merangkum teks/bacaan yang sama dan legal digunakan.
3. Membantu membuat kerangka tulisan berdasarkan bahan yang sama, bukan menggantikan tanggung jawab akademik penulis.
4. Menghasilkan atau memeriksa referensi yang dapat ditelusuri, menggunakan pertanyaan dan standar verifikasi yang sama.

Jika populasi khusus mahasiswa Informatika dan bantuan pemrograman memang bagian tujuan studi, tugas coding dapat ditambahkan secara terbuka. Jangan memasukkannya diam-diam lalu menggeneralisasi hasil ke seluruh disiplin mahasiswa.

## 5. Kriteria evaluasi usulan

| Kode | Kriteria | Arah | Operasionalisasi awal dan bukti |
|---|---|---|---|
| C1 | Ketepatan isi akademik | Benefit | Proporsi atau rubrik ketepatan terhadap kunci jawaban/penilaian manusia; pisahkan fakta salah dari masalah gaya bahasa. |
| C2 | Relevansi dan kelengkapan respons | Benefit | Kesesuaian terhadap instruksi dan cakupan unsur wajib; jangan menghitung ulang ketepatan C1 sebagai C2. |
| C3 | Keterlacakan dan kesesuaian referensi | Benefit | Periksa keberadaan sumber, kecocokan metadata, dan apakah sumber mendukung klaim; bukan sekadar banyaknya tautan atau adanya fitur pencarian. |
| C4 | Kemudahan penggunaan | Benefit | Penilaian pengalaman peserta dengan butir dan jangkar yang sama, bukan kesan peneliti tanpa instrumen. |
| C5 | Kecukupan akses untuk tugas uji | Benefit | Keberhasilan mengakses fungsi yang dibutuhkan dan menyelesaikan protokol dalam batas paket/kuota yang diuji; catat kondisi dan periode. |
| C6 | Waktu penyelesaian tugas | Cost | Waktu sampai jawaban memenuhi rubrik, termasuk koreksi/verifikasi yang ditetapkan dalam protokol; bukan hanya latensi jawaban pertama. |

Enam kriteria ini masih usulan. Pengguna/dosen perlu meninjau relevansi, keterukuran, potensi tumpang tindih, serta beban pengumpulan datanya.

### 5.1 Skala dan sumber data

- Gunakan rubrik berjangkar untuk skor subjektif, misalnya skala 1–5 dengan arti setiap tingkat ditulis sebelum penilaian. Jangan berhenti pada label “sangat baik” tanpa definisi perilaku atau kualitas.
- Bedakan nilai mentah, hasil pemetaan rubrik, dan angka yang masuk ke matriks ELECTRE.
- Pengukuran objektif yang menggunakan kondisi sama, seperti durasi atau metadata paket, tidak boleh dikarang berbeda untuk setiap DM. Nilai itu dapat digunakan bersama dengan sumber yang jelas.
- Penilaian subjektif seperti kemudahan penggunaan dapat berbeda antar-DM.
- Pemakaian skor ordinal 1–5 sebagai bilangan dalam normalisasi dan selisih discordance merupakan asumsi penyederhanaan; nyatakan keterbatasannya dan uji sensitivitas pemetaan bila memungkinkan.
- Respons yang belum diuji adalah data hilang, bukan nilai nol atau otomatis skor terburuk. Apabila tugas memang dicoba dan gagal memenuhi syarat, penilaian kegagalan mengikuti rubrik.
- Jika biaya/ketergunaan telah dipetakan menjadi skor keterjangkauan/desirability benefit, jangan membalik arahnya lagi sebagai cost.

## 6. Arsitektur metode yang direkomendasikan

```text
Definisi alternatif, tugas, rubrik, dan pengaturan evaluasi yang sama
                           |
                Pengisian individual per DM
       matriks X(d) + bobot kriteria w(d) + catatan bukti
                           |
               ELECTRE untuk setiap DM secara terpisah
                           |
          Graf/matriks outranking E(d), bukan ranking otomatis
                           |
       Kebijakan ekstraksi ranking yang dinyatakan sejak awal
                           |
          Peringkat individual dengan penanganan seri
                           |
          Poin Borda berdasarkan posisi, suara DM setara
                           |
      Rekomendasi kelompok + seri + analisis sensitivitas
```

Jangan menggabungkan seluruh penilaian menjadi satu matriks rata-rata terlebih dahulu, menjalankan ELECTRE satu kali, lalu menyebut Borda sebagai agregasi banyak keputusan individual. Itu merupakan rancangan agregasi yang berbeda dari pipeline yang diusulkan di sini.

## 7. Prosedur ELECTRE dan jembatan menuju Borda

### 7.1 Mengapa ELECTRE tidak boleh langsung dianggap ranking lengkap

ELECTRE I dirancang untuk masalah pilihan berdasarkan relasi outranking. Relasi tersebut dapat tidak lengkap dan tidak transitif; pengubahan graf menjadi rekomendasi memerlukan prosedur eksploitasi tersendiri.[1]

Karena itu, laporan harus menjelaskan bukan hanya “ELECTRE lalu Borda”, melainkan juga **bagaimana keluaran ELECTRE menjadi urutan individual**.

### 7.2 Baseline yang dekat dengan Modul 4

Untuk setiap DM, gunakan versi operasional yang dinyatakan sebagai **prosedur ELECTRE berbasis materi Modul 4 dengan threshold rata-rata dan ekstraksi ranking melalui skor jumlah outranking keluar**. Jangan mengklaim seluruh konvensi modul merupakan definisi universal ELECTRE I.

Dengan indeks alternatif a,b; kriteria j; dan penilai d:

1. Normalisasi bobot positif: w(d,j) = bobot mentah(d,j) / jumlah bobot mentah DM tersebut.
2. Normalisasi vektor: r(d,a,j) = x(d,a,j) / sqrt(jumlah atas alternatif b dari x(d,b,j)^2).
3. Pembobotan: v(d,a,j) = r(d,a,j) × w(d,j).
4. Untuk kriteria benefit, concordance mencakup j ketika x(d,a,j) >= x(d,b,j); untuk cost, ketika x(d,a,j) <= x(d,b,j). Discordance mencakup kriteria yang lebih buruk menurut arahnya.
5. c(d,a,b) adalah jumlah bobot kriteria dalam himpunan concordance.
6. d(d,a,b) adalah maksimum selisih absolut v pada himpunan discordance dibagi maksimum selisih absolut v pada semua kriteria aktif, mengikuti varian modul. Jika himpunan discordance kosong atau kedua baris identik, tetapkan discordance nol dengan penanganan pembagian nol yang eksplisit.
7. Hitung threshold concordance dan discordance dari pasangan off-diagonal saja.
8. E(d,a,b) = 1 jika concordance >= threshold concordance **dan** discordance <= threshold discordance; selain itu nol. Diagonal E harus nol.
9. Skor ringkasan individual s(d,a) = jumlah E(d,a,b) untuk b selain a (outdegree).
10. Bentuk urutan menurun dari s; semua nilai sama tetap seri.

**Temuan bahan lokal:** Modul 4 halaman 10 memuat narasi arah discordance yang bertentangan dengan contoh formula. Formula `=IF(P21<=$S$25,1,0)` dan kode Python menggunakan `<=`. Desain di atas memakai arah discordance kecil mendukung outranking; jangan menyalin salah ketik narasi menjadi implementasi.

### 7.3 Status metodologis skor outdegree

Outdegree adalah kebijakan ringkasan graf yang dipilih agar dekat dengan tugas Modul 4, bukan ranking lengkap yang otomatis dijamin oleh ELECTRE I. Ringkasan ini dapat menghilangkan informasi incomparability, siklus, dan dukungan masuk; bahkan urutan skornya tidak selalu mengikuti setiap arc individual. Graf asli perlu tetap ditampilkan.

Bedakan status pasangan: outranking satu arah, saling outranking, dan tidak terdapat outranking pada kedua arah. Tidak adanya outranking dua arah menunjukkan inkomparabilitas dalam relasi yang dibentuk, bukan otomatis dua alternatif sama baik. Demikian pula, skor outdegree yang sama hanya menunjukkan seri pada ukuran ringkasan, bukan bukti kesetaraan kualitas.

Jika semua skor sama atau graf tidak memberikan pembedaan, sistem harus melaporkan keterbatasan diskriminasi. Jangan mengurutkan berdasarkan ID, nama platform, atau susunan baris demi memaksakan pemenang.

Kebijakan lain, misalnya outdegree dikurangi indegree, hanya boleh menjadi pembanding sensitivitas yang ditentukan sebelum melihat hasil; jangan mengganti kebijakan karena hasilnya tidak sesuai harapan.

### 7.4 Validasi input penting

- Seluruh nilai input dan bobot harus tersedia dan berhingga.
- Bobot mentah harus positif pada kriteria aktif dan mempunyai total positif; kriteria berbobot nol perlu dikeluarkan dari perbandingan aktif secara eksplisit.
- Hindari kolom norma nol dan pembagian nol.
- Jangan memasukkan diagonal dalam rata-rata threshold atau skor dominasi.
- Jangan membulatkan matriks perantara sebelum perbandingan threshold; pembulatan untuk tampilan saja.
- Kandidat identik dan seri tidak boleh dipecahkan oleh urutan penyimpanan.
- Tetapkan minimal dua alternatif untuk menghitung threshold berpasangan.

## 8. Borda: versi, bobot, dan penanganan seri

### 8.1 Baseline ordinal

Borda biasa memberikan poin m−1, m−2, ..., 0 menurut posisi peringkat dari m alternatif, kemudian menjumlahkan poin antarpenilai.[2]

Dengan r(d,a) sebagai posisi peringkat individual dan lambda(d) sebagai bobot suara DM:

> p(d,a) = m − r(d,a)
>
> B(a) = jumlah atas DM d dari lambda(d) × p(d,a)

Baseline memakai lambda yang sama untuk semua DM. Bobot kriteria, bobot suara DM, dan poin posisi Borda adalah tiga konsep berbeda; jangan tertukar.

Untuk ballot lengkap dan bobot DM tetap, penggunaan m, m−1, ..., 1 menghasilkan urutan yang sama dengan m−1, ..., 0 karena hanya menambahkan konstanta pada total setiap alternatif.[3]

### 8.2 Seri pada peringkat individual

Kebijakan usulan adalah membagi rata poin untuk posisi yang ditempati kelompok seri. Kebijakan ini memperluas Borda ke weak ranking dan perlu ditulis eksplisit, bukan dianggap bahwa semua ballot selalu strict ranking.

**Ilustrasi sintetis, bukan data platform:** empat alternatif memiliki skor outdegree 3, 2, 2, 0. Alternatif kedua dan ketiga menempati posisi 2 dan 3 bersama. Poin Borda yang diberikan adalah 3; 1,5; 1,5; 0. Ilustrasi ini telah dihitung menggunakan Python, tetapi bukan hasil uji proyek.

Jangan memakai dense rank atau rank minimum lalu memasukkannya langsung ke rumus m−rank, karena total poin dan perlakuan seri dapat berubah.

Jika skor Borda akhir seri, tampilkan rekomendasi bersama. Apabila tugas menuntut satu pemenang, mekanisme penyelesaian seri perlu disepakati sebelum pengujian, bukan dipilih setelah melihat platform mana yang diuntungkan.

### 8.3 Perbedaan terhadap contoh Modul 7

Materi Modul 7 mengelompokkan nilai preferensi individual menurut ranking dan kemudian memakai bobot posisi. Ini berbeda dari menjumlahkan poin posisi saja. Rancangan UAS perlu membedakan:

- **Borda ordinal:** hanya posisi peringkat individual yang menentukan poin.
- **Agregasi skor × bobot peringkat:** skor kardinal individual ikut mengalikan pengaruh posisi.

Baseline usulan adalah Borda ordinal. Jika dosen mensyaratkan reproduksi persis varian Modul 7, tulis sebagai varian agregasi berbobot skor, jelaskan konsekuensinya, dan jangan diam-diam menyebutnya sama dengan Borda ordinal.

Menerapkan skor outdegree ELECTRE sebagai pengali lagi memiliki risiko: skor nol dapat menyumbang nol walaupun posisi ordinalnya berbeda; kepadatan graf antar-DM dapat ikut mengubah pengaruh DM. Karena itu, pilihan varian harus dikunci sebelum implementasi.

### 8.4 Arti hasil kelompok

Skor tertinggi adalah rekomendasi menurut aturan agregasi yang dipilih, bukan bukti bahwa semua peserta setuju. Persentase Borda yang dinormalisasi adalah proporsi poin, bukan probabilitas platform terbaik atau akurasi pemilihan.

Borda juga tidak menjamin memilih pemenang Condorcet pada semua profil preferensi.[3] Laporan harus mempertahankan perbedaan antara rekomendasi agregat, mayoritas pilihan pertama, dan konsensus bulat.

## 9. Protokol pengumpulan data dan keadilan pengujian

1. Tetapkan semua alternatif, paket akses, periode, tugas, kunci/rubrik, batas waktu, dan aturan koreksi sebelum evaluasi.
2. Pastikan setiap DM mencoba seluruh alternatif. Kriteria pengikutsertaan peserta tidak cukup hanya “pernah mendengar nama platform”.
3. Gunakan bahan dan prompt dasar yang sama; atur rotasi urutan platform untuk mengurangi pengaruh urutan, pembelajaran, dan kelelahan.
4. Tetapkan fitur yang boleh dipakai, misalnya pencarian web atau unggahan dokumen. Jika fitur merupakan bagian evaluasi platform, izinkan sesuai protokol dan dokumentasikan perbedaannya; jika menguji model murni, samakan fitur. Jangan mencampur kedua tujuan.
5. Catat timestamp, jaringan/perangkat, mode/model yang tampak, gangguan akses, dan batas penggunaan. Bila model otomatis tidak dapat dikunci, catat keterbatasannya.
6. Simpan prompt, output mentah, verifikasi referensi, durasi, skor, identitas anonim DM, serta alasan penilaian.
7. Tetapkan pengulangan yang realistis dan cara merangkum hasilnya sebelum uji; jangan menyimpulkan keandalan hanya dari satu respons yang kebetulan bagus.
8. Jika memakai beberapa penilai kualitas, jelaskan proses penilaian dan penanganan perbedaan. Jangan menyatakan objektif hanya karena menggunakan angka.
9. Skor simulasi boleh dipakai untuk menguji aplikasi, tetapi harus dipisahkan dari data penelitian dan tidak digunakan untuk klaim empiris.
10. Gunakan bahan nonrahasia dan persetujuan peserta. Jangan mengunggah data pribadi mahasiswa atau naskah yang tidak boleh dibagikan ke platform eksternal.

Baseline empat alternatif × lima DM × enam kriteria menghasilkan 120 entri penilaian apabila setiap DM memberikan seluruh sel matriks. Angka ini dihitung dengan Python; belum termasuk rating per tugas/pengulangan maupun bobot kriteria. Sebagian ukuran objektif dapat menjadi data bersama yang dirujuk setiap matriks, bukan 120 pengukuran independen.

## 10. Rancangan sistem minimum

Belum menetapkan framework atau melakukan pengembangan kode. Komponen minimum yang relevan untuk GDSS:

| Komponen | Fungsi minimum |
|---|---|
| Konfigurasi sesi | Alternatif/paket, daftar kriteria dan arah, versi protokol, periode, threshold policy, kebijakan ekstraksi ranking dan seri. |
| Identitas DM | Kode anonim, kriteria kelayakan, bobot suara yang dinyatakan eksplisit. |
| Penilaian individual | Matriks tiap DM, bobot kriteria tiap DM, bukti dan status kelengkapan. |
| Proses ELECTRE | Jalur perhitungan per DM dan ekspor matriks, bukan hanya nama pemenang. |
| Jembatan ranking | Skor ringkasan, posisi rata-rata untuk seri, dan graf asal yang tetap tersedia. |
| Agregasi Borda | Poin setiap DM, total, seri, dan variasi preferensi individual. |
| Audit dan ekspor | Data mentah, parameter, hasil perantara, workbook/notebook serta ringkasan laporan. |

Tidak perlu integrasi API platform AI untuk membuktikan perhitungan GDSS. Pengujian platform dapat dilakukan melalui penggunaan yang sah dan dicatat secara terpisah; aplikasi keputusan memproses bukti yang dikumpulkan.

## 11. Rencana validasi

### 11.1 Kebenaran algoritma

- Cocokkan satu kasus kecil yang bisa diperiksa manual antara rumus spreadsheet dan Python.
- Cocokkan seluruh matriks perantara, bukan hanya pemenang.
- Uji pasangan identik, alternatif dominan, himpunan discordance kosong, data hilang, kolom norma nol, bobot tidak valid, dan cost direction.
- Uji permutasi urutan alternatif dan DM; hasil harus tetap setara setelah ID dipetakan kembali.
- Uji seri individual dan Borda akhir; pastikan tidak ada urutan tersembunyi akibat ID atau baris.
- Uji kasus seluruh DM seri atau graf tanpa pembedaan; jangan membuat rekomendasi tunggal palsu.

### 11.2 Sensitivitas dan batas klaim

- Ubah prioritas kriteria secara terkontrol lalu normalisasi ulang.
- Bandingkan beberapa threshold yang ditetapkan sebelumnya dengan baseline rata-rata.
- Lakukan leave-one-DM-out untuk melihat apakah satu peserta menentukan rekomendasi.
- Bandingkan kebijakan ekstraksi graph sebagai analisis tambahan yang diberi label, bukan pergantian diam-diam metode utama.
- Laporkan perubahan urutan, seri, dan perubahan rekomendasi; jangan langsung menyatakan “robust” tanpa hasil nyata.
- Bila menampilkan tingkat kesesuaian pendapat, tentukan definisi statistiknya dan penanganan ties terlebih dahulu; persentase poin Borda bukan ukuran kesepakatan.

## 12. Urutan pekerjaan sebelum implementasi

1. **Konfirmasi ketentuan UAS:** artefak yang wajib, rubrik penilaian, batas teknologi, tim/individu, serta apakah Borda harus mengikuti varian Modul 7.
2. **Bekukan desain:** populasi, alternatif/paket, kriteria, tugas, rubrik, bobot, threshold, ekstraksi ranking, dan seri. Semua keputusan dicatat dalam Markdown.
3. **Pilot instrumen:** coba skala kecil untuk memastikan protokol dapat dikerjakan dan kriterianya tidak ambigu. Simpan data pilot terpisah; catat revisi sebelum studi utama.
4. **Kumpulkan data nyata:** dokumentasikan bukti setiap penilaian dan tetapkan data yang belum lengkap.
5. **Hitung dan verifikasi:** workbook berformula, implementasi Python/notebook, lalu pemeriksaan parity.
6. **Bangun prototipe minimum:** hanya sesudah alur hitung dan keluaran disepakati; framework mengikuti kebutuhan dan ketentuan UAS.
7. **Uji dan laporkan:** kasus tepi, sensitivitas, hasil per-DM dan kelompok, keterbatasan serta bukti proses; jangan mendahulukan narasi hasil sebelum perhitungannya ada.

## 13. Keputusan yang masih terbuka

- Ketentuan resmi UAS dan keluaran wajib.
- Varian Borda: ordinal sebagai usulan utama atau reproduksi varian skor × bobot posisi Modul 7.
- Ruang lingkup peserta dan daftar penilai nyata.
- Daftar platform dan paket akses yang memang tersedia bagi semua peserta.
- Kriteria/rubrik final dan banyaknya tugas serta pengulangan.
- Apakah proyek hanya merekomendasikan platform atau juga menguji perubahan produktivitas manusia.

## 14. Rekomendasi analisis awal

Pertahankan judul, tetapi sempitkan klaim menjadi **rekomendasi platform dalam konteks peserta, tugas, paket, dan periode yang diuji**. Desain utama yang paling dekat dengan materi praktikum adalah ELECTRE per DM, graf outranking yang transparan, ranking turunan berbasis outdegree dengan seri dipertahankan, lalu Borda ordinal dengan bobot DM setara. Sebelum implementasi, pastikan dosen menerima pilihan Borda dan kebijakan jembatan ranking tersebut.

Penekanan laporan sebaiknya ada pada kualitas instrumen dan bukti, kejelasan pemisahan keputusan individual/kelompok, serta penanganan ketidakpastian. Banyaknya halaman, warna dashboard, dan jumlah platform bukan pengganti validitas metode.

## Sources

[1] https://www.cin.ufpe.br/~if703/aulas/OutrankingElectre.pdf — Denis Bouyssou — Outranking Methods
[2] https://plato.stanford.edu/entries/voting-methods — Stanford Encyclopedia of Philosophy — Voting Methods
[3] https://mathworld.wolfram.com/BordaCount.html — Wolfram MathWorld — Borda Count
