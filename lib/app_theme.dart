import 'package:flutter/material.dart';

/// Token visual yang diambil langsung dari desain web Tasty Food.
class AppColors {
  AppColors._();

  static const ink = Color(0xff111111); // hitam header/footer/tombol
  static const surface = Color(0xffffffff);
  static const soft = Color(0xfff4f4f4); // section abu muda
  static const body = Color(0xff6b6b6b); // teks paragraf
  static const muted = Color(0xffaaaaaa); // teks di footer
  static const line = Color(0xffe4e4e4);
  static const accent = Color(0xffF2A93B); // "Baca selengkapnya"
}

class AppText {
  AppText._();

  static const display = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w900,
    letterSpacing: 1.2,
    height: 1.15,
    color: AppColors.ink,
  );

  static const section = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w900,
    letterSpacing: 1.1,
    color: AppColors.ink,
  );

  static const cardTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w900,
    letterSpacing: 0.8,
    color: AppColors.ink,
  );

  static const paragraph = TextStyle(
    fontSize: 13.5,
    height: 1.8,
    color: AppColors.body,
  );

  static const link = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
    color: AppColors.accent,
  );
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.surface,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      primary: AppColors.ink,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: AppColors.line),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.ink,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
          fontSize: 12.5,
        ),
        shape: const RoundedRectangleBorder(),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      hintStyle: const TextStyle(color: Color(0xff9a9a9a)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.ink),
      ),
    ),
  );
}
