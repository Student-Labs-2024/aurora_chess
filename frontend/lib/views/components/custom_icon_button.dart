import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.iconName,
    required this.iconSize,
    required this.color,
    this.onTap
  });

  final String iconName;
  final double iconSize;
  final Color color;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: IconButton(
        onPressed: onTap,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        icon: SvgPicture.asset(
          iconName,
          color: color,
        )
      ),
    );
  }
}