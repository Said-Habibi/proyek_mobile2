import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;
import '../models/video.dart';

/// Service untuk mengambil data video YouTube menggunakan youtube_explode_dart.
/// Semua metadata (judul, channel, views, durasi, thumbnail) didapatkan otomatis.
class YoutubeService {
  YoutubeService() : _yt = yt.YoutubeExplode();

  final yt.YoutubeExplode _yt;

  /// Ambil metadata satu video berdasarkan ID.
  Future<Video> getVideo(String videoId) async {
    final video = await _yt.videos.get(videoId);
    return _mapToVideo(video);
  }

  /// Ambil metadata banyak video sekaligus.
  Future<List<Video>> getVideos(List<String> videoIds) async {
    final futures = videoIds.map((id) => getVideo(id));
    return Future.wait(futures);
  }

  /// Dapatkan URL stream video (audio + video muxed) dari YouTube Explode.
  Future<String> getStreamUrl(String videoId) async {
    final manifest = await _yt.videos.streamsClient.getManifest(videoId);
    final muxedStreams = manifest.muxed;
    if (muxedStreams.isNotEmpty) {
      return muxedStreams.withHighestBitrate().url.toString();
    }
    return manifest.video.withHighestBitrate().url.toString();
  }

  /// Tutup client untuk membersihkan resource.
  void dispose() {
    _yt.close();
  }

  /// Konversi Video dari youtube_explode ke model Video kita.
  Video _mapToVideo(yt.Video video) {
    return Video(
      id: video.id.value,
      title: video.title,
      channel: video.author,
      views: _formatViews(video.engagement.viewCount),
      timeAgo: _formatTimeAgo(video.uploadDate ?? video.publishDate),
      duration: _formatDuration(video.duration),
      thumbnailUrl: video.thumbnails.highResUrl,
      description: video.description,
    );
  }

  /// Format jumlah views ke bentuk yang mudah dibaca.
  static String _formatViews(int? count) {
    if (count == null) return '';
    if (count >= 1000000000) {
      return '${(count / 1000000000).toStringAsFixed(1)}B views';
    }
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M views';
    }
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K views';
    }
    return '$count views';
  }

  /// Format durasi ke mm:ss atau hh:mm:ss.
  static String _formatDuration(Duration? duration) {
    if (duration == null) return '';
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString()}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Format tanggal upload ke "X hari/minggu/bulan lalu".
  static String _formatTimeAgo(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays >= 365) {
      final years = (diff.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
    if (diff.inDays >= 30) {
      final months = (diff.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    }
    if (diff.inDays >= 7) {
      final weeks = (diff.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    }
    if (diff.inDays > 0) {
      return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    }
    if (diff.inHours > 0) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    }
    return 'Just now';
  }
}
