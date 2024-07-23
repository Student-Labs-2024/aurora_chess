import 'package:flutter/material.dart';

class TextHeading extends StatelessWidget {
  const TextHeading({
    super.key,
    required this.text
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 32, bottom: 16),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w700,
          color: scheme.primary
        ),
      ),
    );
  }

}