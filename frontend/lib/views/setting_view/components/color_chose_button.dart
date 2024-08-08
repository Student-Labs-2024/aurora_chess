import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

import "../../../exports.dart";

class ColorChoseButton extends StatelessWidget {
  const ColorChoseButton({
    super.key,
    required this.variant,
    required this.chose,
    this.onTap,
  });

  final Player variant;
  final Player chose;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    Map<Player, String> icon = {
      Player.player2: "black.svg",
      Player.player1: "white.svg",
      Player.random: "random.svg",
    };
    return Expanded(
      flex: variant == Player.random ? 115 : 90,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: variant == Player.random ? 90 : 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: variant == chose
              ? ColorsConst.primaryColor100
              : scheme.secondary,
          ),
          child: Center(
            child:
              SvgPicture.asset("assets/images/icons/${icon[variant]}")
          ),
        ),
      )
    );
  }
}
