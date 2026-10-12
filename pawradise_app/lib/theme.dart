import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const cream = Color(0xFFFBF3DC);
  static const taupe = Color(0xFF4B4540);
  static const gold = Color(0xFFE5A823);
  static const sage = Color(0xFFA9A9A0);
  static const charcoal = Color(0xFF2B2B2B);
  static const brown = Color(0xFF8B6B4E);
  static const peach = Color(0xFFF6E7C8);
  static const line = Color(0xFFE6DCC0);
  static const loginBg = Color(0xFFC7C3B6);
  static const orange = Color(0xFFE8893A);
}

TextStyle headStyle([double size = 18, Color color = AppColors.charcoal]) =>
    GoogleFonts.montserrat(fontSize: size, fontWeight: FontWeight.w800, color: color);

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.gold),
    scaffoldBackgroundColor: AppColors.cream,
  );
  return base.copyWith(
    textTheme: GoogleFonts.quicksandTextTheme(base.textTheme)
        .apply(bodyColor: AppColors.charcoal, displayColor: AppColors.charcoal),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.cream,
      indicatorColor: AppColors.gold,
    ),
  );
}
