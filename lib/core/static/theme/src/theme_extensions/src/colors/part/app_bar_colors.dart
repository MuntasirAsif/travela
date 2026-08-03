part of '../colors.dart';

abstract class AppBarColors {
  const AppBarColors();

  Color get background;
  Color get icon;
  Color get surfaceTint;
  Color get title;
}

class _LightAppBarColors extends AppBarColors {
  const _LightAppBarColors();

  @override
  Color get background => _Primitive.scaffoldColor;

  @override
  Color get icon => _Primitive.darkSurface;

  @override
  Color get surfaceTint => _Primitive.textFieldFillColor;

  @override
  Color get title => _Primitive.title;
}

class _DarkAppBarColors extends AppBarColors {
  const _DarkAppBarColors();

  @override
  Color get background => _Primitive.darkSurface;

  @override
  Color get icon => _Primitive.surface;

  @override
  Color get surfaceTint => _Primitive.darkSurface;

  @override
  Color get title => _Primitive.surface;
}
