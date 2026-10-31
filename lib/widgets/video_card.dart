import 'package:flutter/material.dart';

import '../models/video.dart';
import '../screens/player_screen.dart';
import 'thumbnail.dart';

/// Kartu video (dipakai di Home, Subs, Music, dan rekomendasi di PlayerScreen).
/// Kalau ditekan, membuka PlayerScreen.
class VideoCard extends StatelessWidget {
  const VideoCard({super.key, required this.video});

  final Video video;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // opaque: seluruh kartu bisa ditekan, termasuk bagian yang kosong.
      behavior: HitTestBehavior.opaque,
      onTap: () => openPlayer(context, video),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ThumbnailWithDuration(video: video),
          _VideoInfo(video: video),
        ],
      ),
    );
  }
}

/// Thumbnail dengan label durasi di pojok kanan bawah.
class _ThumbnailWithDuration extends StatelessWidget {
  const _ThumbnailWithDuration({required this.video});

  final Video video;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Thumbnail(url: video.thumbnail, height: 200),
        if (video.duration.isNotEmpty)
          Positioned(
            right: 8,
            bottom: 8,
            child: Container(
              color: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                video.duration,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }
}

/// Baris di bawah thumbnail: avatar channel, judul, dan keterangan.
class _VideoInfo extends StatelessWidget {
  const _VideoInfo({required this.video});

  final Video video;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 4, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 18, child: Text(video.channel[0])),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${video.channel} • ${video.views} • ${video.timeAgo}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert, size: 20),
        ],
      ),
    );
  }
}
