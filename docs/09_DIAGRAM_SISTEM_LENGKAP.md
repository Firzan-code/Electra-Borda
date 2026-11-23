# Dokumentasi Diagram Sistem Lengkap (GDSS ELECTRE–Borda)

**Mata Kuliah:** Praktikum Sistem Informasi / GDSS  
**Judul Proyek:** Implementasi GDSS Menggunakan Metode ELECTRE dan Borda dalam Pemilihan Platform Artificial Intelligence untuk Mendukung Produktivitas Akademik Mahasiswa  
**Penanggung Jawab:** Safri Firzan Sururi (240605110084) — Ketua / Desain Sistem  
**Format Diagram:** Mermaid Standard (Didukung penuh oleh Obsidian, GitHub, dan Typora)

---

## 1. Diagram Arsitektur Sistem (System Architecture Diagram)

Diagram ini mengilustrasikan arsitektur berlapis (*layered architecture*) aplikasi, mulai dari antarmuka pengguna, pengontrol web, mesin komputasi murni, hingga lapisan penyimpanan dan validasi formula Excel.

```mermaid
flowchart TD
    subgraph ClientLayer ["1. Presentation Layer (Client Browser)"]
        UI["Web Single Page App<br>(HTML5, CSS3, Vanilla JS)"]
        Nav["Sidebar Navigasi (6 Tahap)"]
        Tables["Tabel Matriks & Visualisasi Stale"]
        Toolbar["Toolbar (Reset Seed, Unduh Excel, Hitung)"]
    end

    subgraph ControllerLayer ["2. Web Controller & Security Layer (Flask 3.1.3)"]
        API["REST API Router (gdss/web.py)"]
        SecGuard["Keamanan & Sanitasi<br>(Host Guard, CORS, CSP, 256KB Cap)"]
    end

    subgraph EngineLayer ["3. Core Calculation Engine (Pure Python)"]
        Val["Validasi Skenario (Batas, Tipe, Norma)"]
        Norm["Normalisasi Vektor R & Terbobot V"]
        ConcDisc["Himpunan & Matriks C dan D"]
        Dom["Threshold Off-Diagonal & Matriks Dominasi E"]
        Borda["Agregasi Poin Konsensus Borda Ordinal"]
    end

    subgraph DataLayer ["4. Persistence Layer (DatabaseManager)"]
        DBM["DatabaseManager (gdss/db.py)"]
        MySQL[("MySQL Server 3NF<br>(gdss_ai_db: 9 Tabel Relasional)")]
        SQLite[("Local Fallback<br>(instance/gdss.sqlite3)")]
    end

    subgraph VerificationLayer ["5. Independent Verification Partner"]
        Excel["Microsoft Excel COM Engine<br>(GDSS_ELECTRE_BORDA_Dummy.xlsx)"]
        Parity["10.461 Checks Parity Verifier"]
    end

    UI --> API
    Nav --> UI
    Tables --> UI
    Toolbar --> UI

    API --> SecGuard
    SecGuard --> Val
    Val --> Norm --> ConcDisc --> Dom --> Borda

    Borda --> DBM
    DBM --> MySQL
    DBM -.->|"Fallback jika MySQL offline"| SQLite

    Borda -.->|"Validasi Numerik 100% Selaras"| Parity
    Excel -.->|"Verifikasi Formula Hidup"| Parity
```

---

## 2. Use Case Diagram

Diagram ini mendefinisikan fungsionalitas sistem yang dapat diakses oleh aktor utama (Operator GDSS / Mahasiswa dan Penilai Simulasi / Decision Makers).

```mermaid
flowchart LR
    Operator(("Operator GDSS /<br>Mahasiswa"))
    DM(("Decision Maker /<br>Penilai Simulasi"))

    subgraph GDSS ["Sistem GDSS ELECTRE–Borda"]
        UC1["UC-01: Mengatur Konfigurasi Skenario"]
        UC2["UC-02: Menginput Nilai Evaluasi Alternatif"]
        UC3["UC-03: Menentukan Bobot Preferensi Kriteria"]
        UC4["UC-04: Menjalankan Komputasi GDSS"]
        UC5["UC-05: Menginspeksi Matriks Tahapan ELECTRE"]
        UC6["UC-06: Menganalisis Konsensus Akhir Borda"]
        UC7["UC-07: Mengunduh Workbook Excel Acuan"]
        UC8["UC-08: Mengakses Riwayat & Audit Trail Snapshot"]
        UC9["UC-09: Mereset Skenario ke Data Seed"]
    end

    Operator --> UC1
    Operator --> UC4
    Operator --> UC5
    Operator --> UC6
    Operator --> UC7
    Operator --> UC8
    Operator --> UC9

    DM --> UC2
    DM --> UC3
    UC4 -.->|"include"| UC5
    UC4 -.->|"include"| UC6
```

---

## 3. Activity Diagram (Alur Kerja Komputasi ELECTRE–Borda)

Diagram aktivitas menggambarkan tahapan logika pemrosesan data sejak pengguna menekan tombol *"Hitung & Simpan"* hingga hasil ditampilkan dan disimpan ke basis data.

```mermaid
flowchart TD
    Start([Mulai]) --> Input["Pengguna Mengedit Nilai / Memuat Seed"]
    Input --> Trigger["Klik Tombol 'Hitung & Simpan'"]
    Trigger --> Validasi{"Validasi Input Backend<br>(Skala, Tipe, Norma > 0?)"}

    Validasi -- "Gagal" --> ErrorMsg["Tampilkan Pesan Error (HTTP 400)<br>Hasil Lama Tidak Berubah"]
    ErrorMsg --> Input

    Validasi -- "Lolos" --> NormVektor["1. Normalisasi Vektor Kolom (Matriks R)"]
    NormVektor --> Pembobotan["2. Pembobotan Matriks (Matriks V = R × W)"]
    Pembobotan --> Pairwise["3. Pembentukan Himpunan Concordance & Discordance"]
    Pairwise --> HitungCD["4. Hitung Matriks Indeks C dan D"]
    HitungCD --> Thresholds["5. Hitung Threshold Off-Diagonal c̄ dan d̄"]
    Thresholds --> MatriksDominasi["6. Bentuk Matriks Dominasi F, G, dan E = F × G"]
    MatriksDominasi --> Outdegree["7. Hitung Skor Outdegree & Peringkat per-DM"]
    Outdegree --> OrdinalBorda["8. Konversi ke Poin Borda per-DM (m - rank)"]
    OrdinalBorda --> Agregasi["9. Akumulasi Total Poin Borda Kelompok"]
    Agregasi --> TieCheck{"Ada Skor Seri?"}

    TieCheck -- "Ya" --> SetTie["Tetapkan Status 'tie'<br>Rekomendasi Bersama (Claude & Perplexity)"]
    TieCheck -- "Tidak" --> SetUnique["Tetapkan Status 'unique'<br>Pemenang Tunggal"]

    SetTie --> SimpanDB["10. Simpan Snapshot & Riwayat ke Database (MySQL/SQLite)"]
    SetUnique --> SimpanDB

    SimpanDB --> RenderUI["11. Kirim Respons JSON ke Browser & Buka Tab Hasil"]
    RenderUI --> End([Selesai])
```

---

## 4. Sequence Diagram (Skenario Eksekusi Perhitungan)

Diagram sekuensial merinci pertukaran pesan antar-objek (*lifelines*) selama satu siklus eksekusi perhitungan.

```mermaid
sequenceDiagram
    autonumber
    actor User as Pengguna / Browser
    participant Controller as Flask Controller (gdss/web.py)
    participant Core as Core Engine (gdss/core.py)
    participant DB as DatabaseManager (gdss/db.py)
    participant Storage as MySQL / SQLite Database

    User->>Controller: POST /api/calculate (Payload Skenario JSON)
    activate Controller
    
    Controller->>Core: calculate(scenario)
    activate Core
    
    Core->>Core: validate_scenario(scenario)
    Note over Core: Validasi batas skala 1-5, cost/benefit, bobot > 0
    
    loop Untuk Setiap Decision Maker (DM01..DM03)
        Core->>Core: electre(matrix, weights, directions)
        Note over Core: Hitung R, V, C, D, Threshold, F, G, E, Outdegree
    end
    
    Core->>Core: borda_aggregate(dms_results)
    Note over Core: Jumlahkan poin Borda ordinal & hitung hash SHA-256
    
    Core-->>Controller: Return Result Dict (Status, Rankings, Matrices)
    deactivate Core

    Controller->>DB: save_run(scenario, result)
    activate DB
    DB->>Storage: INSERT INTO calculation_runs, borda_results, electre_results
    Storage-->>DB: Confirmation (run_id)
    DB-->>Controller: Return run_id
    deactivate DB

    Controller-->>User: HTTP 200 OK (Run Snapshot JSON)
    deactivate Controller
    
    Note over User: Browser memperbarui 6 tab matriks dan mengaktifkan visual Borda
```

---

## 5. Data Flow Diagram (DFD) Level 0 & Level 1

### 5.1 DFD Level 0 (Context Diagram)
Menggambarkan batasan sistem dan aliran data dengan entitas luar.

```mermaid
flowchart LR
    User(("Pengguna /<br>Decision Maker"))
    System["Sistem Informasi GDSS<br>ELECTRE–Borda"]
    Excel[("Workbook Excel Acuan")]
    Database[("Basis Data Relasional MySQL")]

    User -->|"Input Alternatif, Kriteria, Bobot & Nilai"| System
    System -->|"Informasi Matriks ELECTRE & Konsensus Borda"| User
    System -->|"Simpan Snapshot & Audit Trail"| Database
    Database -->|"Riwayat Perhitungan Lampau"| System
    Excel -.->|"Verifikasi Keselarasan Formula"| System
    System -->|"Unduhan Berkas Acuan .xlsx"| User
```

### 5.2 DFD Level 1 (Dekomposisi Proses)
Menampilkan aliran data pada modul-modul fungsional internal.

```mermaid
flowchart TD
    User(("Pengguna"))
    
    subgraph Proses ["Dekomposisi Proses GDSS"]
        P1["1.0 Manajemen Input & Validasi"]
        P2["2.0 Komputasi ELECTRE I per-DM"]
        P3["3.0 Agregasi Konsensus Borda"]
        P4["4.0 Penyimpanan & Riwayat"]
    end

    DS1[("D1: Skenario & Master")]
    DS2[("D2: Matriks Perantara")]
    DS3[("D3: Riwayat Runs & Borda")]

    User -->|"Kirim Form Input"| P1
    P1 -->|"Validasi Data"| DS1
    DS1 -->|"Ambil Data Matriks"| P2
    P2 -->|"Simpan Nilai R, V, C, D, E"| DS2
    DS2 -->|"Ambil Skor Outdegree"| P3
    P3 -->|"Hasil Konsensus Poin"| P4
    P4 -->|"Tulis Data Relasional"| DS3
    P3 -->|"Tampilkan Rekomendasi Pemenang"| User
    P4 -->|"Tampilkan Riwayat Snapshot"| User
```

---

## 6. Diagram Deployment (Topologi Komponen Lokal)

Diagram ini menunjukkan node fisik dan komponen perangkat lunak yang berjalan di mesin komputer pengguna (arsitektur *stand-alone offline*).

```mermaid
flowchart TD
    subgraph ClientNode ["Client Environment (Peramban Web)"]
        Browser["Web Browser (Google Chrome / Microsoft Edge)"]
        HTMLApp["GDSS Single Page Application (Port 8765)"]
        Browser --> HTMLApp
    end

    subgraph HostNode ["Host Environment (Mesin Pengembang / Windows PC)"]
        subgraph PythonRuntime ["Python 3.11 Runtime Environment"]
            FlaskWSGI["WSGI Server (run.py / Flask 3.1.3)"]
            PyMySQLDriver["PyMySQL Database Driver"]
            CoreLib["Library gdss.core & openpyxl"]
        end

        subgraph DatabaseServers ["Database Services"]
            MySQLService[("MySQL Server (Port 3306 / XAMPP)") ]
            SQLiteFile[("SQLite File (instance/gdss.sqlite3)") ]
        end
    end

    HTMLApp <-->|"HTTP REST / JSON (Localhost:8765)"| FlaskWSGI
    FlaskWSGI --> CoreLib
    FlaskWSGI --> PyMySQLDriver
    PyMySQLDriver <-->|"TCP Socket (Localhost:3306)"| MySQLService
    PyMySQLDriver -.->|"Fallback File I/O"| SQLiteFile
```

---

## 7. Rangkuman Kegunaan Diagram untuk Progres

1. **Safri Firzan Sururi (Ketua / Desain):** Menggunakan **Arsitektur Sistem (1)**, **Use Case (2)**, dan **DFD (5)** untuk mempresentasikan konsep GDSS dan interaksi pengguna.
2. **Erai Bagusalim (Backend & Database):** Menggunakan **Activity Diagram (3)**, **Sequence Diagram (4)**, dan **ERD Fisik (docs/08)** untuk membuktikan kebenaran algoritma dan integritas data 3NF.
3. **Dimas Bagus Hari Murti (Frontend):** Menggunakan alur antarmuka dan **Topologi Deployment (6)** untuk menjelaskan responsivitas web dan kemandirian sistem tanpa internet.
