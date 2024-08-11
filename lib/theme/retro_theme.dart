import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData createRetroBlackTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212), // Dark background

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF1E1E1E), // Deep black for primary elements
      onPrimary: Color(0xFFF2F2F2), // Light gray for contrast
      secondary: Color(0xFF404040), // Dark gray for secondary elements
      onSecondary: Color(0xFFD1D1D1),
      background: Color(0xFF121212),
      onBackground: Color(0xFFF2F2F2),
      surface: Color(0xFF1E1E1E),
      onSurface: Color(0xFFD1D1D1),
      error: Color(0xFFD32F2F),
      onError: Color(0xFFFFFFFF),
    ),

    textTheme: TextTheme(
      displayLarge: GoogleFonts.pressStart2p(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: const Color(0xFFF2F2F2),
      ),
      displayMedium: GoogleFonts.pressStart2p(
        fontSize: 24,
        color: const Color(0xFFF2F2F2),
      ),
      bodyLarge: GoogleFonts.pressStart2p(
        fontSize: 16,
        color: const Color(0xFFD1D1D1),
      ),
      bodyMedium: GoogleFonts.pressStart2p(
        fontSize: 14,
        color: const Color(0xFFF2F2F2),
      ),
      bodySmall: GoogleFonts.pressStart2p(
        fontSize: 10,
        color: const Color(0xFFF2F2F2),
      ),
      labelLarge: GoogleFonts.pressStart2p(
        fontSize: 12,
        color: const Color(0xFFF2F2F2),
      ),
      labelMedium: GoogleFonts.pressStart2p(
        fontSize: 8,
        color: const Color(0xFFF2F2F2),
      ),
      labelSmall: GoogleFonts.pressStart2p(
        fontSize: 6,
        color: const Color(0xFFF2F2F2),
      ),
    ),

    iconTheme: const IconThemeData(
      color: Color(0xFFF2F2F2),
      size: 24,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      titleTextStyle: GoogleFonts.pressStart2p(
        fontSize: 20,
        color: const Color(0xFFF2F2F2),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFFF2F2F2),
      ),
    ),

    buttonTheme: ButtonThemeData(
      buttonColor: const Color(0xFF404040), // Dark gray buttons
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Slight rounding for buttons
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: GoogleFonts.pressStart2p(
          fontSize: 14,
          letterSpacing: 3,
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 4,
        shape: const BeveledRectangleBorder(),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        side: const BorderSide(
            color: Colors.white,
            width: 4,
            style: BorderStyle.solid,
            strokeAlign: 2),
        enableFeedback: true,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF404040),
        textStyle: GoogleFonts.pressStart2p(
          fontSize: 14,
          color: const Color(0xFFF2F2F2),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 7,
      color: const Color(0xFF121212),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(8),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF404040),
      errorStyle: GoogleFonts.pressStart2p(
        fontSize: 7,
        letterSpacing: 3,
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
      suffixIconColor: Colors.white,
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFF2F2F2)),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFF2F2F2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFF2F2F2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFF2F2F2)),
      ),
      labelStyle: GoogleFonts.pressStart2p(
        fontSize: 14,
        color: const Color(0xFFD1D1D1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFF2F2F2)),
      ),
    ),
  );
}
