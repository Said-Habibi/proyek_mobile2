import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../data/dummy_data.dart';
import '../models/video.dart';
import '../widgets/video_card.dart';

/// Membuka halaman pemutar untuk [video].
void openPlayer(BuildContext context, Video video) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PlayerScreen(video: video)),
  );
}

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key, required this.video});

  final Video video;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.id,
      flags: YoutubePlayerFlags(autoPlay: true),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // YoutubePlayerBuilder dibutuhkan agar tombol fullscreen berfungsi.
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
                player,
                Expanded(child: _VideoDetails(video: widget.video)),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Bagian di bawah pemutar: judul, tombol aksi, channel, dan video lain.
class _VideoDetails extends StatelessWidget {
  const _VideoDetails({required this.video});

  final Video video;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text(
          video.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '${video.views} • ${video.timeAgo}',
          style: TextStyle(color: Colors.grey.shade700),
        ),
        const SizedBox(height: 12),
        const _ActionButtons(),
        const Divider(height: 28),
        _ChannelRow(video: video),
        const Divider(height: 28),
        // Video lain (selain yang sedang diputar).
        for (final other in homeVideos)
          if (other != video) VideoCard(video: other),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _ActionButton(icon: Icons.thumb_up_alt_outlined, label: 'Suka'),
          _ActionButton(icon: Icons.comment_outlined, label: 'Komentar'),
          _ActionButton(icon: Icons.share_outlined, label: 'Bagikan'),
          _ActionButton(icon: Icons.playlist_add, label: 'Simpan'),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 18),
        label: Text(label),
      ),
    );
  }
}

class _ChannelRow extends StatelessWidget {
  const _ChannelRow({required this.video});

  final Video video;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(child: Text(video.channel[0])),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            video.channel,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          onPressed: () {},
          child: const Text('Subscribe'),
        ),
      ],
    );
  }
}
