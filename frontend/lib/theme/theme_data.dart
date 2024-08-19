import "package:frontend/constants/colors.dart";
import "package:flutter/material.dart";

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: ColorsConst.neutralColor0,
    primary: ColorsConst.neutralColor200,
    primaryContainer: ColorsConst.primaryColor100,
    onPrimary: ColorsConst.primaryColor0,
    onBackground: ColorsConst.neutralColor0,
    onPrimaryContainer: ColorsConst.neutralColor200,
    secondary: ColorsConst.secondaryColor0,
    onSecondaryContainer: ColorsConst.primaryColor100,
    secondaryContainer: ColorsConst.neutralColor200,
    onSecondary: ColorsConst.neutralColor200,
    surface: ColorsConst.neutralColor200,
    outline: ColorsConst.secondaryColor0,
    tertiary: ColorsConst.neutralColor300,
    tertiaryContainer: ColorsConst.secondaryColor200,
    surfaceTint: ColorsConst.secondaryColor200,
    inversePrimary: ColorsConst.active100,
    onTertiary: ColorsConst.neutralColor300,
    onSurface: ColorsConst.secondaryColor100,
    surfaceVariant: ColorsConst.secondaryColor200,
    inverseSurface: ColorsConst.secondaryColor0,
    outlineVariant: ColorsConst.neutralColor200,
    onInverseSurface: ColorsConst.secondaryColor0,
    onTertiaryContainer: ColorsConst.secondaryColor200,
    onSurfaceVariant: ColorsConst.primaryColor0,
    scrim: ColorsConst.secondaryColor200,
    error: ColorsConst.neutralColor100,
    errorContainer: Colors.grey.withOpacity(0.2),
    onError: ColorsConst.neutralColor100.withOpacity(0.5),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: ColorsConst.neutralColor200,
    primary: ColorsConst.primaryColor0,
    primaryContainer: ColorsConst.primaryColor0,
    onPrimary: ColorsConst.primaryColor100,
    onBackground: ColorsConst.neutralColor100,
    onPrimaryContainer: ColorsConst.primaryColor100,
    secondary: ColorsConst.neutralColor100,
    onSecondaryContainer: ColorsConst.primaryColor200,
    secondaryContainer: ColorsConst.primaryColor200,
    onSecondary: ColorsConst.secondaryColor100,
    surface: ColorsConst.neutralColor0,
    outline: ColorsConst.secondaryColor100,
    tertiary: ColorsConst.neutralColor0,
    tertiaryContainer: ColorsConst.secondaryColor100,
    surfaceTint: ColorsConst.secondaryColor300,
    inversePrimary: ColorsConst.primaryColor0,
    onTertiary: ColorsConst.primaryColor0,
    onSurface: ColorsConst.primaryColor200,
    surfaceVariant: ColorsConst.primaryColor200,
    inverseSurface: ColorsConst.neutralColor0,
    outlineVariant: ColorsConst.neutralColor100,
    onInverseSurface: ColorsConst.secondaryColor300,
    onTertiaryContainer: ColorsConst.secondaryColor0,
    onSurfaceVariant: ColorsConst.secondaryColor300,
    scrim: ColorsConst.secondaryColor300,
    error: ColorsConst.secondaryColor100,
    errorContainer: Colors.white.withOpacity(0.3),
    onError: ColorsConst.neutralColor100,
  ),
);
