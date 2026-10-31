import 'package:flutter/material.dart';

/// Logo + tulisan "YouTube" di AppBar.
class YoutubeLogo extends StatelessWidget {
  const YoutubeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 22,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(Icons.play_arrow, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 4),
        const Text(
          'YouTube',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
