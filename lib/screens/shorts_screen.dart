import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../data/dummy_data.dart';
import '../models/video.dart';

/// Pemutar Shorts vertikal. Setiap ID di shortsVideoIds menjadi satu halaman.
class ShortsScreen extends StatefulWidget {
  const ShortsScreen({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  State<ShortsScreen> createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<ShortsScreen> {
  late final PageController _pageController;
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
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
        onPageChanged: (i) => setState(() => _current = i),
        itemBuilder: (context, i) => _ShortPlayerPage(
          key: ValueKey(i),
          video: shortsVideos[i],
          isActive: i == _current,
        ),
      ),
    );
  }
}

class _ShortPlayerPage extends StatefulWidget {
  const _ShortPlayerPage({
    super.key,
    required this.video,
    required this.isActive,
  });

  final Video video;
  final bool isActive;

  @override
  State<_ShortPlayerPage> createState() => _ShortPlayerPageState();
}

class _ShortPlayerPageState extends State<_ShortPlayerPage> {
  late final YoutubePlayerController _controller;
  late bool _paused;

  @override
  void initState() {
    super.initState();
    _paused = !widget.isActive;
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.id,
      flags: YoutubePlayerFlags(
        autoPlay: widget.isActive,
        loop: true,
        hideControls: true,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant _ShortPlayerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      _paused = !widget.isActive;
      if (widget.isActive) {
        _controller.play();
      } else {
        _controller.pause();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() => _paused = !_paused);
    if (_paused) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = YoutubePlayer(controller: _controller);

    return Stack(
      children: [
        // IgnorePointer membuat sentuhan diteruskan ke PageView,
        // sehingga halaman bisa digeser ke atas atau ke bawah.
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final minHeight = constraints.maxWidth * 16 / 9;
              final h = minHeight > constraints.maxHeight
                  ? minHeight
                  : constraints.maxHeight;
              final w = h * 9 / 16;

              return ClipRect(
                child: OverflowBox(
                  maxWidth: w,
                  maxHeight: h,
                  child: SizedBox(
                    width: w,
                    height: h,
                    child: IgnorePointer(child: player),
                  ),
                ),
              );
            },
          ),
        ),

        // Lapisan transparan untuk tap play/pause.
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _togglePlay,
            child: (_paused && widget.isActive)
                ? const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white70,
                      size: 80,
                    ),
                  )
                : null,
          ),
        ),

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
