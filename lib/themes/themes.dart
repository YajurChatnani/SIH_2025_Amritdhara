import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Define core colors for easier management
  static const Color _lightPrimaryColor = Color(0xFF012A4A);
  static const Color _lightBackgroundColor = Color(0xFFF0F4F8);

  static const Color _darkPrimaryColor = Colors.white;
  static const Color _darkBackgroundColor = Color(0xFF011A29);

  // ### LIGHT THEME ###
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: _lightBackgroundColor,
    primaryColor: _lightPrimaryColor,
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: Colors.black87,
      displayColor: _lightPrimaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: _lightPrimaryColor),
    ),
  );

  // ### DARK THEME ###
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _darkBackgroundColor,
    primaryColor: _darkPrimaryColor,
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: Colors.white70,
      displayColor: _darkPrimaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: _darkPrimaryColor),
    ),
  );

  // ### DYNAMIC GRADIENTS ###
  static const LinearGradient lightGradient = LinearGradient(
    colors: [Color(0xFFD4EFFC), Color(0xFFB6D5E1), Colors.white],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF012A4A), Color(0xFF001A2D), Colors.black],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.5, 1.0],
  );
}