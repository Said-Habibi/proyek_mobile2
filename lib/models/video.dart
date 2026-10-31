class Video {
  const Video({
    required this.id,
    required this.title,
    required this.channel,
    this.views = '',
    this.timeAgo = '',
    this.duration = '',
  });

  final String id; // ID video YouTube, contoh: dQw4w9WgXcQ
  final String title;
  final String channel;
  final String views;
  final String timeAgo;
  final String duration;

  String get thumbnail => 'https://img.youtube.com/vi/$id/hqdefault.jpg';
}
