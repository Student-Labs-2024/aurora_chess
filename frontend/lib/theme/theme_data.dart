import "package:frontend/constants/colors.dart";
import "package:flutter/material.dart";

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: ColorsConst.neutralColor0,
    primary: ColorsConst.neutralColor200,
    primaryContainer: ColorsConst.primaryColor100,
    onPrimary: ColorsConst.primaryColor0,
    onBackground: ColorsConst.neutralColor200,
    onPrimaryContainer: ColorsConst.neutralColor200,
    secondary: ColorsConst.secondaryColor0,
    onSecondaryContainer: ColorsConst.neutralColor100,
    secondaryContainer: ColorsConst.neutralColor200,
    onSecondary: ColorsConst.neutralColor200,
    surface: ColorsConst.neutralColor200,
    outline: ColorsConst.secondaryColor0,
    tertiary: ColorsConst.neutralColor300,
    tertiaryContainer: ColorsConst.secondaryColor200,
    surfaceTint: ColorsConst.secondaryColor200,
    inversePrimary: ColorsConst.active100,
    onTertiary: ColorsConst.neutralColor300,
    onSurface: ColorsConst.secondaryColor200,
    surfaceVariant: ColorsConst.secondaryColor200,
    inverseSurface: ColorsConst.secondaryColor0,
    outlineVariant: ColorsConst.neutralColor200,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: ColorsConst.neutralColor200,
    primary: ColorsConst.primaryColor0,
    primaryContainer: ColorsConst.primaryColor0,
    onPrimary: ColorsConst.primaryColor100,
    onBackground: ColorsConst.active100,
    onPrimaryContainer: ColorsConst.primaryColor100,
    secondary: ColorsConst.neutralColor100,
    onSecondaryContainer: ColorsConst.active100,
    secondaryContainer: ColorsConst.primaryColor200,
    onSecondary: ColorsConst.secondaryColor0,
    surface: ColorsConst.neutralColor0,
    outline: ColorsConst.secondaryColor100,
    tertiary: ColorsConst.neutralColor0,
    tertiaryContainer: ColorsConst.secondaryColor100,
    surfaceTint: ColorsConst.secondaryColor300,
    inversePrimary: ColorsConst.primaryColor0,
    onTertiary: ColorsConst.primaryColor0,
    onSurface: ColorsConst.primaryColor0,
    surfaceVariant: ColorsConst.primaryColor200,
    inverseSurface: ColorsConst.neutralColor0,
    outlineVariant: ColorsConst.neutralColor100
  ),
);
