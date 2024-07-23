import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../exports.dart';

class ColorChoseButton extends StatelessWidget {
  const ColorChoseButton({
    super.key,
    required this.variant,
    required this.chose,
    this.onTap,
  });

  final PiecesColor variant;
  final PiecesColor chose;
  final void Function()? onTap;


  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    Map<PiecesColor, String> icon = {
      PiecesColor.black: "dark.svg",
      PiecesColor.white: "light.svg",
      PiecesColor.random: "both.svg",
    };
    return Expanded(
      flex: variant == PiecesColor.random ? 115 : 90,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: variant == PiecesColor.random ? 90 : 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: variant == chose ? ColorsConst.primaryColor100 : scheme.outline,
          ),
          child: Center(
            child: SvgPicture.asset("assets/images/icons/${icon[variant]}")
          ),
        ),
      )
    );
  }

}