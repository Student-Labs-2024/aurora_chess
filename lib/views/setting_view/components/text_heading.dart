import 'package:flutter/material.dart';

class TextHeading extends StatelessWidget {
  const TextHeading({
    super.key,
    required this.text,
    required this.topMargin,
    required this.bottomMargin
  });

  final String text;
  final double topMargin;
  final double bottomMargin;

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w700,
          color: scheme.primary,
        ),
      ),
    );
  }

}