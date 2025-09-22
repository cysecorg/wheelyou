import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart'; // <-- Add this import
// Uncomment the next line to use Google Fonts
// import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wheelyou',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D1B2A), // Dark navy background

        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1E88E5),    // Deep Blue
          secondary: Color(0xFF42A5F5),  // Lighter Blue
        ),

        // To use Google Fonts:
        // fontFamily: GoogleFonts.poppins().fontFamily,
        fontFamily: 'Roboto',

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF152238),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1E88E5), width: 1.5),
          ),
          labelStyle: TextStyle(color: Colors.blue[200]),
          hintStyle: TextStyle(color: Colors.blue[100]),
        ),

        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 14),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E88E5),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue[300],
            textStyle: const TextStyle(fontSize: 14),
          ),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D1B2A),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        cardTheme: CardThemeData(
          color: const Color(0xFF152238),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
      // Change this line:
      // home: LoginScreen(),
      home: SplashScreen(), // <-- Start with your splash screen first
    );
  }
}
