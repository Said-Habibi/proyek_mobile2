import '../models/video.dart';
import '../services/youtube_service.dart';

// ID video YouTube yang akan di-fetch metadata-nya secara otomatis.
const _homeIds = ['32nR048EMI0', '_c2e1NcI3Sc', 'tBTprs6p5fM'];
const _musicIds = ['IfywPnUKsXg', 'T7BeOPQ7oyw', 'lGeUFHtlzDE'];
const _subsIds = ['TKtcdHUrSmg', 'T7w74bbFo5E'];
const _shortsIds = ['HBBkAIcuh2Y', 'Sqpbh-etDY4', 'De3HWvF7648', '_lOAg7vUTyw'];

/// Service global yang bisa digunakan di seluruh app.
final youtubeService = YoutubeService();

/// Cache untuk video yang sudah di-fetch.
List<Video>? _cachedHomeVideos;
List<Video>? _cachedMusicVideos;
List<Video>? _cachedSubsVideos;
List<Video>? _cachedShortsVideos;

/// Fallback: jika fetch gagal, gunakan data placeholder.
List<Video> _buildFallbackVideos(String section, List<String> ids) {
  final videos = <Video>[];
  for (var i = 0; i < ids.length; i++) {
    videos.add(
      Video(
        id: ids[i],
        title: '$section #${i + 1}',
        channel: 'Channel $section',
        views: '${(i + 1) * 12}K views',
        timeAgo: '${i + 1} days ago',
        duration: '10:00',
      ),
    );
  }
  return videos;
}

/// Fetch video dari YouTube dengan metadata otomatis.
/// Kalau gagal (misalnya tidak ada internet), pakai data fallback.
Future<List<Video>> _fetchVideos(String section, List<String> ids) async {
  try {
    return await youtubeService.getVideos(ids);
  } catch (_) {
    return _buildFallbackVideos(section, ids);
  }
}

/// Getter async untuk tiap kategori video.
Future<List<Video>> getHomeVideos() async {
  _cachedHomeVideos ??= await _fetchVideos('Home', _homeIds);
  return _cachedHomeVideos!;
}

Future<List<Video>> getMusicVideos() async {
  _cachedMusicVideos ??= await _fetchVideos('Music', _musicIds);
  return _cachedMusicVideos!;
}

Future<List<Video>> getSubsVideos() async {
  _cachedSubsVideos ??= await _fetchVideos('Subs', _subsIds);
  return _cachedSubsVideos!;
}

Future<List<Video>> getShortsVideos() async {
  _cachedShortsVideos ??= await _fetchVideos('Shorts', _shortsIds);
  return _cachedShortsVideos!;
}

/// Bersihkan cache (misalnya untuk refresh).
void clearVideoCache() {
  _cachedHomeVideos = null;
  _cachedMusicVideos = null;
  _cachedSubsVideos = null;
  _cachedShortsVideos = null;
}
