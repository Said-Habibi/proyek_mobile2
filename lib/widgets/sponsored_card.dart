import 'package:flutter/material.dart';

/// Kartu iklan (hanya tampilan, belum ada isinya).
class SponsoredCard extends StatelessWidget {
  const SponsoredCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 200,
          color: Colors.blueGrey.shade100,
          alignment: Alignment.center,
          child: const Text('Iklan', style: TextStyle(fontSize: 20)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Judul iklan sponsor',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                'Sponsored • Nama Brand',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Watch'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: const Text('Sign up'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
