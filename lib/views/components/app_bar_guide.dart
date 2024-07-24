import 'package:flutter/material.dart';

import '../../exports.dart';

class AppBarGuide extends StatelessWidget {
  const AppBarGuide({
    super.key,
    required this.isMainGuide,
    required this.iconName,
    required this.iconColor
  });

  final bool isMainGuide;
  final String iconName;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    const guideHeader = "Справочник";
    var scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(left: 29, right: 29, top: 66, bottom: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isMainGuide ? const SizedBox(width: 42,) :
          CustomIconButton(
            iconName: iconName,
            color: iconColor,
            iconSize: 42,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Text(
            guideHeader,
            style: TextStyle(
              color: scheme.surface,
              fontSize: 20,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
            ),
          ),
          isMainGuide ?
          CustomIconButton(
            iconName: iconName,
            color: iconColor,
            iconSize: 42,
            onTap: () {
              Navigator.pop(context);
            },
          ) :
          const SizedBox(width: 42,),
        ],
      ),
    );
  }

}