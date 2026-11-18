# proyek_mobile2

Aplikasi tiruan YouTube (YouTube Clone) berbasis Flutter yang mendukung multiplatform (**Linux Desktop**, **Windows**, **macOS**, **Android**, dan **iOS**). Aplikasi ini mengambil metadata dan stream langsung dari YouTube menggunakan `youtube_explode_dart`, memutar video secara native menggunakan `video_player` yang diperkuat dengan backend `fvp`, serta memiliki antarmuka responsif yang fleksibel terhadap perubahan ukuran layar (*window resize*).

---

## Dependensi & Fungsinya

| Package | Versi | Fungsi & Implementasi dalam Proyek |
|---|---|---|
| `video_player` | `^2.9.2` | Plugin resmi Flutter untuk memutar video. Digunakan di `PlayerScreen` dan `ShortsScreen` untuk memutar stream URL video YouTube, mengontrol status putar/jeda (*play/pause*), perulangan (*looping*), penunjuk durasi, dan progress bar. |
| `fvp` | `^0.39.1` | Drop-in backend plugin berbasis FFmpeg & libmdk untuk `video_player`. Mengaktifkan pemutaran video native dengan akselerasi perangkat keras (*hardware acceleration*) di **Linux Desktop**, Windows, dan macOS, sehingga mengatasi error `UnimplementedError: init()` pada platform desktop. |
| `youtube_explode_dart` | `^3.1.0` | Library Dart murni untuk mengekstrak data dari YouTube tanpa memerlukan API key / kuota Google Cloud. Digunakan di `YoutubeService` untuk mengambil metadata (judul, channel, durasi, view count, waktu upload, thumbnail) dan URL stream langsung (audio + video muxed MP4). |
| `intl` | `^0.19.0` | Digunakan untuk formatting angka, tanggal, dan waktu secara terstandarisasi. |
| `cupertino_icons` | `^1.0.8` | Menyediakan kumpulan ikon bergaya iOS/Cupertino untuk kebutuhan antarmuka. |

---

## Perbaruan Arsitektur & Perbaikan Masalah

1. **Dukungan Penuh Linux Desktop (Bebas WebView & Bebas Unimplemented Error)**
   * Sebelumnya, penggunaan `youtube_player_flutter` memicu exception `A platform implementation for flutter_inappwebview has not been set` karena `flutter_inappwebview` tidak mendukung Linux desktop.
   * Penggunaan `video_player` tanpa backend juga memicu `UnimplementedError: init()`.
   * **Solusi:** Diinisialisasi `fvp.registerWith();` pada [main.dart](file:///home/said/proyek_mobile2/lib/main.dart) sebelum `runApp()`. Pemutar video kini berjalan lancar di Linux menggunakan video pipeline native.
2. **Layout Fleksibel & Anti-Gepeng (Responsif terhadap Window Resize)**
   * Sebelumnya, tinggi thumbnail di-hardcode kaku ke `height: 200`, sehingga saat jendela diperlebar di desktop gambar menjadi persegi panjang pipih (terpotong atas-bawah).
   * **Solusi:** Menggunakan widget `AspectRatio(aspectRatio: 16 / 9)` pada [video_card.dart](file:///home/said/proyek_mobile2/lib/widgets/video_card.dart) dan [player_screen.dart](file:///home/said/proyek_mobile2/lib/screens/player_screen.dart), serta membungkus feed dengan `ConstrainedBox(maxWidth: 1000)` agar konten tetap proporsional dan terpusat di layar monitor lebar.
3. **Pemberantasan Bug Suara/Video di Latar Belakang (*Background Playback Bug*)**
   * Menggunakan lifecycle `_isDisposed` flag dan pengecekan ketat pada setiap step asynchronous (`getStreamUrl` dan `controller.initialize()`). Jika pengguna keluar sebelum proses pemuatan selesai, controller langsung di-`dispose()` dan tidak pernah memutar suara.
   * Menambahkan pelacak `isActive` pada [shorts_screen.dart](file:///home/said/proyek_mobile2/lib/screens/shorts_screen.dart) sehingga saat menggeser antar Short, video sebelumnya otomatis di-`pause()`.
4. **Navigasi Lengkap & Elemen Hiasan pada Shorts**
   * Menambahkan tombol **Kembali** (*Back Arrow*) dan tombol pintasan **Beranda** (*Home Shortcut*) pada bagian atas Shorts.
   * Menambahkan deretan tombol aksi interaktif di sisi kanan (Like, Dislike, Comment, Share, Remix, Sound Icon) serta detail channel + tombol *Subscribe* di sisi kiri bawah.
   * Bottom navigation bar secara otomatis beralih ke *Dark Theme* saat berada di tab Shorts.

---

## Struktur Direktori

```
lib/
├── main.dart                      # Inisialisasi fvp, tema aplikasi Material 3, dan root widget
├── models/
│   └── video.dart                 # Data model Video dengan copyWith, serialization, dan getter thumbnail
├── data/
│   └── dummy_data.dart            # Data cache, ID video YouTube, fallback dummy, dan helper async
├── services/
│   └── youtube_service.dart       # Integrasi youtube_explode_dart (metadata, pencarian, stream URL)
├── screens/
│   ├── main_screen.dart           # Scaffold utama, BottomNavigationBar dinamis, dan AppBar
│   ├── home_screen.dart           # Tab bar Home (Home, Subs, Music, Live, More) responsif
│   ├── player_screen.dart         # Layar pemutar video 16:9 dengan kontrol kustom dan rekomendasi
│   ├── shorts_screen.dart         # Layar video vertikal PageView, tombol navigasi, dan tombol aksi
│   └── profile_screen.dart        # Layar profil pengguna dan riwayat tontonan
└── widgets/
    ├── video_card.dart            # Kartu video responsif dengan AspectRatio 16:9
    ├── thumbnail.dart             # Penampil gambar thumbnail dengan error handling
    └── youtube_logo.dart          # Widget logo YouTube untuk AppBar
```

---

## Detail Widget yang Digunakan & Fungsinya

| Kategori | Widget | Fungsi & Implementasi dalam Proyek |
|---|---|---|
| **Struktur & Tema** | `MaterialApp` | Root aplikasi Flutter, konfigurasi tema global Material 3 dan routing. |
| | `Scaffold` | Menyediakan kerangka dasar halaman (AppBar, Body, BottomNavigationBar). |
| | `SafeArea` | Memastikan konten tidak tertutup notch layar hp atau titlebar sistem. |
| | `ThemeData`, `AppBarTheme` | Kustomisasi warna dasar merah YouTube, scaffold background putih, dan AppBar transparan. |
| **Responsivitas & Layout** | `AspectRatio` | **Kunci fleksibilitas ukuran:** Memaksa thumbnail dan video player selalu mempertahankan proporsi 16:9 berapapun ukuran jendela di-resize. |
| | `ConstrainedBox`, `BoxConstraints` | Membatasi lebar maksimum halaman menjadi 1000px agar tampilan desktop tidak terlalu melebar. |
| | `Column`, `Row`, `Expanded` | Menyusun elemen vertikal dan horizontal dengan pembagian ruang fleksibel. |
| | `Container`, `Padding`, `SizedBox` | Pengaturan jarak (*margin/padding*), dekorasi latar, dan pembatas ukuran. |
| | `Center`, `Divider` | Menengahkan konten di layar lebar dan garis pemisah antar menu. |
| **Tumpukan & Posisi** | `Stack`, `Positioned` | Menumpuk kontrol video, label durasi di atas thumbnail, dan tombol aksi di atas pemutar Shorts. |
| **Styling & Bentuk** | `BoxDecoration`, `DecoratedBox` | Memberikan latar belakang bulat transparan pada tombol aksi, border, dan border-radius. |
| | `ClipRRect`, `ClipOval` | Memotong sudut kartu video agar membulat dan membuat avatar channel berbentuk lingkaran sempurna. |
| | `CircleAvatar` | Menampilkan avatar channel YouTube (dengan teks inisial channel atau gambar). |
| | `TextStyle`, `Shadow` | Tipografi tebal dan bayangan (*drop shadow*) agar teks di atas video tetap terbaca jelas. |
| **List & Scroll** | `ListView`, `ListView.builder` | Daftar video vertikal dan horizontal (avatar langganan dan riwayat tontonan). |
| | `ListTile` | Komponen baris standar untuk menu akun, setelan, dan riwayat. |
| **Halaman & Swipe** | `PageView.builder`, `PageController` | Menyediakan mekanisme geser vertikal (*swipe up/down*) untuk video Shorts. |
| **Navigasi & Kontrol** | `Navigator.push`, `Navigator.pop` | Berpindah antar halaman (membuka player, membuka pencarian) dan menutup halaman. |
| | `PopScope` | Mencegah kebocoran navigasi dan memastikan pembersihan memori pemutar video saat tombol kembali ditekan. |
| | `BottomNavigationBar` | Menu navigasi 4 tab bawah (Home, Shorts, Create, You) dengan perubahan warna dinamis. |
| | `DefaultTabController`, `TabBar`, `TabBarView` | Manajemen 5 tab sub-kategori pada halaman Home (Home, Subs, Music, Live, More). |
| **Interaksi & Tombol** | `GestureDetector` | Menangkap tap pada seluruh kartu video untuk membuka player dan tap pada Shorts untuk play/pause. |
| | `InkWell`, `Material` | Menghasilkan efek sentuhan *ripple* pada tombol navigasi dan tombol aksi Shorts. |
| | `IconButton`, `ElevatedButton`, `OutlinedButton` | Tombol interaktif (kembali, cari, notifikasi, putar/jeda, subscribe, buat channel). |
| | `Tooltip` | Menampilkan teks keterangan mengambang saat ikon diarahkan oleh kursor mouse pada desktop. |
| | `IgnorePointer` | Mencegah sentuhan pada overlay teks agar interaksi tap tetap tembus ke pemutar video di belakangnya. |
| **Media & Pemutar Video** | `VideoPlayerController` | Mengelola pemutaran, buffering, durasi waktu, stream network URL, dan perulangan video. |
| | `VideoPlayer` | Menampilkan frame video yang sedang diputar ke layar. |
| | `VideoProgressIndicator` | Bilah progres video interaktif bawaan `video_player` (warna merah untuk durasi berjalan, abu-abu untuk buffering). |
| | `Image.network`, `NetworkImage` | Memuat gambar thumbnail dan avatar dari URL internet. |
| | `Icon` | Menampilkan ikon-ikon material YouTube (play, pause, like, dislike, comment, share, remix, back, home, notifikasi, dll). |
| **Async & State** | `FutureBuilder` | Menangani siklus hidup data asinkron (kondisi loading spinner, kondisi error, dan kondisi data siap tampil). |
| | `StatefulWidget`, `StatelessWidget` | Pemisahan widget statis dan widget dinamis yang memiliki state. |
| | `setState`, `initState`, `didUpdateWidget`, `dispose` | Manajemen siklus hidup widget, kontrol pemutar video, dan pembersihan resource memori. |

---

## Cara Menjalankan Aplikasi

1. **Unduh Dependensi:**
   ```bash
   flutter pub get
   ```

2. **Jalankan pada Linux Desktop:**
   ```bash
   flutter run -d linux
   ```

3. **Jalankan pada Platform Lain:**
   ```bash
   # Windows
   flutter run -d windows

   # Android
   flutter run -d android

   # Web (Opsional)
   flutter run -d chrome
   ```
