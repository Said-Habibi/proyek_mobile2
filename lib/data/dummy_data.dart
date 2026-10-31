import '../models/video.dart';
import 'video_ids.dart';

/// Mengubah daftar ID menjadi daftar Video.
/// Judul dan channel dibuat otomatis, contoh: "Home #1".
List<Video> _buildVideos(List<String> ids, String section) {
  return [
    for (var i = 0; i < ids.length; i++)
      Video(
        id: ids[i],
        title: '$section #${i + 1}',
        channel: 'Channel $section',
        views: '${(i + 1) * 12} rb x ditonton',
        timeAgo: '${i + 1} hari lalu',
        duration: '10:00',
      ),
  ];
}

final homeVideos = _buildVideos(homeVideoIds, 'Home');
final musicVideos = _buildVideos(musicVideoIds, 'Music');
final subsVideos = _buildVideos(subsVideoIds, 'Subs');
final shortsVideos = _buildVideos(shortsVideoIds, 'Shorts');
