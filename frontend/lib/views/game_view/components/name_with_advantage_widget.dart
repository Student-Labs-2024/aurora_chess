import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../exports.dart';

// ignore: must_be_immutable
class NameWithAdvantageForPlayer extends StatelessWidget {
  GameModel gameModel;
  Player player;
  NameWithAdvantageForPlayer(
      {required this.player, required this.gameModel, super.key});

  @override
  Widget build(BuildContext context) {
    if (player == Player.player1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextRegular(
            gameModel.playerCount == 1 ? 'Игрок' : 'Игрок1',
          ),
          gameModel.player1Advantage > gameModel.player2Advantage
              ? Row(
                  children: [
                    SvgPicture.asset('assets/images/icons/advantage.svg'),
                    const SizedBox(width: 5),
                    TextRegular(
                        " +${gameModel.player1Advantage - gameModel.player2Advantage}"),
                  ],
                )
              : Container()
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextRegular(
            gameModel.playerCount == 1 ? 'Робот' : 'Игрок2',
          ),
          gameModel.player1Advantage < gameModel.player2Advantage
              ? Row(
                  children: [
                    SvgPicture.asset('assets/images/icons/advantage.svg'),
                    const SizedBox(width: 5),
                    TextRegular(
                        "+${gameModel.player2Advantage - gameModel.player1Advantage}"),
                  ],
                )
              : Container(),
        ],
      );
    }
  }
}
