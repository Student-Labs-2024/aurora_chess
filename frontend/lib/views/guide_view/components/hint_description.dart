import "package:flutter/material.dart";

class HintDescription extends StatelessWidget {
  const HintDescription({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        const SizedBox(
          height: 24,
        ),
        Text(
          "Описание",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: scheme.primary,
            fontSize: 20,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w700,
            height: 0.1
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          softWrap: false,
          style: TextStyle(
            color: scheme.primary,
            fontSize: 16,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
