import 'package:flutter/material.dart';

/// Gambar thumbnail dari internet.
///
/// Container abu-abu di belakang gambar terlihat selama gambar belum selesai
/// dimuat, atau kalau gagal dimuat.
/// Kalau [width] / [height] tidak diisi, gambar memenuhi ruang yang tersedia
/// (dipakai di dalam Stack pada kartu Shorts).
class Thumbnail extends StatelessWidget {
  const Thumbnail({
    super.key,
    required this.url,
    this.width = double.infinity,
    this.height = double.infinity,
  });

  final String url;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade300,
      child: Image.network(url, fit: BoxFit.cover),
    );
  }
}
