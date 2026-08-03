import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyleExtension extends ThemeExtension<TextStyleExtension> {
  const TextStyleExtension();

  TextStyle get displayLarge {
    return GoogleFonts.poppins(
      height: 1.20,
      fontSize: 57,
      letterSpacing: -0.25,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle get displayMedium {
    return GoogleFonts.poppins(
      height: 1.20,
      fontSize: 45,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle get displaySmall {
    return GoogleFonts.poppins(
      height: 1.20,
      fontSize: 36,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle get headlineLarge {
    return GoogleFonts.nunitoSans(
      height: 1.25,
      fontSize: 32,
      letterSpacing: 0,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle get headlineMedium {
    return GoogleFonts.nunitoSans(
      height: 1.30,
      fontSize: 28,
      letterSpacing: 0,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle get headlineSmall {
    return GoogleFonts.nunitoSans(
      height: 1.33,
      fontSize: 24,
      letterSpacing: 0,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle get titleLarge {
    return GoogleFonts.nunitoSans(
      height: 1.30,
      fontSize: 22,
      letterSpacing: 0,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle get titleMedium {
    return GoogleFonts.nunitoSans(
      height: 1.40,
      fontSize: 16,
      letterSpacing: 0.15,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle get titleSmall {
    return GoogleFonts.nunitoSans(
      height: 1.40,
      fontSize: 14,
      letterSpacing: 0.1,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle get bodyLarge {
    return GoogleFonts.nunitoSans(
      height: 1.50,
      fontSize: 16,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle get bodyMedium {
    return GoogleFonts.nunitoSans(
      height: 1.42,
      fontSize: 14,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle get bodySmall {
    return GoogleFonts.nunitoSans(
      height: 1.42,
      fontSize: 12,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle get labelLarge {
    return GoogleFonts.nunitoSans(
      height: 1.15,
      fontSize: 14,
      letterSpacing: 1,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle get labelMedium {
    return GoogleFonts.nunitoSans(
      height: 1.15,
      fontSize: 12,
      letterSpacing: 1,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle get labelSmall {
    return GoogleFonts.nunitoSans(
      height: 1.15,
      fontSize: 11,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w500,
    );
  }

  @override
  ThemeExtension<TextStyleExtension> copyWith() => const TextStyleExtension();

  @override
  ThemeExtension<TextStyleExtension> lerp(other, t) =>
      const TextStyleExtension();
}
