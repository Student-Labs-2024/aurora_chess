import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ButtonToGuide extends StatelessWidget {
  const ButtonToGuide({
    super.key,
    required this.backGroundColor,
    required this.width,
    required this.height,
    this.onTap
  });

  final Color backGroundColor;
  final double width;
  final double height;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: backGroundColor,
      ),
      child: IconButton(
        onPressed: onTap,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        color: backGroundColor,
        icon: SvgPicture.asset(
          "assets/images/icons/handbook.svg",
        ),
      ),
    );
  }

}