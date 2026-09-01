import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResumeTheme {
  final bool isDark;

  ResumeTheme({required this.isDark});

  // Background Colors
  Color get backgroundColor => isDark ? const Color(0xFF050505) : const Color(0xFFFBFBFA);
  Color get surfaceColor => isDark ? const Color(0xFF111111) : const Color(0xFFFFFFFF);
  Color get shellColor => isDark ? const Color(0xFF161616) : const Color(0xFFF3F3F1);

  // Text Colors
  Color get textPrimary => isDark ? const Color(0xFFEDEDED) : const Color(0xFF1A1A1A);
  Color get textSecondary => isDark ? const Color(0xFF8F8F8F) : const Color(0xFF666666);
  Color get textMuted => isDark ? const Color(0xFF555555) : const Color(0xFF9E9D99);

  // Accent Colors
  Color get accentColor => isDark ? const Color(0xFF86A397) : const Color(0xFF3E4F47); // Muted Sage
  Color get accentLight => isDark ? const Color(0xFF1E2E27) : const Color(0xFFEFF5F2);
  Color get accentText => isDark ? const Color(0xFFAEC4BA) : const Color(0xFF2C3B34);

  Color get secondaryAccent => isDark ? const Color(0xFFE2A075) : const Color(0xFF8C4C23); // Warm Terracotta
  Color get secondaryAccentLight => isDark ? const Color(0xFF2E1F16) : const Color(0xFFFDF4EE);

  // Borders & Shadows
  Color get borderColor => isDark ? const Color(0xFF222222) : const Color(0xFFEAEAEA);
  Color get innerHighlightColor => isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F4);
  
  List<BoxShadow> get cardShadow => isDark
      ? [const BoxShadow(color: Colors.transparent, blurRadius: 0)]
      : [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.02),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.01),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ];

  // Fonts
  TextStyle get h1 => GoogleFonts.instrumentSerif(
        fontSize: 54,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.05,
        letterSpacing: -0.02,
      );

  TextStyle get h2 => GoogleFonts.instrumentSerif(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.1,
        letterSpacing: -0.01,
      );

  TextStyle get h3 => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: -0.01,
      );

  TextStyle get body => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.6,
      );

  TextStyle get bodySecondary => GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.5,
      );

  TextStyle get label => GoogleFonts.spaceMono(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
        color: textSecondary,
      );

  TextStyle get caption => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      );

  // Custom Double-Bezel Card Decoration
  BoxDecoration outerShellDecoration() {
    return BoxDecoration(
      color: shellColor,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: borderColor, width: 1),
    );
  }

  BoxDecoration innerCoreDecoration() {
    return BoxDecoration(
      color: surfaceColor,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: borderColor, width: 0.5),
      boxShadow: cardShadow,
    );
  }
}
