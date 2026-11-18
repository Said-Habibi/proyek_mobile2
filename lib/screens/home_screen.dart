import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../models/video.dart';
import '../widgets/shorts_shelf.dart';
import '../widgets/video_card.dart';

const _channelNames = ['Tech Channel', 'Sport Daily', 'Music Hub'];

/// Halaman Home: TabBar di atas, isi tiap tab di bawahnya.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
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

/// Widget helper: menampilkan loading, error, atau data.
class _AsyncVideoList extends StatelessWidget {
  const _AsyncVideoList({
    required this.future,
    required this.builder,
  });

  final Future<List<Video>> future;
  final Widget Function(List<Video> videos) builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Video>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Failed to load videos\n${snapshot.error}',
              textAlign: TextAlign.center,
            ),
          );
        }
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: builder(snapshot.data ?? []),
          ),
        );
      },
    );
  }
}

/// Tab Home: satu video, rak Shorts, lalu sisa video.
class _HomeFeed extends StatelessWidget {
  const _HomeFeed();

  @override
  Widget build(BuildContext context) {
    return _AsyncVideoList(
      future: getHomeVideos(),
      builder: (videos) {
        if (videos.isEmpty) {
          return const Center(child: Text('No videos available'));
        }
        return ListView(
          children: [
            VideoCard(video: videos[0]),
            const ShortsShelf(),
            for (var i = 1; i < videos.length; i++)
              VideoCard(video: videos[i]),
          ],
        );
      },
    );
  }
}

/// Tab Subs: daftar channel (geser ke samping), lalu video.
class _SubsFeed extends StatelessWidget {
  const _SubsFeed();

  @override
  Widget build(BuildContext context) {
    return _AsyncVideoList(
      future: getSubsVideos(),
      builder: (videos) {
        return ListView(
          children: [
            SizedBox(
              height: 130,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                children: [
                  for (final name in _channelNames)
                    _ChannelAvatar(name: name),
                ],
              ),
            ),
            for (final video in videos) VideoCard(video: video),
          ],
        );
      },
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
    return _AsyncVideoList(
      future: getMusicVideos(),
      builder: (videos) {
        return ListView(
          children: [for (final video in videos) VideoCard(video: video)],
        );
      },
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
