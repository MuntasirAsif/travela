part of 'colors.dart';

/// Primitive color palette
class _Primitive {
  /// brand, primary, active, info
  static const Color brand = Color(0xFFE1217E);

  /// brandLight, secondary
  static const Color brandLight = Color(0xFFF06292);

  /// scaffoldColor, scaffoldBackground
  static const Color scaffoldColor = Color(0xFFF2F5F9);

  /// textFieldFillColor, appBarBackground
  static const Color textFieldFillColor = Color(0xFFFDF8F8);

  /// textFieldBorderColor
  static const Color textFieldBorderColor = Color(0xFF111528);

  /// textFieldFocusBorderColor
  static const Color textFieldFocusBorderColor = Color(0xFFFD6900);

  // -------- Element colors --------

  /// surface, onPrimary, white
  static const Color surface = Color(0xFFFFFFFF);

  /// muted, border, disabled, textSecondary
  static const Color muted = Color(0xFF806E61);

  /// inactive, borderDark
  static const Color inactive = Color(0xFFD5DCE4);

  /// icon, iconDefault
  static const Color icon = Color(0xFF75757C);

  /// title, appBarTitle
  static const Color title = Color(0xFF313137);

  /// textPrimary
  static const Color textPrimary = Color(0xFF291506);

  /// darkSurface, scaffoldBackgroundDark
  static const Color darkSurface = Color(0xFF1B1B1B);

  /// black, onPrimaryDark
  static const Color black = Color(0xFF000000);

  // ---------- Semantic colors --------

  /// success
  static const Color success = Color(0xFF008000);

  /// error
  static const Color error = Color(0xFFFF0000);

  /// warning
  static const Color warning = Color(0xFFFFFF00);

  /// info
  static const Color info = brand;

  // ----------- Accent colors -------

  /// accentBlue
  static const Color accentBlue = Color(0xFF3EC1B3);

  /// accentPurple
  static const Color accentPurple = Color(0xFF6334C1);

  /// accentYellow
  static const Color accentYellow = Color(0xFFC9A768);

  // ----------- Custom Components -------

  /// Header Start (Light)
  static const Color headerStartLight = brandLight;

  /// Header End (Light)
  static const Color headerEndLight = brand;

  /// Header Text (Light)
  static const Color headerTextLight = Color(0xFFFFFFFF);

  /// Header Start (Dark)
  static const Color headerStartDark = brand;

  /// Header End (Dark)
  static const Color headerEndDark = Color(0xFF8E1045);

  /// Header Text (Dark)
  static const Color headerTextDark = Color(0xFFFFFFFF);
}
