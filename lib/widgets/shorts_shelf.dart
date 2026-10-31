import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../models/video.dart';
import '../screens/shorts_screen.dart';
import 'thumbnail.dart';

/// Rak Shorts di halaman Home: judul "Shorts" dan grid 2 kolom.
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
          // shrinkWrap + NeverScrollableScrollPhysics: grid tidak scroll sendiri,
          // tingginya mengikuti isinya, dan ikut di-scroll oleh ListView induknya.
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.65,
          children: [
            for (var i = 0; i < shortsVideos.length; i++)
              _ShortCard(video: shortsVideos[i], index: i),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Satu kotak Short. Kalau ditekan, membuka ShortsScreen di urutan ke-[index].
class _ShortCard extends StatelessWidget {
  const _ShortCard({required this.video, required this.index});

  final Video video;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShortsScreen(initialIndex: index),
          ),
        );
      },
      // ClipRRect memotong isi kotak mengikuti sudut yang membulat.
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Thumbnail(url: video.thumbnail),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.all(8),
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
            ),
          ],
        ),
      ),
    );
  }
}
