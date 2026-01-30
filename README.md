🧶 Bisnisku – Aplikasi Manajemen Usaha Terintegrasi untuk UMKM
📖 Tentang Proyek

Bisnisku adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu pelaku UMKM dalam mengelola bisnis secara terstruktur, terintegrasi, dan profesional.
Aplikasi ini menyediakan fitur pengelolaan produk, pesanan, stok, keuangan, serta karyawan, sehingga seluruh aktivitas bisnis dapat dipantau dalam satu sistem terpadu.

Proyek Bisnisku dikembangkan sebagai bagian dari Ujian Akhir Semester (UAS) mata kuliah Pemrograman Mobile 2, dengan fokus pada penerapan:

Flutter & Dart

Integrasi backend menggunakan Supabase

State management modern

Desain antarmuka yang modern dan user-friendly

🎯 Latar Belakang & Motivasi

Permasalahan umum yang sering dihadapi oleh pelaku UMKM antara lain:

❌ Pengelolaan transaksi dan stok masih dilakukan secara manual
❌ Tidak tersedia laporan keuangan yang rapi dan terstruktur
❌ Sulit menghitung laba, rugi, dan biaya operasional
❌ Manajemen karyawan dan penggajian belum sistematis
❌ Tidak adanya dashboard untuk mendukung pengambilan keputusan berbasis data

💡 Solusi: Bisnisku

Bisnisku hadir sebagai solusi digital yang:

✅ Mengintegrasikan seluruh proses bisnis UMKM dalam satu aplikasi
✅ Meningkatkan efisiensi dan akurasi operasional
✅ Menyediakan data bisnis dan laporan secara real-time
✅ Membantu UMKM mengelola usaha secara lebih profesional dan modern

✨ Fitur Utama
🏠 Dashboard

Ringkasan pendapatan bisnis

Statistik pesanan dan performa usaha

Navigasi cepat ke seluruh modul utama

📦 Manajemen Inventori

CRUD data produk

Monitoring stok barang

Peringatan stok minimum

🛒 Manajemen Pesanan

Input dan pengelolaan pesanan

Tracking status pesanan

Perhitungan omzet dan laba otomatis

💰 Manajemen Keuangan

Pencatatan pemasukan dan pengeluaran

Perhitungan laba rugi

Ringkasan saldo bisnis

👥 Manajemen Karyawan & HR

Data karyawan

Modul HR dan perhitungan gaji

Riwayat penggajian

📊 Laporan & Analitik

Ringkasan performa bisnis

Grafik dan insight untuk pengambilan keputusan

🛠 Tech Stack
Frontend

Flutter

Dart

Backend & Database

Supabase

PostgreSQL

State Management & Routing

Riverpod

go_router

UI / UX

Material Design 3

Custom Theme

Responsive Layout

📂 Struktur Proyek
## 📂 Struktur Proyek

```bash
lib/
└── features/
    ├── auth/
    │   ├── application/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │       └── pages/
    │           ├── forgot_password_page.dart
    │           ├── login_page.dart
    │           ├── register_page.dart
    │           └── splash_page.dart
    │
    ├── employees/
    │   ├── application/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │       └── pages/
    │
    ├── finance/
    │   ├── application/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │       └── pages/
    │
    ├── home/
    │   ├── application/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │       └── pages/
    │
    ├── integration/
    │   ├── application/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │       └── pages/
    │
    ├── inventory/
    │   ├── application/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │       └── pages/
    │
    ├── payroll/
    │   ├── application/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │       └── pages/
    │
    └── production/
        ├── application/
        ├── data/
        ├── domain/
        │   └── product_model.dart
        └── presentation/
            └── pages/
```


🎓 Konsep yang Diterapkan

✅ Modular Architecture

✅ State Management (Riverpod)

✅ Supabase Integration

✅ CRUD Operations

✅ Authentication & Authorization

✅ Business Logic Separation

✅ Asynchronous Programming

✅ Responsive & Themed UI
