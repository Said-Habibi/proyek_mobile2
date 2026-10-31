import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../widgets/thumbnail.dart';
import 'player_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _ProfileHeader(),
        SizedBox(height: 16),
        _ProfileButtons(),
        SizedBox(height: 24),
        _SectionTitle('History'),
        SizedBox(height: 12),
        _HistoryList(),
        SizedBox(height: 24),
        _SectionTitle('Library'),
        ListTile(
          leading: Icon(Icons.schedule),
          title: Text('Watch later'),
          subtitle: Text('Private'),
        ),
        ListTile(
          leading: Icon(Icons.thumb_up_alt_outlined),
          title: Text('Liked videos'),
          subtitle: Text('Private'),
        ),
        ListTile(
          leading: Icon(Icons.download_outlined),
          title: Text('Downloads'),
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: Colors.brown,
          child: Text('M', style: TextStyle(fontSize: 30, color: Colors.white)),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Text(
            'M pokoknya M',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _ProfileButtons extends StatelessWidget {
  const _ProfileButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

/// Judul bagian, contoh: "History" dan "Library".
class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}

/// Daftar video riwayat yang bisa digeser ke samping.
class _HistoryList extends StatelessWidget {
  const _HistoryList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: homeVideos.length,
        itemBuilder: (context, index) {
          final video = homeVideos[index];

          return GestureDetector(
            onTap: () => openPlayer(context, video),
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SizedBox(
                width: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Thumbnail(url: video.thumbnail, width: 160, height: 90),
                    const SizedBox(height: 6),
                    Text(
                      video.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
