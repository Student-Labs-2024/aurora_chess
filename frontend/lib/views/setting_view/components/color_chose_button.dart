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
    final scheme = Theme.of(context).colorScheme;
    Map<Player, String> icon = {
      Player.player2: "black.svg",
      Player.player1: "white.svg",
      Player.random: "random.svg",
    };
    Map<Player, String> text = {
      Player.player2: GameSettingConsts.blackColorChose,
      Player.player1: GameSettingConsts.whiteColorChose,
      Player.random: GameSettingConsts.randomColorChose,
    };
    return Expanded(
      flex: variant == Player.random ? 125 : 93,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          height: variant == Player.random ? 108 : 76,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: variant == chose
              ? ColorsConst.primaryColor100
              : scheme.secondary,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SvgPicture.asset("assets/images/icons/${icon[variant]}"),
              Text(
                text[variant]!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: variant == chose
                    ? ColorsConst.primaryColor0
                    : scheme.tertiary,
                  fontSize: 12,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
