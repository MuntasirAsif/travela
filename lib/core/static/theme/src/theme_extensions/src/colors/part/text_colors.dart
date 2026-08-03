part of '../colors.dart';

abstract class TextColors {
  const TextColors();

  Color get primary;
  Color get secondary;
  Color get tertiary;
}

class _LightTextColors extends TextColors {
  const _LightTextColors();

  @override
  Color get primary => _Primitive.textPrimary;

  @override
  Color get secondary => _Primitive.muted;

  @override
  Color get tertiary => _Primitive.muted;
}

class _DarkTextColors extends TextColors {
  const _DarkTextColors();

  @override
  Color get primary => _Primitive.textPrimary;

  @override
  Color get secondary => _Primitive.muted;

  @override
  Color get tertiary => _Primitive.muted;
}
