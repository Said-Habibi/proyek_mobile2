import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../widgets/video_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: Colors.brown,
              child: Text(
                'M',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                'Nama Kamu',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {},
                child: const Text('Create a channel'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('Get Premium'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'History',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: homeVideos.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final v = homeVideos[i];
              return InkWell(
                onTap: () => openPlayer(context, v),
                child: SizedBox(
                  width: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Thumbnail(url: v.thumbnail),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        v.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Library',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const ListTile(
          leading: Icon(Icons.schedule),
          title: Text('Watch later'),
          subtitle: Text('Private'),
        ),
        const ListTile(
          leading: Icon(Icons.thumb_up_alt_outlined),
          title: Text('Liked videos'),
          subtitle: Text('Private'),
        ),
        const ListTile(
          leading: Icon(Icons.download_outlined),
          title: Text('Downloads'),
        ),
      ],
    );
  }
}
