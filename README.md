# 🏪 Bisnisku – Aplikasi Manajemen Usaha Terintegrasi

**Bisnisku** adalah aplikasi manajemen usaha berbasis **Flutter** yang dirancang untuk membantu UMKM mengelola seluruh proses bisnis secara terintegrasi, mulai dari autentikasi pengguna, dashboard usaha, inventori, penjualan, keuangan, penggajian, produksi, hingga laporan.

---

## 📖 Tentang Proyek

Aplikasi **Bisnisku** dikembangkan sebagai proyek **Ujian Akhir Semester (UAS)** Mata Kuliah **Pemrograman Mobile 2**.  
Proyek ini menerapkan arsitektur **feature-based** agar setiap modul bisnis terstruktur, mudah dikembangkan, dan mudah dipelihara.

---

## 🎯 Tujuan Pengembangan

- Membantu UMKM mengelola usaha secara terintegrasi
- Menyediakan sistem pencatatan transaksi dan keuangan yang rapi
- Mengelola data karyawan, penggajian, dan produksi
- Menghasilkan laporan bisnis secara terstruktur
- Menerapkan konsep mobile development modern berbasis Flutter

---

## Link Hosting: [https://agungcandra-uas-pemmobile2.netlify.app/]

---
## Demo APP: 

https://github.com/user-attachments/assets/3126287f-3f6d-4a3f-9ddf-07bb8a34550f

---
## 📂 Struktur Proyek


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

 ---

## ✨ Fitur Utama Aplikasi

### 🔐 Authentication (`features/auth`)
- Login pengguna
- Registrasi akun
- Manajemen sesi pengguna
- Integrasi Supabase Authentication

📸 **Screenshot:**
- Halaman Login: <img width="289" height="548" alt="image" src="https://github.com/user-attachments/assets/591b4dd0-94fd-489b-b400-2f1b3d23f70b" />

- Halaman Register: <img width="286" height="571" alt="image" src="https://github.com/user-attachments/assets/8d65f578-5665-47fc-af69-6fcd8c89940d" />

- Halaman Lupa Passowrd: <img width="278" height="572" alt="image" src="https://github.com/user-attachments/assets/4ce2ab9a-2468-4c04-8c20-78e5dec7e8c8" />

---

### 🏠 Dashboard (`features/home`)
- Ringkasan kondisi usaha
- Informasi statistik utama
- Navigasi ke seluruh modul bisnis

📸 **Screenshot:**
- Dashboard Utama: <img width="269" height="550" alt="image" src="https://github.com/user-attachments/assets/1ab03a88-7651-43bf-a541-90e4178c5d39" />


---

### 📦 Inventory Management (`features/inventory`)
- Manajemen data produk
- Pencatatan stok barang
- Kategori produk
- Monitoring ketersediaan stok

📸 **Screenshot:**
- Daftar Produk: <img width="284" height="583" alt="image" src="https://github.com/user-attachments/assets/7bd53a88-2c2c-477d-a9e2-bfca36bb9033" />

- Tambah / Edit Produk: <img width="296" height="579" alt="image" src="https://github.com/user-attachments/assets/8b7d1954-1b87-4e4d-b2d6-3a482209244f" />


---

### 🛒 Penjualan & Order (`features/orders`)
- Pencatatan transaksi penjualan
- Detail penjualan

📸 **Screenshot:**
- catat Penjualan: <img width="281" height="576" alt="image" src="https://github.com/user-attachments/assets/a4fb4675-6eb3-4e6b-9338-6c8c0e1c2476" />

- Detail Penjualan: <img width="320" height="577" alt="image" src="https://github.com/user-attachments/assets/92a01870-007f-448e-b5a2-c6bda88cd714" />


---

### 💰 Keuangan (`features/finance`)
- Pencatatan pemasukan dan pengeluaran
- Ringkasan kondisi keuangan
- Monitoring arus kas (cash flow)

📸 **Screenshot:**
- Dashboard Keuangan: <img width="293" height="573" alt="image" src="https://github.com/user-attachments/assets/3d2f521b-2b0d-44a2-94e2-b9ad1c4aafb9" />


---

### 💸 Penggajian (`features/payroll`)
- Perhitungan gaji karyawan
- Data penggajian bulanan
- Integrasi dengan data produksi

📸 **Screenshot:**
- Ringkasan Penggajian: <img width="282" height="577" alt="image" src="https://github.com/user-attachments/assets/d57e154f-aca9-4274-a41e-98692fa3efe7" />


---

### 👥 Manajemen Karyawan (`features/employees`)
- Pengelolaan data karyawan
- Informasi jabatan dan status kerja
- Integrasi dengan modul penggajian

📸 **Screenshot:**
- Tambah Karyawan: <img width="285" height="556" alt="image" src="https://github.com/user-attachments/assets/4c49cf0a-971f-4d62-9422-33aa1a166455" />

- Daftar Karyawan: <img width="300" height="558" alt="image" src="https://github.com/user-attachments/assets/8ee65cb7-8855-407d-a082-90647472f347" />

---

### 🏭 Produksi (`features/production`)
- Pencatatan proses produksi
- Data hasil produksi
- Integrasi dengan inventori dan penggajian

📸 **Screenshot:**
- Tambah Produksi: <img width="289" height="563" alt="image" src="https://github.com/user-attachments/assets/b33e97e5-58a8-4dbc-8d1f-f63d0350ba7c" />

- Monitoring Produksi: <img width="298" height="572" alt="image" src="https://github.com/user-attachments/assets/d70a9320-727e-4427-aa33-32bd95372a46" />


---

### 📊 Laporan (`features/reports`)
Modul laporan digunakan untuk melihat rekap data usaha secara menyeluruh, meliputi:

- **Laporan Keuangan**
- **Laporan Penjualan**
- **Laporan Penggajian**
- **Laporan Produksi**

📸 **Screenshot:**
- Halaman Laporan Keuangan: <img width="301" height="575" alt="image" src="https://github.com/user-attachments/assets/7c8be065-a3e9-4660-a1b1-60fecf6b8111" />

- Halaman Laporan Penjualan: <img width="276" height="589" alt="image" src="https://github.com/user-attachments/assets/4441e6df-a335-4aaa-8dfd-4d128e327b28" />

- Halaman Laporan Penggajian: <img width="308" height="567" alt="image" src="https://github.com/user-attachments/assets/2087b029-26fc-4846-8b62-efa317959c01" />

- Halaman Laporan Produksi: <img width="266" height="556" alt="image" src="https://github.com/user-attachments/assets/e38c4feb-ed1c-41e5-9310-f8a4da24f44d" />


---

### 🔗 Integrasi Sistem (`features/integration`)
- Integrasi API backend
- Sinkronisasi data dengan Supabase
- Validasi dan konsistensi data antar modul

📸 **Screenshot:**
- Integrasi Backend / API: <img width="277" height="571" alt="image" src="https://github.com/user-attachments/assets/d5d67009-db62-4a6d-9e11-720d2a9467f7" />

- <img width="281" height="569" alt="image" src="https://github.com/user-attachments/assets/c4ad89f6-3079-4759-826a-7f5ff4f6ceae" />

-<img width="288" height="558" alt="image" src="https://github.com/user-attachments/assets/e61f8f4a-bc91-4437-98c2-cddd373caf6e" />

---

### 👤 Profil Pengguna (`features/profile`)
- Informasi akun pengguna
- Pengaturan akun
- Logout

📸 **Screenshot:**
- Halaman Profil: <img width="320" height="580" alt="image" src="https://github.com/user-attachments/assets/07b7c4af-fb22-4842-a315-051c8ee89aed" />

-Halaman Keamanan Akun: <img width="294" height="559" alt="image" src="https://github.com/user-attachments/assets/2a66f9e1-a04f-4a1f-a59d-5bd2b42b68e2" />

- Informasi Perusahaan: <img width="315" height="547" alt="image" src="https://github.com/user-attachments/assets/e91bf371-e244-46b6-b0a5-3059badce745" />

- Preferensi: <img width="309" height="577" alt="image" src="https://github.com/user-attachments/assets/3376a2b3-592b-41b3-880a-8295ce0e863b" />

-Pusat Bantuan: <img width="297" height="585" alt="image" src="https://github.com/user-attachments/assets/ad752950-6bf6-43ed-90a9-8ef678c90ae0" />

- Tentang Aplikasi: <img width="298" height="570" alt="image" src="https://github.com/user-attachments/assets/db958446-d963-4721-a94f-4a4e1cd5bdf8" />

---

## 🛠 Tech Stack

- **Flutter**
- **Dart**
- **Supabase** (Authentication & Database)
- **REST API**
- **Feature-Based Architecture**

---



🎓 Konsep yang Diterapkan

✅ Modular Architecture

✅ State Management (Riverpod)

✅ Supabase Integration

✅ CRUD Operations

✅ Authentication & Authorization

✅ Business Logic Separation

✅ Asynchronous Programming

✅ Responsive & Themed UI

---

## 📜 License

© 2026
**Bisnisku Application**
Project UAS Pemrograman Mobile 2

