import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../widgets/shorts_shelf.dart';
import '../widgets/sponsored_card.dart';
import '../widgets/video_card.dart';

const _channelNames = ['Tech Channel', 'Sport Daily', 'Music Hub'];

/// Halaman Home: TabBar di atas, isi tiap tab di bawahnya.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // harus sama dengan jumlah Tab dan jumlah isi TabBarView
      child: Column(
        children: const [
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.red,
            indicatorWeight: 3,
            dividerColor: Colors.transparent,
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Subs'),
              Tab(text: 'Music'),
              Tab(text: 'Live'),
              Tab(text: 'More'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _HomeFeed(),
                _SubsFeed(),
                _MusicFeed(),
                _LiveEmpty(),
                _MoreMenu(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tab Home: iklan, satu video, rak Shorts, lalu sisa video.
class _HomeFeed extends StatelessWidget {
  const _HomeFeed();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SponsoredCard(),
        VideoCard(video: homeVideos[0]),
        const ShortsShelf(),
        // Sisa video setelah rak Shorts (mulai dari urutan ke-1).
        for (var i = 1; i < homeVideos.length; i++)
          VideoCard(video: homeVideos[i]),
      ],
    );
  }
}

/// Tab Subs: daftar channel (geser ke samping), lalu video.
class _SubsFeed extends StatelessWidget {
  const _SubsFeed();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 130,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            children: [
              for (final name in _channelNames) _ChannelAvatar(name: name),
            ],
          ),
        ),
        for (final video in subsVideos) VideoCard(video: video),
      ],
    );
  }
}

class _ChannelAvatar extends StatelessWidget {
  const _ChannelAvatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 32, child: Text(name[0])),
          const SizedBox(height: 6),
          SizedBox(
            width: 72,
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tab Music.
class _MusicFeed extends StatelessWidget {
  const _MusicFeed();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [for (final video in musicVideos) VideoCard(video: video)],
    );
  }
}

/// Tab Live (kosong).
class _LiveEmpty extends StatelessWidget {
  const _LiveEmpty();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'There are no live streams available',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

/// Tab More: daftar menu.
class _MoreMenu extends StatelessWidget {
  const _MoreMenu();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(leading: Icon(Icons.movie_outlined), title: Text('Films')),
        ListTile(
          leading: Icon(Icons.sports_esports_outlined),
          title: Text('Gaming'),
        ),
        ListTile(leading: Icon(Icons.star_border), title: Text('Memberships')),
        Divider(),
        ListTile(
          leading: Icon(Icons.play_circle_fill, color: Colors.red),
          title: Text('YouTube Premium'),
        ),
        ListTile(
          leading: Icon(Icons.play_circle_outline),
          title: Text('YouTube Music'),
        ),
        ListTile(leading: Icon(Icons.child_care), title: Text('YouTube Kids')),
        ListTile(
          leading: Icon(Icons.movie_creation_outlined),
          title: Text('YouTube Create'),
        ),
      ],
    );
  }
}
