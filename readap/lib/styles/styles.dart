import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles {
  static TextTheme textTheme = TextTheme(
    headlineLarge: GoogleFonts.nunito(
      textStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.normal, letterSpacing: -0.5),
    ),
    headlineMedium: GoogleFonts.nunito(
      textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.normal, letterSpacing: -0.5),
    ),
    headlineSmall: GoogleFonts.nunito(
      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, letterSpacing: -0.5),
    ),
    bodyLarge: GoogleFonts.nunito(
      textStyle: TextStyle(fontSize: 16, letterSpacing: -0.5),
    ),
    bodyMedium: GoogleFonts.nunito(
      textStyle: TextStyle(fontSize: 14, letterSpacing: -0.5),
    ),
  );

  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: Color(0xFF8D5EB2),
    padding: EdgeInsets.symmetric(vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    textStyle: GoogleFonts.nunito(
      textStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        letterSpacing: -0.5,
      ),
    ),
  );
}