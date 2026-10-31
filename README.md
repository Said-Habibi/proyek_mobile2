# YouTube UI Clone (Flutter)

Aplikasi Flutter sederhana yang meniru tampilan YouTube, dibuat sebagai tugas kuliah. Video diputar langsung di dalam aplikasi memakai package [`youtube_player_flutter`](https://pub.dev/packages/youtube_player_flutter).

> Proyek ini hanya meniru **tampilan**. Data video masih dummy, dan sebagian besar tombol (suka, bagikan, subscribe, dll.) belum berfungsi.

Kode sengaja ditulis sederhana dan hanya memakai konsep dasar Flutter: `StatelessWidget`, `StatefulWidget`, `TabBar`, dan `BottomNavigationBar`.

<!--
Tambahkan screenshot aplikasi di sini, contoh:
1. Buat folder `screenshots/` lalu masukkan gambar (home.png, shorts.png, player.png).
2. Tulis: ![Halaman Home](screenshots/home.png)
-->

## Daftar Isi

- [Fitur](#fitur)
- [Cara Menjalankan](#cara-menjalankan)
- [Struktur Folder](#struktur-folder)
- [Alur Aplikasi](#alur-aplikasi)
- [Penjelasan `youtube_player_flutter`](#penjelasan-youtube_player_flutter)
- [Penjelasan Konsep Flutter Lain](#penjelasan-konsep-flutter-lain)
- [Model dan Data Dummy](#model-dan-data-dummy)
- [Keterbatasan dan Masalah Umum](#keterbatasan-dan-masalah-umum)
- [Urutan Membaca Kode](#urutan-membaca-kode)

## Fitur

- **Bottom navigation** dengan 4 menu: Home, Shorts, Create, You.
- **Tab di halaman Home** (`TabBar`): Home, Subs, Music, Live, More.
- **Pemutar video** dengan progress bar dan tombol fullscreen, lengkap dengan judul, tombol aksi, dan daftar video lain.
- **Shorts**: video yang digeser ke atas/bawah, ketuk layar untuk play/pause.
- **Profil**: riwayat tontonan dan menu library.

## Cara Menjalankan

**Yang dibutuhkan**

- [Flutter SDK](https://docs.flutter.dev/get-started/install) versi terbaru (Dart `^3.13.5`, sesuai `pubspec.yaml`)
- Emulator atau HP **Android / iOS**
- Koneksi internet (thumbnail dan video diambil dari YouTube)

**Langkah**

```bash
git clone https://github.com/Said-Habibi/proyek_mobile2.git
cd proyek_mobile2
flutter pub get
flutter run
```

**Catatan platform:** menurut dokumentasinya, `youtube_player_flutter` mendukung Android dan iOS. Jadi pemutar video mungkin tidak berjalan di Windows, Linux, atau web, walaupun foldernya ada di proyek (folder itu hanya bawaan template Flutter).

**Izin internet:** izin `INTERNET` sudah ada di `android/app/src/main/AndroidManifest.xml`. Kalau kamu memakai kode ini di proyekmu sendiri, pastikan izin itu juga ada.

## Struktur Folder

```
lib/
├── main.dart                  # titik awal aplikasi + tema
├── models/
│   └── video.dart             # class Video (id, judul, channel, dst.)
├── data/
│   └── dummy_data.dart        # daftar ID video & data contoh
├── screens/                   # satu file = satu halaman penuh
│   ├── main_screen.dart       # kerangka: AppBar + BottomNavigationBar
│   ├── home_screen.dart       # TabBar (Home, Subs, Music, Live, More)
│   ├── shorts_screen.dart     # Shorts (PageView + pemutar)
│   ├── player_screen.dart     # halaman pemutar video
│   └── profile_screen.dart    # halaman "You"
└── widgets/                   # potongan tampilan yang dipakai berulang
    ├── thumbnail.dart         # gambar thumbnail
    ├── video_card.dart        # kartu video
    ├── sponsored_card.dart    # kartu iklan
    ├── shorts_shelf.dart      # rak Shorts di Home
    └── youtube_logo.dart      # logo di AppBar
test/
└── widget_test.dart           # tes kecil untuk class Video
```

Aturan sederhananya: yang berupa **halaman penuh** ada di `screens/`, yang berupa **potongan tampilan** yang dipakai di banyak tempat ada di `widgets/`.

## Alur Aplikasi

```
main.dart
  └─ MainScreen  (BottomNavigationBar)
       ├─ Home    → HomeScreen (DefaultTabController + TabBar)
       │             ├─ VideoCard  ── ditekan ──▶ PlayerScreen
       │             └─ ShortsShelf ─ ditekan ──▶ ShortsScreen
       ├─ Shorts  → ShortsScreen
       ├─ Create  → hanya menampilkan SnackBar
       └─ You     → ProfileScreen
```

> Perhatikan ada dua "Home": **menu Home** di bottom navigation (membuka `HomeScreen`) dan **tab Home** di dalam `HomeScreen` (feed video).

## Penjelasan `youtube_player_flutter`

### Apa itu?

Package untuk memutar video YouTube di dalam aplikasi Flutter. Di balik layar, package ini menampilkan webview yang memuat pemutar resmi YouTube (iFrame Player API). Kamu cukup memberi **ID video**, tidak perlu mengunduh videonya.

Versi yang dipakai di proyek ini: `youtube_player_flutter 9.1.3` (lihat `pubspec.lock`).

```yaml
# pubspec.yaml
dependencies:
  youtube_player_flutter: ^9.0.0
```

### Mengambil ID video

ID adalah potongan unik di link video:

| Link | ID |
|---|---|
| `https://www.youtube.com/watch?v=dQw4w9WgXcQ` | `dQw4w9WgXcQ` |
| `https://youtu.be/dQw4w9WgXcQ` | `dQw4w9WgXcQ` |
| `https://www.youtube.com/shorts/dQw4w9WgXcQ` | `dQw4w9WgXcQ` |

### Cara paling dasar (3 langkah)

1. **Buat controller** di `initState`.
2. **Tampilkan** dengan widget `YoutubePlayer`.
3. **Buang controller** di `dispose`.

```dart
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ContohPlayer extends StatefulWidget {
  const ContohPlayer({super.key});

  @override
  State<ContohPlayer> createState() => _ContohPlayerState();
}

class _ContohPlayerState extends State<ContohPlayer> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'dQw4w9WgXcQ',
      flags: YoutubePlayerFlags(autoPlay: true),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // wajib, supaya video berhenti dan memori dibebaskan
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(controller: _controller);
  }
}
```

Karena butuh `initState` dan `dispose`, halaman yang memakai pemutar harus berupa **StatefulWidget**.

### Fungsi dan class yang dipakai di proyek ini

| Nama | Fungsi | Dipakai di |
|---|---|---|
| `YoutubePlayerController` | "Remote control" pemutar. Menyimpan ID video dan pengaturannya. Parameter: `initialVideoId`, `flags`. | `player_screen.dart`, `shorts_screen.dart` |
| `YoutubePlayerFlags` | Kumpulan pengaturan pemutar (lihat tabel di bawah). | `player_screen.dart`, `shorts_screen.dart` |
| `YoutubePlayer` | Widget yang menampilkan video. Parameter: `controller`, `showVideoProgressIndicator`, `progressColors`. | `player_screen.dart`, `shorts_screen.dart` |
| `ProgressBarColors` | Warna progress bar: `playedColor` (bagian yang sudah ditonton) dan `handleColor` (bulatan penggeser). | `player_screen.dart` |
| `YoutubePlayerBuilder` | Pembungkus pemutar. Package merekomendasikannya supaya mode fullscreen bisa bekerja. | `player_screen.dart` |
| `controller.play()` | Memutar video. | `shorts_screen.dart` |
| `controller.pause()` | Menjeda video. | `shorts_screen.dart` |
| `controller.dispose()` | Membuang controller saat halaman ditutup. | keduanya |

**Pengaturan di `YoutubePlayerFlags` yang dipakai:**

| Flag | Arti | Dipakai di |
|---|---|---|
| `autoPlay: true` | Video langsung diputar saat halaman dibuka. | Player, Shorts |
| `loop: true` | Video diulang terus setelah selesai. | Shorts |
| `hideControls: true` | Menyembunyikan kontrol bawaan (tombol play, progress bar, dll.). | Shorts |

### Contoh 1: halaman pemutar (`player_screen.dart`)

```dart
// initState: buat controller
_controller = YoutubePlayerController(
  initialVideoId: widget.video.id,
  flags: YoutubePlayerFlags(autoPlay: true),
);

// build: bungkus pemutar dengan YoutubePlayerBuilder
return YoutubePlayerBuilder(
  player: YoutubePlayer(
    controller: _controller,
    showVideoProgressIndicator: true,
    progressColors: ProgressBarColors(
      playedColor: Colors.red,
      handleColor: Colors.redAccent,
    ),
  ),
  builder: (context, player) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            player, // widget pemutar ditaruh di sini
            Expanded(child: _VideoDetails(video: widget.video)),
          ],
        ),
      ),
    );
  },
);
```

`YoutubePlayerBuilder` membutuhkan dua hal: `player` (widget `YoutubePlayer` yang sudah diatur) dan `builder` (fungsi yang menyusun halaman). Di dalam `builder`, `player` adalah widget pemutar tadi, tinggal kita letakkan di tempat yang diinginkan, di sini di atas `Column`.

### Contoh 2: Shorts (`shorts_screen.dart`)

```dart
_controller = YoutubePlayerController(
  initialVideoId: widget.video.id,
  flags: YoutubePlayerFlags(autoPlay: true, loop: true, hideControls: true),
);
```

Tampilan Shorts disusun dari 3 lapisan di dalam `Stack`:

1. **Video** (`YoutubePlayer`), dibungkus `IgnorePointer`.
2. **Lapisan transparan** (`GestureDetector`) untuk menangkap ketukan play/pause.
3. **Judul** di bagian bawah.

Kenapa memakai `IgnorePointer`? Pemutar adalah webview yang "menelan" semua sentuhan. Tanpa `IgnorePointer`, jari yang menggeser ke atas/bawah tidak sampai ke `PageView`, sehingga halaman Shorts tidak bisa digeser. Dengan `IgnorePointer`, sentuhan "tembus" ke lapisan di belakangnya.

Play/pause saat layar diketuk:

```dart
void _togglePlay() {
  setState(() => _isPaused = !_isPaused);

  if (_isPaused) {
    _controller.pause();
  } else {
    _controller.play();
  }
}
```

Satu halaman Short punya **satu controller sendiri**. `PageView` hanya membuat halaman yang sedang terlihat dan membuangnya saat tergeser keluar, jadi controller dibuat di `initState` dan dibuang di `dispose`. Video lama otomatis berhenti.

### Fungsi lain dari package (belum dipakai, untuk pengembangan)

| Fungsi | Kegunaan |
|---|---|
| `controller.metadata.title` / `.author` | Judul dan nama channel **video asli**. Baru terisi setelah pemutar siap. Bisa ditampilkan lewat parameter `topActions` milik `YoutubePlayer`. |
| `controller.load('ID')` | Mengganti video tanpa membuat controller baru. |
| `controller.mute()` / `controller.unMute()` | Membisukan / menyalakan suara. |
| `controller.value.isPlaying` | Mengecek apakah video sedang diputar. |
| `onEnded` (parameter `YoutubePlayer`) | Dipanggil saat video selesai, misalnya untuk memutar video berikutnya. |
| `FullScreenButton` | Tombol fullscreen yang bisa ditaruh di tempat sendiri. |

Contoh lengkapnya ada di [halaman example package](https://pub.dev/packages/youtube_player_flutter/example).

## Penjelasan Konsep Flutter Lain

| Konsep | Penjelasan singkat | Contoh di proyek |
|---|---|---|
| **StatelessWidget** | Widget yang tampilannya tetap. | `HomeScreen`, `VideoCard`, `ProfileScreen` |
| **StatefulWidget** | Widget yang punya data berubah, atau butuh `initState` / `dispose`. | `MainScreen` (menu terpilih), `ShortsScreen`, `PlayerScreen` |
| **setState** | Memberi tahu Flutter bahwa data berubah, lalu tampilan digambar ulang. | `_onItemTapped` di `MainScreen` |
| **initState / dispose** | `initState` dijalankan sekali saat halaman dibuat, `dispose` saat halaman dibuang. Dipakai untuk membuat dan membuang controller. | `PlayerScreen`, `ShortsScreen` |
| **BottomNavigationBar** | Menu di bagian bawah layar. Pakai `currentIndex`, `onTap`, dan `items`. | `main_screen.dart` |
| **DefaultTabController + TabBar + TabBarView** | `TabBar` adalah deretan tab, `TabBarView` adalah isi tiap tab. `length` harus sama dengan jumlah `Tab` dan jumlah isi `TabBarView`. | `home_screen.dart` |
| **Navigator.push + MaterialPageRoute** | Pindah ke halaman baru (tombol back otomatis tersedia). | `openPlayer()` di `player_screen.dart` |
| **ListView / ListView.builder** | Daftar yang bisa di-scroll. `builder` membuat item sesuai kebutuhan, cocok untuk daftar panjang. | feed di `home_screen.dart`, riwayat di `profile_screen.dart` |
| **GridView.count** | Susunan kotak dalam beberapa kolom. `shrinkWrap` dan `NeverScrollableScrollPhysics` membuatnya ikut di-scroll oleh `ListView` induknya. | `shorts_shelf.dart` |
| **PageView.builder** | Halaman yang digeser satu per satu. `scrollDirection: Axis.vertical` membuatnya naik-turun. | `shorts_screen.dart` |
| **Stack + Positioned** | Menumpuk widget. `Positioned` mengatur posisi widget di dalam tumpukan. | label durasi di `video_card.dart`, lapisan di Shorts |
| **GestureDetector** | Mendeteksi sentuhan, misalnya `onTap`. | `VideoCard`, kartu Short, layar Shorts |
| **Image.network** | Menampilkan gambar dari internet. Di `Thumbnail`, ada `Container` abu-abu di belakangnya yang terlihat saat gambar belum atau gagal dimuat. | `thumbnail.dart` |
| **ClipRRect** | Memotong isi widget mengikuti sudut yang membulat. | kartu Short |
| **`for` / `if` di dalam list** | Membuat widget dari daftar data: `for (final v in videos) VideoCard(video: v)`. `if` menampilkan widget hanya jika syaratnya benar. | `home_screen.dart`, `video_card.dart` |
| **Widget privat `_Nama`** | Awalan `_` berarti hanya dipakai di file itu. Dipakai untuk memecah `build()` yang panjang. | `_VideoInfo`, `_ProfileHeader`, `_HistoryList` |
| **late final** | Variabel yang diisi nanti, tapi hanya sekali. Dipakai untuk controller yang dibuat di `initState`. | `_controller`, `_pageController` |
| **const** | Widget yang tidak pernah berubah, jadi tidak perlu dibuat ulang. | di hampir semua file |
| **SnackBar** | Pesan singkat di bagian bawah layar. | tombol Create di `MainScreen` |

## Model dan Data Dummy

**`models/video.dart`** menyimpan data satu video:

| Field | Isi |
|---|---|
| `id` | ID video YouTube |
| `title` | judul (dummy) |
| `channel` | nama channel (dummy) |
| `views`, `timeAgo`, `duration` | keterangan tambahan (dummy) |
| `thumbnail` | alamat gambar sampul, dibuat otomatis dari ID: `https://img.youtube.com/vi/<ID>/hqdefault.jpg` |

**`data/dummy_data.dart`** berisi daftar ID per bagian (Home, Music, Subs, Shorts). Untuk mengganti video, cukup ubah ID di bagian atas file:

```dart
const _homeIds = ['dQw4w9WgXcQ', 'dQw4w9WgXcQ', 'dQw4w9WgXcQ'];
```

Judul seperti `Home #1` dibuat otomatis oleh fungsi `_buildVideos`. Judul itu **bukan** judul asli dari YouTube. Kalau mau judul sendiri, tulis langsung lewat `Video(id: ..., title: 'Judulku', channel: '...')`.

## Keterbatasan dan Masalah Umum

- Hanya tampilan: tombol seperti Suka, Bagikan, Subscribe, Create, dan pencarian belum berfungsi.
- Judul, channel, jumlah penonton, dan durasi adalah data contoh.
- Butuh internet. Kalau thumbnail hanya tampil abu-abu, cek koneksi atau ID videonya.
- Video yang pemiliknya menonaktifkan pemutaran di aplikasi lain tidak bisa diputar. Coba ganti dengan ID video lain.
- Saat berpindah menu di bottom navigation, halaman sebelumnya dibuang. Jadi posisi scroll dan tab di Home kembali ke awal, dan video Shorts berhenti.

## Urutan Membaca Kode

Kalau baru pertama kali membaca proyek ini, urutan berikut paling mudah diikuti:

1. `main.dart`: titik awal dan tema.
2. `screens/main_screen.dart`: kerangka aplikasi dan `BottomNavigationBar`.
3. `screens/home_screen.dart`: `TabBar` dan isi tiap tab.
4. `widgets/video_card.dart`: kartu video, lalu `openPlayer()` di `screens/player_screen.dart`.
5. `screens/player_screen.dart`: pemakaian `youtube_player_flutter` yang paling dasar.
6. `screens/shorts_screen.dart`: pemakaian yang lebih lanjut (`PageView`, `IgnorePointer`, play/pause).
7. `screens/profile_screen.dart`: halaman terakhir, isinya sebagian besar tampilan biasa.

## Referensi

- [youtube_player_flutter di pub.dev](https://pub.dev/packages/youtube_player_flutter)
- [Dokumentasi Flutter](https://docs.flutter.dev/)