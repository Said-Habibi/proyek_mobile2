import 'package:flutter/material.dart';
import 'package:proyek_mobile2/data/dummy_data.dart';

import '../models/video.dart';
import '../screens/player_screen.dart';
import '../screens/shorts_screen.dart';

void openPlayer(BuildContext context, Video video) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => PlayerScreen(video: video)),
  );
}

/// Thumbnail dengan fallback abu-abu jika gagal dimuat.
class Thumbnail extends StatelessWidget {
  const Thumbnail({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300),
    );
  }
}

/// Kartu video horizontal (dipakai di Home, Subs, Music).
class VideoCard extends StatelessWidget {
  const VideoCard({super.key, required this.video});
  final Video video;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openPlayer(context, video),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Thumbnail(url: video.thumbnail),
              ),
              if (video.duration.isNotEmpty)
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    color: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: Text(
                      video.duration,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
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
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// card iklan nggak wajib ada kayaknya
// class SponsoredCard extends StatelessWidget {
//   const SponsoredCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         AspectRatio(
//           aspectRatio: 16 / 9,
//           child: Container(
//             color: Colors.blueGrey.shade100,
//             alignment: Alignment.center,
//             child: const Text('Iklan', style: TextStyle(fontSize: 20)),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Judul iklan sponsor',
//                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 'Sponsored • Nama Brand',
//                 style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () {},
//                       child: const Text('Watch'),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.black,
//                         foregroundColor: Colors.white,
//                       ),
//                       onPressed: () {},
//                       child: const Text('Sign up'),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

/// Rak Shorts: header dan grid 2 kolom.
class ShortsShelf extends StatelessWidget {
  const ShortsShelf({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Icon(Icons.play_arrow_rounded, color: Colors.red, size: 28),
              SizedBox(width: 6),
              Text(
                'Shorts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.65,
          children: [
            for (var i = 0; i < shortsVideos.length; i++)
              ShortCard(video: shortsVideos[i], index: i),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class ShortCard extends StatelessWidget {
  const ShortCard({super.key, required this.video, required this.index});
  final Video video;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ShortsScreen(initialIndex: index)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Thumbnail(url: video.thumbnail),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
            ),
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Text(
                video.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
