import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../data/dummy_data.dart';
import '../models/video.dart';
import '../widgets/video_widgets.dart';

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
    final video = widget.video;

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
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      Text(
                        video.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${video.views} • ${video.timeAgo}',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 12),
                      const SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _ActionButton(
                              icon: Icons.thumb_up_alt_outlined,
                              label: 'Suka',
                            ),
                            _ActionButton(
                              icon: Icons.comment_outlined,
                              label: 'Komentar',
                            ),
                            _ActionButton(
                              icon: Icons.share_outlined,
                              label: 'Bagikan',
                            ),
                            _ActionButton(
                              icon: Icons.playlist_add,
                              label: 'Simpan',
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 28),
                      Row(
                        children: [
                          CircleAvatar(child: Text(video.channel[0])),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              video.channel,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
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
                      ),
                      const Divider(height: 28),
                      for (final v in homeVideos.where((v) => v != video))
                        VideoCard(video: v),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
