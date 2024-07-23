import 'package:flutter/material.dart';

class ButtonToGuide extends StatelessWidget {
  const ButtonToGuide({
    super.key,
    required this.backGroundColor,
    required this.iconColor,
    required this.width,
    required this.height,
    required this.iconSize,
    this.onTap
  });

  final Color backGroundColor;
  final Color iconColor;
  final double width;
  final double height;
  final double iconSize;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: backGroundColor,
        ),
        child: Icon(
          Icons.question_mark,
          color: iconColor,
          size: iconSize,
        )
      ),
    );
  }

}