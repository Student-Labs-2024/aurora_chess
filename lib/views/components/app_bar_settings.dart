import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../exports.dart';

class AppBarSettings extends StatelessWidget {
  const AppBarSettings({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            "assets/images/icons/left_big_arrow_icon.svg",
            color: scheme.onSecondary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            color: scheme.primary
          ),
        ),
        ButtonToGuide(
          backGroundColor: scheme.secondary,
          iconColor: scheme.surface,
          height: 32,
          width: 32,
          iconSize: 18,
          onTap: () {},
        ),
      ],
    );
  }

}