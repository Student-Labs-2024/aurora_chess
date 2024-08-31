import "package:flutter/material.dart";
import "package:frontend/exports.dart";

class ChoseColorWidget extends StatelessWidget {
  const ChoseColorWidget({
    super.key,
    required this.piecesColor,
    this.onTap,
  });

  final Player piecesColor;
  final void Function(Player)? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextHeading(
          text: GameSettingConsts.colorPiecesText,
          topMargin: 32,
          bottomMargin: 16,
        ),
        Row(
          children: [
            ColorChoseButton(
              variant: Player.player1,
              chose: piecesColor,
              onTap: () {
                onTap!(Player.player1);
              },
            ),
            const SizedBox(
              width: 8,
            ),
            ColorChoseButton(
              variant: Player.random,
              chose: piecesColor,
              onTap: () {
                onTap!(Player.random);
              },
            ),
            const SizedBox(
              width: 8,
            ),
            ColorChoseButton(
              variant: Player.player2,
              chose: piecesColor,
              onTap: () {
                onTap!(Player.player2);
              },
            ),
          ],
        ),
      ],
    );
  }

}