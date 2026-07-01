# 🌸 Girl Rise: Visual Novel Interaktif Berbasis Flutter

<div align="center">
  <h3>Proyek Tugas Akhir / Tugas Besar — Grafika Komputer & Visualisasi (GKV)</h3>
  <p><b>Sebuah gim naratif interaktif yang memberdayakan perempuan muda melalui simulasi pengambilan keputusan, pengelolaan batasan diri, dan kemandirian finansial.</b></p>
</div>

---

## 📖 Latar Belakang & Nilai Edukasi (*Educational Value*)

**Girl Rise** dirancang sebagai media edukasi interaktif berbentuk *Visual Novel* yang mengangkat isu-isu krusial yang dihadapi perempuan muda saat menavigasi masa depan mereka. Gim ini menantang pemain untuk mengambil keputusan strategis di bawah tekanan sosial, asmara, dan ekonomi keluarga, yang terbagi ke dalam dua skenario utama:

### 🎭 Skenario 1: Relasi vs Pendidikan & Batasan Diri
Menghadapi dilema hubungan asmara toksik dengan pacar (*Arga*) yang menuntut pernikahan muda dan mengorbankan pendidikan. Pemain diajak untuk mengenali *red flags*, menetapkan batasan (*personal boundaries*), dan memperjuangkan cita-cita perkuliahan.

### 🎭 Skenario 2: Harapan vs Realitas Ekonomi & Keluarga
Menghadapi kenyataan finansial keluarga yang sulit dan tekanan untuk putus sekolah demi bekerja atau menikah. Pemain menavigasi peluang beasiswa, komunikasi asertif dengan orang tua/guru BK, dan mencari solusi mandiri tanpa mengorbankan impian.

---

## ⚡ Arsitektur & Fitur Unggulan (*Technical Architecture*)

Proyek ini dibangun menggunakan **Flutter** dengan penerapan konsep *software engineering* dan *clean architecture* yang kokoh:

### 1. Dynamic Story Branching Engine (*Real-Time Narrative Adaptation*)
* **Meninggalkan Model Statis Linear:** Alur cerita tidak sekadar percabangan statis (`if-else` konvensional). Setiap keputusan pemain direkam ke dalam *memory tree* (*choice history*).
* **Adaptasi Narasi Otomatis:** Teks narasi pembuka (*Part 1*) dan opsi tindakan selanjutnya (*Part 2/3*) di setiap *case* secara dinamis beradaptasi dengan konsekuensi dari pilihan pemain di *case* sebelumnya (*Cause-and-Effect Narrative Model*).
* **Singleton State Management:** Diatur secara terpusat dan efisien oleh `GameStateManager` tanpa *memory leak*.

### 2. Kalibrasi Matematis Parameter Akumulasi 100% (*Optimal Playthrough Model*)
Gim melacak 4 indikator utama: **Pendidikan**, **Ekonomi**, **Relasi**, dan **Mental** (dimulai dari modal awal **50%**).
* **Zero-Waste Climax Accumulation:** Untuk mencegah parameter mengalami *overflow / clamping* (tersumbat di batas 100% sebelum klimaks), distribusi nilai dihitung menggunakan rumusan matematis presisi:
  * **Skenario 1 (6 Case):** Case 1 s.d. Case 5 berkontribusi merata **`±6%`** (Total akumulasi awal +30% = **80%**). Pada saat mengambil keputusan klimaks di Case 6 (**`+20%`**), parameter melompat dari 80% ke **tepat 100%**.
  * **Skenario 2 (5 Case):** Case 1 & 2 berkontribusi **`±7%`**, Case 3 & 4 berkontribusi **`±8%`** (Total akumulasi awal +30% = **80%**). Pada kasus penentuan akhir di Case 5 (**`+20%`**), parameter melompat ke **tepat 100%**.

### 3. Audio & UI Dynamic Graphics
* Transisi halus antarlayar menggunakan custom `FadePageRoute`.
* Pemodelan UI responsif dengan indikator bar parameter interaktif (`GameParameterBar`) dan rendering karakter dinamis (`DynamicCharacter`).

---

## 🗂 Struktur Direktori Proyek

```text
GKV-Girl-Rise/
└── girls_rise/
    ├── assets/             # Aset visual (SVG/PNG karakter & background) serta audio
    ├── lib/
    │   ├── models/         # Model data (GameStats, StatDelta, StatItem)
    │   ├── services/       # Core Engine (GameStateManager, StoryController, AudioController)
    │   ├── scenario_1/     # Alur cerita, dialog, dan screen Skenario 1 (Case 1 - Case 6)
    │   ├── scenario_2/     # Alur cerita, dialog, dan screen Skenario 2 (Case 1 - Case 5)
    │   ├── widgets/        # Komponen UI reusable (ReflectionTextBox, DialogueTextBox, dll)
    │   └── main.dart       # Titik masuk aplikasi (Entry Point)
    └── pubspec.yaml        # Konfigurasi dependensi Flutter
```

---

## 🚀 Cara Instalasi & Menjalankan Aplikasi (*How to Run*)

Pastikan Anda telah menginstal [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.0+) di sistem Anda.

1. **Masuk ke direktori aplikasi Flutter:**
   ```bash
   cd girls_rise
   ```

2. **Unduh seluruh dependensi paket:**
   ```bash
   flutter pub get
   ```

3. **Verifikasi kebersihan kode (*Static Analysis*):**
   ```bash
   dart analyze lib/
   ```
   *(Hasil verifikasi: 0 errors, 0 warnings / Lulus Clean Code)*

4. **Jalankan aplikasi di perangkat / simulator:**
   ```bash
   flutter run
   ```

---

## 🏆 Kualitas Kode & Pengujian (*Quality Assurance*)
* Proyek ini telah melewati validasi analisis statis (*Flutter Linter & Dart Analyzer*) secara menyeluruh tanpa adanya *lint warning* atau kesalahan sintaks.
* Pengurusan status permainan (*reset*, *undo/rollback*, dan *delta calculation*) terisolasi dengan baik untuk menjamin stabilitas performa selama simulasi berlangsung.

---
*Dibuat untuk memenuhi tugas perkuliahan Grafika Komputer & Visualisasi (GKV).*
