🧶 BisnisHub – Aplikasi Manajemen Usaha Terintegrasi untuk UMKM
📖 Tentang Proyek

BisnisHub adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu pelaku UMKM mengelola bisnis secara terstruktur dan terintegrasi.
Aplikasi ini mencakup pengelolaan produk, pesanan, stok, keuangan, dan karyawan, sehingga seluruh aktivitas bisnis dapat dipantau dalam satu sistem terpadu.

Proyek ini dikembangkan sebagai bagian dari Ujian Akhir Semester (UAS) mata kuliah Pemrograman Mobile 2, dengan fokus pada penerapan Flutter, integrasi backend menggunakan Supabase, state management, serta desain antarmuka modern dan profesional.

🎯 Latar Belakang & Motivasi

Permasalahan utama UMKM yang melatarbelakangi pengembangan aplikasi ini:

❌ Pengelolaan transaksi dan stok masih manual
❌ Tidak adanya laporan keuangan yang terstruktur
❌ Sulit menghitung laba dan biaya operasional
❌ Pengelolaan karyawan dan penggajian belum sistematis
❌ Tidak tersedia dashboard untuk pengambilan keputusan berbasis data

💡 Solusi: BisnisHub

BisnisHub hadir sebagai solusi digital yang:

✅ Mengintegrasikan seluruh proses bisnis
✅ Meningkatkan efisiensi operasional UMKM
✅ Menyediakan data dan laporan bisnis secara real-time
✅ Membantu UMKM mengelola usaha secara profesional

✨ Fitur Utama
🏠 Dashboard

Ringkasan pendapatan

Statistik pesanan dan performa bisnis

Navigasi cepat ke seluruh modul

📦 Manajemen Inventori

CRUD produk

Monitoring stok

Peringatan stok minimum

🛒 Manajemen Pesanan

Input pesanan

Tracking status pesanan

Perhitungan omzet & laba otomatis

💰 Manajemen Keuangan

Pencatatan pemasukan & pengeluaran

Perhitungan laba rugi

Ringkasan saldo bisnis

👥 Manajemen Karyawan & HR

Data karyawan

Modul HR & perhitungan gaji

Riwayat penggajian

📊 Laporan & Analitik

Ringkasan performa bisnis

Grafik dan insight pengambilan keputusan

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

UI/UX

Material Design 3

Custom Theme

Responsive Layout

📂 Struktur Proyek
lib/
├── app.dart
├── core/
│   ├── auth/
│   │   └── auth_providers.dart
│   ├── router/
│   │   ├── app_router.dart
│   │   └── app_routes.dart
│   ├── supabase/
│   │   ├── supabase_bootstrap.dart
│   │   └── supabase_config.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       └── formatters.dart
├── features/
│   ├── orders/
│   │   ├── data/order_repository.dart
│   │   ├── models/order_model.dart
│   │   └── state/order_providers.dart
│   ├── pages/
│   │   ├── dashboard_page.dart
│   │   ├── finance_page.dart
│   │   ├── hr_page.dart
│   │   ├── inventory_page.dart
│   │   ├── orders_page.dart
│   │   ├── purchasing_page.dart
│   │   ├── reports_page.dart
│   │   └── settings_page.dart
│   └── pages.dart
└── ...

🎓 Konsep yang Diterapkan

✅ Modular Architecture
✅ State Management (Riverpod)
✅ Supabase Integration
✅ CRUD Operations
✅ Authentication & Authorization
✅ Business Logic Separation
✅ Asynchronous Programming
✅ Responsive & Themed UI
