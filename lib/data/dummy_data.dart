import '../models/video.dart';

// Ganti ID di bawah dengan ID video YouTube yang asli.
// ID ada di link video: youtube.com/watch?v=<ID>
const _homeIds = ['dQw4w9WgXcQ', 'dQw4w9WgXcQ', 'dQw4w9WgXcQ'];
const _musicIds = ['dQw4w9WgXcQ', 'dQw4w9WgXcQ'];
const _subsIds = ['dQw4w9WgXcQ', 'dQw4w9WgXcQ'];
const _shortsIds = [
  'dQw4w9WgXcQ',
  'dQw4w9WgXcQ',
  'dQw4w9WgXcQ',
  'dQw4w9WgXcQ',
];

/// Mengubah daftar ID menjadi daftar Video.
/// Judul dan channel dibuat otomatis, contoh: "Home #1".
List<Video> _buildVideos(String section, List<String> ids) {
  final videos = <Video>[];

  for (var i = 0; i < ids.length; i++) {
    videos.add(
      Video(
        id: ids[i],
        title: '$section #${i + 1}',
        channel: 'Channel $section',
        views: '${(i + 1) * 12} rb x ditonton',
        timeAgo: '${i + 1} hari lalu',
        duration: '10:00',
      ),
    );
  }

  return videos;
}

final homeVideos = _buildVideos('Home', _homeIds);
final musicVideos = _buildVideos('Music', _musicIds);
final subsVideos = _buildVideos('Subs', _subsIds);
final shortsVideos = _buildVideos('Shorts', _shortsIds);
