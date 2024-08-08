import "package:flutter/material.dart";

class TextStyles {
  const TextStyles();

  TextStyle get title1 => const TextStyle(
    fontSize: 36,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
  );

  TextStyle get title2 => const TextStyle(
    fontSize: 28,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  TextStyle get title3 => const TextStyle(
    fontSize: 24,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
  );

  TextStyle get header1 => const TextStyle(
    fontSize: 24,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  TextStyle get header2 => const TextStyle(
    fontSize: 20,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
  );

  TextStyle get body1 => const TextStyle(
    fontSize: 20,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  TextStyle get body2 => const TextStyle(
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  TextStyle get caption1 => const TextStyle(
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );
}