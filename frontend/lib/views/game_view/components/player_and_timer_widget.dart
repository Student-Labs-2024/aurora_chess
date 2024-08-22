import 'package:flutter/material.dart';

import '../../../exports.dart';

class PlayerAndTimerWidget extends StatelessWidget {
  final GameModel gameModel;
  final Player currentPlayer;
  const PlayerAndTimerWidget(
      {super.key, required this.gameModel, required this.currentPlayer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          NameWithAdvantageForPlayer(
            player: currentPlayer,
            gameModel: gameModel,
          ),
          Expanded(child: Container()),
          gameModel.timeLimit == 0
              ? const SizedBox(
                  height: 48,
                )
              : TimerWidget(
                  timeLeft: currentPlayer != Player.player1
                      ? gameModel.player1TimeLeft
                      : gameModel.player2TimeLeft,
                  isFilled: gameModel.turn != currentPlayer,
                ),
        ],
      ),
    );
  }
}
