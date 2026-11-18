import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../data/dummy_data.dart';
import '../models/video.dart';

/// Halaman Shorts: video vertikal yang digeser ke atas/bawah.
/// [initialIndex] menentukan Short mana yang tampil pertama kali.
/// [onBack] callback opsional untuk kembali ke halaman utama jika dibuka dari tab.
class ShortsScreen extends StatefulWidget {
  const ShortsScreen({
    super.key,
    this.initialIndex = 0,
    this.onBack,
  });

  final int initialIndex;
  final VoidCallback? onBack;

  @override
  State<ShortsScreen> createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<ShortsScreen> {
  late final PageController _pageController;
  List<Video> _shorts = [];
  bool _isLoading = true;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _loadShorts();
  }

  Future<void> _loadShorts() async {
    final shorts = await getShortsVideos();
    if (mounted) {
      setState(() {
        _shorts = shorts;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleBack() {
    // Utamakan pop jika layar ini dibuka via Navigator.push.
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else if (widget.onBack != null) {
      // Jika berada di tab BottomNavigationBar, alihkan ke tab Home.
      widget.onBack!();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.red),
        ),
      );
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        // Memastikan tidak ada sisa suara saat navigasi keluar
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Konten Video Vertikal PageView
            PageView.builder(
              scrollDirection: Axis.vertical,
              controller: _pageController,
              itemCount: _shorts.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return _ShortPlayer(
                  key: ValueKey(_shorts[index].id),
                  video: _shorts[index],
                  isActive: index == _currentPage,
                );
              },
            ),

            // Tombol Navigasi Kembali & Judul di Bagian Atas
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _HeaderIconButton(
                            icon: Icons.arrow_back,
                            tooltip: 'Kembali',
                            onTap: _handleBack,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Shorts',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black87,
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Tombol pintasan langsung ke Beranda jika di tab Shorts
                      if (widget.onBack != null || Navigator.canPop(context))
                        _HeaderIconButton(
                          icon: Icons.home_outlined,
                          tooltip: 'Halaman Utama',
                          onTap: () {
                            if (widget.onBack != null) {
                              widget.onBack!();
                            } else if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tombol ikon transparan dengan latar belakang semi-gelap agar jelas terlihat di video.
class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: tooltip ?? '',
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}

/// Satu halaman Short: pemutar video vertikal, tap play/pause, tombol aksi kanan, dan pencegahan bug background playback.
class _ShortPlayer extends StatefulWidget {
  const _ShortPlayer({
    super.key,
    required this.video,
    required this.isActive,
  });

  final Video video;
  final bool isActive;

  @override
  State<_ShortPlayer> createState() => _ShortPlayerState();
}

class _ShortPlayerState extends State<_ShortPlayer> {
  VideoPlayerController? _controller;
  bool _isPaused = false;
  bool _isLoading = true;
  bool _isDisposed = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didUpdateWidget(_ShortPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Jika halaman ini bergeser aktif/tidak aktif dalam PageView
    if (oldWidget.isActive != widget.isActive) {
      if (widget.isActive) {
        if (!_isPaused &&
            _controller != null &&
            _controller!.value.isInitialized) {
          _controller!.play();
        }
      } else {
        // Berhenti memutar saat pengguna menggeser ke short lain
        _controller?.pause();
      }
    }
  }

  Future<void> _initializePlayer() async {
    try {
      final streamUrl = await youtubeService.getStreamUrl(widget.video.id);
      if (_isDisposed || !mounted) return;

      final controller = VideoPlayerController.networkUrl(Uri.parse(streamUrl));
      await controller.initialize();

      // Cek apakah widget sudah ditutup/berpindah saat proses initialize
      if (_isDisposed || !mounted) {
        controller.dispose();
        return;
      }

      controller.setLooping(true);

      // Hanya putar jika halaman ini yang sedang aktif dilihat pengguna
      if (widget.isActive && !_isPaused) {
        controller.play();
      }

      setState(() {
        _controller = controller;
        _isLoading = false;
      });
    } catch (e) {
      if (_isDisposed || !mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Gagal memuat Short: $e';
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  void _togglePlay() {
    if (_controller == null) return;
    setState(() => _isPaused = !_isPaused);

    if (_isPaused) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(color: Colors.white),
          )
        else if (_error != null)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else if (_controller != null && _controller!.value.isInitialized)
          GestureDetector(
            onTap: _togglePlay,
            child: Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
            ),
          ),

        // Lapisan ikon play saat di-pause
        if (_isPaused)
          const Center(
            child: Icon(
              Icons.play_arrow,
              color: Colors.white70,
              size: 80,
            ),
          ),

        // Lapisan info judul, channel, dan tombol Subscribe di bagian bawah kiri
        Positioned(
          left: 14,
          right: 76, // Memberi ruang agar tidak menabrak barisan tombol aksi di sebelah kanan
          bottom: 48,
          child: IgnorePointer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.redAccent,
                      child: Text(
                        widget.video.channel.isNotEmpty
                            ? widget.video.channel[0]
                            : 'Y',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.video.channel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(color: Colors.black87, blurRadius: 4),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'Subscribe',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.video.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(color: Colors.black87, blurRadius: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Lapisan tombol aksi interaksi vertikal di sebelah kanan (Like, Dislike, Komen, Share, Remix, Sound)
        Positioned(
          right: 12,
          bottom: 48,
          child: _ShortActions(video: widget.video),
        ),
      ],
    );
  }
}

/// Kolom tombol aksi di sebelah kanan video Shorts (Like, Dislike, Comment, Share, Remix, Musik).
class _ShortActions extends StatelessWidget {
  const _ShortActions({required this.video});

  final Video video;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActionButton(
          icon: Icons.thumb_up,
          label: video.views.isNotEmpty ? video.views.split(' ')[0] : '124K',
        ),
        const SizedBox(height: 16),
        const _ActionButton(
          icon: Icons.thumb_down,
          label: 'Dislike',
        ),
        const SizedBox(height: 16),
        const _ActionButton(
          icon: Icons.comment,
          label: '1.2K',
        ),
        const SizedBox(height: 16),
        const _ActionButton(
          icon: Icons.share,
          label: 'Share',
        ),
        const SizedBox(height: 16),
        const _ActionButton(
          icon: Icons.sync,
          label: 'Remix',
        ),
        const SizedBox(height: 16),
        const _SoundAvatar(),
      ],
    );
  }
}

/// Tombol aksi tunggal di bilah kanan Shorts.
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {},
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            shadows: [
              Shadow(color: Colors.black87, blurRadius: 4),
            ],
          ),
        ),
      ],
    );
  }
}

/// Avatar kover suara/musik di pojok kanan bawah Shorts.
class _SoundAvatar extends StatelessWidget {
  const _SoundAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white38, width: 1.5),
      ),
      child: const Center(
        child: Icon(Icons.music_note, color: Colors.white, size: 20),
      ),
    );
  }
}
