import 'package:flutter/material.dart';
import 'trevor_colors.dart';

/// Central theme for the Trevor app.
///
/// Uses large touch targets, rounded corners, and friendly typography
/// appropriate for young children (ages 2–6).
abstract final class TrevorTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: TrevorColors.coral,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: TrevorColors.roomBg,
        fontFamily: 'Fredoka',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: TrevorColors.textDark,
            letterSpacing: 0.5,
          ),
          headlineMedium: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: TrevorColors.textDark,
          ),
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: TrevorColors.textDark,
          ),
          bodyLarge: TextStyle(
            fontSize: 20,
            color: TrevorColors.textDark,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(80, 80),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
}
