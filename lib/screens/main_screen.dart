import 'package:flutter/material.dart';

import 'shorts_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 18,
              ),
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
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: [
          const HomeScreen(),
          // Shorts hanya dibuat saat tab-nya dibuka, supaya video tidak diputar di belakang layar.
          _index == 1 ? const ShortsScreen() : const SizedBox(),
          const SizedBox(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: (i) {
          if (i == 2) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fitur upload belum dibuat')),
            );
            return;
          }
          setState(() => _index = i);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outline),
            label: 'Shorts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, size: 30),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 13,
              backgroundColor: Colors.brown,
              child: Text(
                'M',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            label: 'You',
          ),
        ],
      ),
    );
  }
}
