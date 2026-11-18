import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../data/dummy_data.dart';
import '../models/video.dart';
import '../widgets/video_card.dart';

void openPlayer(BuildContext context, Video video, {bool replace = false}) {
  final route = MaterialPageRoute(builder: (context) => PlayerScreen(video: video));
  if (replace) {
    Navigator.pushReplacement(context, route);
  } else {
    Navigator.push(context, route);
  }
}

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key, required this.video});

  final Video video;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late Video _currentVideo;
  VideoPlayerController? _controller;
  bool _isLoading = true;
  String? _error;
  bool _showControls = true;
  bool _isDisposed = false;
  final ScrollController _scrollController = ScrollController();
  late final Future<List<Video>> _recommendationsFuture;

  @override
  void initState() {
    super.initState();
    _currentVideo = widget.video;
    _recommendationsFuture = getHomeVideos();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    final targetVideoId = _currentVideo.id;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final streamUrl = await youtubeService.getStreamUrl(targetVideoId);
      if (_isDisposed || !mounted || _currentVideo.id != targetVideoId) return;

      final controller = VideoPlayerController.networkUrl(Uri.parse(streamUrl));
      await controller.initialize();

      if (_isDisposed || !mounted || _currentVideo.id != targetVideoId) {
        controller.dispose();
        return;
      }

      controller.play();

      controller.addListener(() {
        if (mounted && !_isDisposed && _currentVideo.id == targetVideoId) {
          setState(() {});
        }
      });

      if (mounted && !_isDisposed && _currentVideo.id == targetVideoId) {
        // Dispose controller lama jika ada sebelum memasang yang baru
        _controller?.pause();
        _controller?.dispose();
        setState(() {
          _controller = controller;
          _isLoading = false;
        });
      } else {
        controller.dispose();
      }
    } catch (e) {
      if (_isDisposed || !mounted || _currentVideo.id != targetVideoId) return;
      setState(() {
        _isLoading = false;
        _error = 'Gagal memuat video: $e';
      });
    }
  }

  void _changeVideo(Video newVideo) {
    if (_currentVideo.id == newVideo.id) return;

    // Hentikan dan dispose video sebelumnya agar tidak lanjut memutar di latar belakang
    _controller?.pause();
    _controller?.dispose();
    _controller = null;

    setState(() {
      _currentVideo = newVideo;
      _isLoading = true;
      _error = null;
      _showControls = true;
    });

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    _initializePlayer();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
    _scrollController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    final hours = duration.inHours;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Area Video Player yang fleksibel (selalu menjaga aspek rasio 16:9 saat resize)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _buildPlayerArea(),
            ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: _VideoDetails(
                    video: _currentVideo,
                    recommendationsFuture: _recommendationsFuture,
                    scrollController: _scrollController,
                    onSelectVideo: _changeVideo,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerArea() {
    if (_isLoading) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.red),
        ),
      );
    }

    if (_error != null) {
      return Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 40),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _initializePlayer,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return Container(color: Colors.black);
    }

    final isPlaying = _controller!.value.isPlaying;
    final position = _controller!.value.position;
    final duration = _controller!.value.duration;

    return GestureDetector(
      onTap: () {
        setState(() {
          _showControls = !_showControls;
        });
      },
      child: Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio > 0
                    ? _controller!.value.aspectRatio
                    : 16 / 9,
                child: VideoPlayer(_controller!),
              ),
            ),
            // Lapisan Kontrol Player
            if (_showControls) ...[
              Container(color: Colors.black38),
              Positioned(
                top: 8,
                left: 8,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              IconButton(
                iconSize: 56,
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    if (isPlaying) {
                      _controller!.pause();
                    } else {
                      _controller!.play();
                    }
                  });
                },
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(position),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          _formatDuration(duration),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    VideoProgressIndicator(
                      _controller!,
                      allowScrubbing: true,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      colors: const VideoProgressColors(
                        playedColor: Colors.red,
                        bufferedColor: Colors.white38,
                        backgroundColor: Colors.white24,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Bagian di bawah pemutar: judul, deskripsi, channel, tombol aksi, dan video rekomendasi.
class _VideoDetails extends StatelessWidget {
  const _VideoDetails({
    required this.video,
    required this.recommendationsFuture,
    this.scrollController,
    this.onSelectVideo,
  });

  final Video video;
  final Future<List<Video>> recommendationsFuture;
  final ScrollController? scrollController;
  final ValueChanged<Video>? onSelectVideo;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Video>>(
      future: recommendationsFuture,
      builder: (context, snapshot) {
        final otherVideos = snapshot.data ?? [];
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(12),
          children: [
            Text(
              video.title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${video.views} • ${video.timeAgo}',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            if (video.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                video.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ],
            const SizedBox(height: 12),
            _ChannelActionRow(channelName: video.channel),
            const SizedBox(height: 12),
            const _CommentPreview(),
            const SizedBox(height: 12),
            for (final other in otherVideos)
              if (other.id != video.id)
                VideoCard(
                  video: other,
                  onTap: onSelectVideo != null ? () => onSelectVideo!(other) : null,
                ),
          ],
        );
      },
    );
  }
}

class _ChannelActionRow extends StatelessWidget {
  const _ChannelActionRow({
    this.channelName = '',
  });

  final String channelName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: Container(
            width: 36,
            height: 36,
            color: const Color(0xFFFFDAD6),
            child: Center(
              child: Text(
                channelName.isNotEmpty ? channelName[0] : '?',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            channelName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Text(
            'Subscribe',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _IconAction(icon: Icons.thumb_up_outlined),
            _IconAction(icon: Icons.thumb_down_outlined),
            _IconAction(icon: Icons.share_outlined),
            _IconAction(icon: Icons.more_vert),
          ],
        ),
      ],
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Icon(icon, size: 24, color: Colors.black87),
    );
  }
}

class _CommentPreview extends StatelessWidget {
  const _CommentPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'Comments',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 6),
              Text('3k',
                  style: TextStyle(fontSize: 13, color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Color(0xFFD9D9D9),
                foregroundImage: NetworkImage(
                  'https://i.pinimg.com/736x/9a/c2/1a/9ac21a91b1c943bdd6af511c3f9dafc6.jpg',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Video yang bagus sekarang mana lapangan pekerjaannya.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
