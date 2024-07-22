import 'package:frontend/exports.dart';
import 'package:flutter/material.dart';

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
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: ColorsConst.neutralColor200,
    primary: ColorsConst.primaryColor0,
    primaryContainer: ColorsConst.primaryColor0,
    onPrimary: ColorsConst.primaryColor100,
    onBackground: ColorsConst.feedbackColor100,
    onPrimaryContainer: ColorsConst.primaryColor100,
    secondary: ColorsConst.secondaryColor100,
  ),
);