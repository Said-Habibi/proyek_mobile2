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

  void _onItemTapped(int index) {
    if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fitur upload belum dibuat')),
      );
      return;
    }
    setState(() => _selectedIndex = index);
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return ShortsScreen(
          onBack: () => setState(() => _selectedIndex = 0),
        );
      case 2:
        return const SizedBox();
      case 3:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isShortsTab = _selectedIndex == 1;

    return Scaffold(
      // Sembunyikan AppBar saat berada di tab Shorts agar tampilan layar penuh
      appBar: isShortsTab
          ? null
          : AppBar(
              title: const YoutubeLogo(),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
              ],
            ),
      body: _buildBody(),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // Menghilangkan efek kilatan/kedipan menyebar yang melebar ke tab lain saat ditekan
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: isShortsTab ? Colors.black : Colors.white,
          selectedItemColor: isShortsTab ? Colors.white : Colors.black,
          unselectedItemColor: isShortsTab ? Colors.white60 : Colors.black87,
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
      ),
    );
  }
}
