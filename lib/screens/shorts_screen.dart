import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../data/dummy_data.dart';
import '../models/video.dart';

/// Halaman Shorts: video yang digeser ke atas/bawah.
/// [initialIndex] menentukan Short mana yang tampil pertama kali.
class ShortsScreen extends StatefulWidget {
  const ShortsScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<ShortsScreen> createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<ShortsScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemCount: shortsVideos.length,
        itemBuilder: (context, index) {
          return _ShortPlayer(video: shortsVideos[index]);
        },
      ),
    );
  }
}

/// Satu halaman Short: pemutar video, tap untuk play/pause, dan judul.
/// PageView hanya membuat halaman yang sedang terlihat dan membuangnya setelah
/// tergeser keluar, jadi controller dibuat di initState dan dibuang di dispose.
class _ShortPlayer extends StatefulWidget {
  const _ShortPlayer({required this.video});

  final Video video;

  @override
  State<_ShortPlayer> createState() => _ShortPlayerState();
}

class _ShortPlayerState extends State<_ShortPlayer> {
  late final YoutubePlayerController _controller;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.id,
      flags: YoutubePlayerFlags(autoPlay: true, loop: true, hideControls: true),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() => _isPaused = !_isPaused);

    if (_isPaused) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    // StackFit.expand membuat semua lapisan memenuhi seluruh halaman.
    return Stack(
      fit: StackFit.expand,
      children: [
        // Lapisan 1: video.
        // IgnorePointer membuat sentuhan "tembus" ke PageView di belakangnya,
        // supaya halaman tetap bisa digeser.
        IgnorePointer(child: YoutubePlayer(controller: _controller)),

        // Lapisan 2: lapisan transparan untuk menangkap tap play/pause.
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _togglePlay,
          child: _isPaused
              ? const Center(
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white70,
                    size: 80,
                  ),
                )
              : null,
        ),

        // Lapisan 3: judul di bagian bawah.
        Positioned(
          left: 12,
          right: 12,
          bottom: 48,
          child: IgnorePointer(
            child: Text(
              widget.video.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
