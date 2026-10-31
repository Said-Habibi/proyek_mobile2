import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../widgets/video_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
          const TabBar(
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
              children: const [
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

class _HomeFeed extends StatelessWidget {
  const _HomeFeed();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SponsoredCard(),
        VideoCard(video: homeVideos[0]),
        const ShortsShelf(),
        for (final v in homeVideos.skip(1)) VideoCard(video: v),
      ],
    );
  }
}

class _SubsFeed extends StatelessWidget {
  const _SubsFeed();

  @override
  Widget build(BuildContext context) {
    const channels = ['Tech Channel', 'Sport Daily', 'Music Hub'];

    return ListView(
      children: [
        SizedBox(
          height: 130,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            children: [
              for (final c in channels)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(radius: 32, child: Text(c[0])),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 72,
                        child: Text(
                          c,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        for (final v in subsVideos) VideoCard(video: v),
      ],
    );
  }
}

class _MusicFeed extends StatelessWidget {
  const _MusicFeed();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [for (final v in musicVideos) VideoCard(video: v)],
    );
  }
}

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
