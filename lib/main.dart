import 'package:flutter/material.dart';
import 'package:fvp/fvp.dart' as fvp;

import 'screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  fvp.registerWith();
  runApp(const YoutubeUiApp());
}

class YoutubeUiApp extends StatelessWidget {
  const YoutubeUiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: const MainScreen(),
    );
  }
}
