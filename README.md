# proyek_mobile2

Aplikasi tiruan YouTube (hanya UI) dengan data dummy. Pemutar video memakai `youtube_player_flutter`, dan thumbnail diambil dari `img.youtube.com`.

## Package

| Package | Fungsi |
|---|---|
| `flutter/material.dart` | Widget Material Design |
| `youtube_player_flutter` | Memutar video di halaman pemutar dan Shorts |

## Struktur

```
lib/
├── main.dart
├── models/video.dart
├── data/
│   └── dummy_data.dart
├── screens/
│   ├── main_screen.dart
│   ├── home_screen.dart
│   ├── player_screen.dart
│   ├── shorts_screen.dart
│   └── profile_screen.dart
└── widgets/
    ├── video_card.dart
    ├── thumbnail.dart
    ├── shorts_shelf.dart
    └── youtube_logo.dart
test/
└── widget_test.dart
```

## Fungsi per file

### Entry point, model, dan data
| File | Class / fungsi | Fungsi |
|---|---|---|
| `main.dart` | `main()`, `YoutubeUiApp` | Menjalankan aplikasi dan mengatur tema (Material 3, warna dasar merah, AppBar putih). Halaman awalnya `MainScreen` |
| `models/video.dart` | `Video` | Model data video (`id`, `title`, `channel`, `views`, `timeAgo`, `duration`). Getter `thumbnail` membentuk URL thumbnail dari ID video |
| `data/dummy_data.dart` | `_buildVideos()` | Mengubah daftar ID menjadi daftar `Video` dengan judul dan channel otomatis. Menghasilkan `homeVideos`, `musicVideos`, `subsVideos`, `shortsVideos` |

### Screens
| File | Class / fungsi | Fungsi |
|---|---|---|
| `main_screen.dart` | `MainScreen` | Kerangka utama dengan `BottomNavigationBar` (Home, Shorts, Create, Profile) dan AppBar berisi logo, notifikasi, dan pencarian |
| | `_onItemTapped()` | Berpindah tab. Tab Create hanya menampilkan `SnackBar` karena fitur upload belum dibuat |
| `home_screen.dart` | `HomeScreen` | Lima tab (Home, Subs, Music, Live, More) dengan `DefaultTabController` |
| | `_HomeFeed` | Daftar video beranda |
| | `_SubsFeed`, `_ChannelAvatar` | Daftar channel langganan (avatar) dan videonya |
| | `_MusicFeed` | Daftar video musik |
| | `_LiveEmpty` | Tampilan kosong untuk tab Live |
| | `_MoreMenu` | Menu tab More |
| `player_screen.dart` | `openPlayer()` | Membuka `PlayerScreen` dengan `Navigator.push` |
| | `PlayerScreen` | Memutar video dengan `YoutubePlayerBuilder` (agar fullscreen berfungsi). `initState()` membuat controller, `dispose()` membersihkannya |
| | `_VideoDetails` | Judul, jumlah tayangan, dan waktu unggah |
| | `_ChannelActionRow`, `_IconAction` | Baris channel dan tombol aksi (suka, bagikan, dan sebagainya) |
| | `_CommentPreview` | Pratinjau komentar |
| `shorts_screen.dart` | `ShortsScreen` | `PageView` vertikal untuk menggeser Shorts, dengan `PageController` |
| | `_ShortPlayer` | Satu halaman Short: video autoplay, loop, tanpa kontrol |
| | `_togglePlay()` | Tap untuk pause atau putar |
| `profile_screen.dart` | `ProfileScreen` | Halaman profil |
| | `_ProfileHeader`, `_ProfileButtons` | Avatar dan nama, serta tombol aksi |
| | `_SectionTitle`, `_HistoryList` | Judul bagian dan riwayat tontonan |

### Widgets (komponen yang dipakai ulang)
| File | Class | Fungsi |
|---|---|---|
| `video_card.dart` | `VideoCard` | Kartu video: thumbnail, durasi, judul, channel. Saat di-tap membuka pemutar |
| | `_ThumbnailWithDuration`, `_VideoInfo` | Bagian gambar dengan label durasi, dan bagian teks info |
| `thumbnail.dart` | `Thumbnail` | Gambar thumbnail dari `Image.network` dengan fallback container |
| `shorts_shelf.dart` | `ShortsShelf`, `_ShortCard` | Rak Shorts horizontal di beranda |
| `youtube_logo.dart` | `YoutubeLogo` | Logo YouTube untuk AppBar |

## Widget dan fungsinya

| Kategori | Widget | Fungsi |
|---|---|---|
| Struktur | `MaterialApp`, `Scaffold`, `AppBar`, `SafeArea`, `ThemeData`, `AppBarTheme` | Kerangka aplikasi dan tema global |
| Layout | `Column`, `Row`, `Container`, `Padding`, `SizedBox`, `Expanded`, `Center`, `Divider`, `AspectRatio` | Menyusun dan membagi ruang, menjaga rasio video 16:9 |
| Stack | `Stack`, `Positioned` | Menumpuk label durasi di atas thumbnail |
| Styling | `BoxDecoration`, `DecoratedBox`, `LinearGradient`, `ClipRRect`, `ClipOval`, `CircleAvatar`, `TextStyle` | Dekorasi, gradasi, potongan bentuk, avatar |
| Gambar | `Image.network`, `NetworkImage`, `Icon` | Thumbnail dari internet dan ikon |
| List dan grid | `ListView`, `ListView.builder`, `GridView.count`, `ListTile`, `NeverScrollableScrollPhysics` | Daftar video, grid, baris daftar, mematikan scroll bersarang |
| Halaman | `PageView`, `PageController` | Geser vertikal untuk Shorts |
| Navigasi | `Navigator.push`, `MaterialPageRoute`, `BottomNavigationBar`, `DefaultTabController`, `TabBar`, `TabBarView` | Pindah halaman, menu bawah, tab beranda |
| Interaksi | `GestureDetector`, `InkWell`, `IconButton`, `ElevatedButton`, `OutlinedButton`, `SnackBar`, `IgnorePointer` | Tap, tombol, pesan singkat, mengabaikan sentuhan |
| Media | `YoutubePlayerController`, `YoutubePlayerFlags`, `YoutubePlayer`, `YoutubePlayerBuilder`, `ProgressBarColors` | Mengatur dan menampilkan video, fullscreen, warna progres |
| State | `StatelessWidget`, `StatefulWidget`, `setState()`, `initState()`, `dispose()` | Widget tetap dan dinamis, siklus hidup controller |
| Data | `class Video`, `const` constructor, `required`, getter | Model data yang tidak bisa diubah |