import 'package:flutter/material.dart';

class NextPageButton extends StatelessWidget {
  const NextPageButton({
    super.key,
    required this.text,
    required this.textColor,
    required this.buttonColor,
    required this.isClickable,
    this.onTap,
  });
  final String text;
  final Color textColor;
  final Color buttonColor;
  final bool isClickable;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      height: 60,
      minWidth: double.infinity,
      onPressed: onTap,
      color: buttonColor,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          color: textColor
        ),
      ),
    );
  }

}