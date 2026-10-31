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
        const _ChannelActionRow(),
        const SizedBox(height: 12),
        const _CommentPreview(),
        const SizedBox(height: 12),
        for (final other in homeVideos)
          if (other != video) VideoCard(video: other),
      ],
    );
  }
}

// Ganti URL ini dengan link gambar kamu.
// const String kChannelAvatarUrl =
//     'https://i.pinimg.com/736x/1b/d6/f4/1bd6f46b92b38097840441fbc08ae824.jpg';
// const String kSubscribeButtonUrl = 'https://example.com/subscribe.png';

class _ChannelActionRow extends StatelessWidget {
  const _ChannelActionRow({
    this.avatarUrl = 'https://i.pinimg.com/736x/1b/d6/f4/1bd6f46b92b38097840441fbc08ae824.jpg',
  });

  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: Image.network(
            avatarUrl,
            width: 36,
            height: 36,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 36,
              height: 36,
              color: const Color(0xFFFFDAD6),
            ),
          ),
        ),
        const SizedBox(width: 10),
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
        const Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _IconAction(icon: Icons.thumb_up_outlined),
              _IconAction(icon: Icons.thumb_down_outlined),
              _IconAction(icon: Icons.share_outlined),
              _IconAction(icon: Icons.auto_awesome_outlined),
              _IconAction(icon: Icons.more_vert),
            ],
          ),
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

// class _SubscribeButton extends StatelessWidget {
//   const _SubscribeButton({required this.url});

//   final String url;

//   @override
//   Widget build(BuildContext context) {
//     return Image.network(
//       url,
//       height: 36,
//       fit: BoxFit.contain,
//       loadingBuilder: (context, child, progress) =>
//           progress == null ? child : _fallback(),
//       errorBuilder: (context, error, stackTrace) => _fallback(),
//     );
//   }

//   Widget _fallback() {
//     return Container(
//       height: 36,
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: const Text(
//         'Subscribe',
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
// }

class _CommentPreview extends StatelessWidget {
  const _CommentPreview();

  @override
  Widget build(BuildContext context) {
    // Tidak memakai InkWell/GestureDetector, jadi kartu ini tidak bisa dibuka.
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
              Text('3k', style: TextStyle(fontSize: 13, color: Colors.black54)),
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
