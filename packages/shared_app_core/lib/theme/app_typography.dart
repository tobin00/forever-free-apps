import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Text styles for all Forever Free apps.
/// Nunito for headers/display, Inter for body/UI.
class AppTypography {
  AppTypography._();

  static TextTheme buildTextTheme(Color onBackground, Color onBackgroundSecondary) {
    return TextTheme(
      // Display — Nunito Bold (quiz letter, hero elements)
      displayLarge: GoogleFonts.nunito(
        fontSize: 32, fontWeight: FontWeight.w700, height: 1.25, color: onBackground,
      ),
      // Display Medium — Nunito Bold (screen titles when prominent)
      displayMedium: GoogleFonts.nunito(
        fontSize: 28, fontWeight: FontWeight.w700, height: 1.25, color: onBackground,
      ),
      // Headline — Nunito Bold (section headers)
      headlineMedium: GoogleFonts.nunito(
        fontSize: 22, fontWeight: FontWeight.w700, height: 1.3, color: onBackground,
      ),
      // Title Large — Sora SemiBold (app bar titles)
      titleLarge: GoogleFonts.sora(
        fontSize: 20, fontWeight: FontWeight.w600, height: 1.3, color: onBackground,
      ),
      // Title Medium — Inter SemiBold (card titles)
      titleMedium: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w600, height: 1.4, color: onBackground,
      ),
      // Body Large — Inter Regular (primary reading)
      bodyLarge: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w400, height: 1.5, color: onBackground,
      ),
      // Body Medium — Inter Regular (default body)
      bodyMedium: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w400, height: 1.5, color: onBackground,
      ),
      // Body Small — Inter Regular (captions)
      bodySmall: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w400, height: 1.5, color: onBackgroundSecondary,
      ),
      // Label Large — Inter SemiBold (buttons, nav labels)
      labelLarge: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w600, height: 1.2, color: onBackground,
      ),
      // Label Medium — Inter Medium (chips, badges)
      labelMedium: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w500, height: 1.2, color: onBackground,
      ),
    );
  }
}
