import 'package:flutter/material.dart';

import '../widgets/youtube_logo.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'shorts_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Halaman untuk tiap menu di bottom navigation bar (urutannya sama dengan tombolnya).
  // Index 2 (Create) tidak punya halaman: tombolnya hanya memunculkan SnackBar,
  // jadi SizedBox kosong ini tidak pernah tampil.
  final List<Widget> _pages = const [
    HomeScreen(),
    ShortsScreen(),
    SizedBox(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fitur upload belum dibuat')),
      );
      return;
    }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const YoutubeLogo(),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      // Hanya halaman yang dipilih yang dibuat. Saat pindah tab, halaman lama dibuang,
      // jadi video Shorts otomatis berhenti.
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
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
