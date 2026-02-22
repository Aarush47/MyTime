// Main Entry Point
// Clean, dark, minimal clock app with tabs

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  runApp(
    const ProviderScope(
      child: MyClockApp(),
    ),
  );
}

class MyClockApp extends StatelessWidget {
  const MyClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0a0a0a),
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Color(0xFF333333),
          surface: Color(0xFF1a1a1a),
          background: Color(0xFF0a0a0a),
        ),
        textTheme: GoogleFonts.openSansTextTheme(
          ThemeData.dark().textTheme,
        ).copyWith(
          displayLarge: GoogleFonts.openSans(
            fontSize: 96,
            fontWeight: FontWeight.w300,
            color: Colors.white,
            letterSpacing: -2,
          ),
          bodyLarge: GoogleFonts.openSans(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
