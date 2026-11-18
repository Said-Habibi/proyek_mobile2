class Video {
  const Video({
    required this.id,
    required this.title,
    required this.channel,
    this.views = '',
    this.timeAgo = '',
    this.duration = '',
    this.thumbnailUrl = '',
    this.channelThumbnailUrl = '',
    this.description = '',
    this.videoUrl,
  });

  final String id;
  final String title;
  final String channel;
  final String views;
  final String timeAgo;
  final String duration;
  final String thumbnailUrl;
  final String channelThumbnailUrl;
  final String description;

  /// URL stream langsung (misal MP4/HLS dari server/database sendiri di masa depan).
  /// Jika bernilai null, pemutar akan mengambil stream secara dinamis dari YouTube Explode.
  final String? videoUrl;

  /// Thumbnail fallback: gunakan URL dari metadata, atau default YouTube jika ada ID.
  String get thumbnail {
    if (thumbnailUrl.isNotEmpty) return thumbnailUrl;
    if (id.isNotEmpty) return 'https://img.youtube.com/vi/$id/hqdefault.jpg';
    return '';
  }

  Video copyWith({
    String? id,
    String? title,
    String? channel,
    String? views,
    String? timeAgo,
    String? duration,
    String? thumbnailUrl,
    String? channelThumbnailUrl,
    String? description,
    String? videoUrl,
  }) {
    return Video(
      id: id ?? this.id,
      title: title ?? this.title,
      channel: channel ?? this.channel,
      views: views ?? this.views,
      timeAgo: timeAgo ?? this.timeAgo,
      duration: duration ?? this.duration,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      channelThumbnailUrl: channelThumbnailUrl ?? this.channelThumbnailUrl,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
    );
  }

  /// Mempermudah serialisasi saat menyimpan ke database / Local Storage / REST API.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'channel': channel,
      'views': views,
      'timeAgo': timeAgo,
      'duration': duration,
      'thumbnailUrl': thumbnailUrl,
      'channelThumbnailUrl': channelThumbnailUrl,
      'description': description,
      if (videoUrl != null) 'videoUrl': videoUrl,
    };
  }

  /// Mempermudah deserialisasi saat membaca data dari database / REST API nanti.
  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      channel: json['channel'] as String? ?? '',
      views: json['views'] as String? ?? '',
      timeAgo: json['timeAgo'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      channelThumbnailUrl: json['channelThumbnailUrl'] as String? ?? '',
      description: json['description'] as String? ?? '',
      videoUrl: json['videoUrl'] as String?,
    );
  }
}
