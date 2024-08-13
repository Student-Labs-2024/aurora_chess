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
    Map<int, String> difficultyLevels = {
      1: "Лёгкий",
      3: "Средний",
      6: "Сложный"
    };
    var scheme = Theme.of(context).colorScheme;
    if (player == Player.player1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            gameModel.playerCount == 1 ? 'Игрок' : 'Игрок1',
            style: TextStyle(
              color: scheme.primary,
              fontSize: 20,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
          gameModel.player1Advantage > gameModel.player2Advantage
              ? Row(
                  children: [
                    SvgPicture.asset('assets/images/icons/advantage.svg'),
                    Text(
                      "+${gameModel.player1Advantage - gameModel.player2Advantage}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: scheme.primary,
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                    ),
                  ],
                )
              : Container()
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            gameModel.playerCount == 1 ? 'Робот (${difficultyLevels[gameModel.aiDifficulty]})' : 'Игрок2',
            style: TextStyle(
              color: scheme.primary,
              fontSize: 20,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
          gameModel.player1Advantage < gameModel.player2Advantage
              ? Row(
                  children: [
                    SvgPicture.asset('assets/images/icons/advantage.svg'),
                    Text(
                      "+${gameModel.player2Advantage - gameModel.player1Advantage}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: scheme.primary,
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      );
    }
  }
}
