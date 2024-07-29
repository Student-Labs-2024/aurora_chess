import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ButtonToGuide extends StatelessWidget {
  const ButtonToGuide({
    super.key,
    required this.backGroundColor,
    required this.iconColor,
    required this.width,
    required this.height,
    this.onTap
  });

  final Color backGroundColor;
  final Color iconColor;
  final double width;
  final double height;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(),
      icon: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: backGroundColor,
        ),
        child: SvgPicture.asset(
          "assets/images/icons/handbook.svg",
        )
      ),
    );
  }

}