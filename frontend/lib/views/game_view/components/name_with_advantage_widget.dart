import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../exports.dart';

// ignore: must_be_immutable
class NameWithAdvantageForPlayer extends StatelessWidget {
  GameModel gameModel;
  final Player player;
  NameWithAdvantageForPlayer(
      {required this.player, required this.gameModel, super.key});

  @override
  Widget build(BuildContext context) {
    Map<int, String> difficultyLevels = {
      1: "Лёгкий",
      3: "Средний",
      5: "Сложный"
    };
    final scheme = Theme.of(context).colorScheme;
    if (player != gameModel.selectedSide) {
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
              height: 1.2,
            ),
          ),
          _advantageForThisPlayer(player, scheme),
        ],
      );
    } else {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          gameModel.playerCount == 1
              ? 'Робот (${difficultyLevels[gameModel.aiDifficulty]})'
              : 'Игрок2',
          style: TextStyle(
            color: scheme.primary,
            fontSize: 20,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
        _advantageForThisPlayer(player, scheme),
      ]);
    }
  }

  Widget _advantageForThisPlayer(Player player, ColorScheme scheme) {
    return gameModel.advantageForPlayer(oppositePlayer(player)) >
            gameModel.advantageForPlayer(player)
        ? Row(
            children: [
              SvgPicture.asset('assets/images/icons/advantage.svg'),
              Text(
                "+${gameModel.advantageForPlayer(oppositePlayer(player)) - gameModel.advantageForPlayer(player)}",
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
        : Container();
  }
}