import "package:flutter/material.dart";
import "../../../../exports.dart";

class Timers extends StatelessWidget {
  final GameModel gameModel;

  const Timers(this.gameModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return gameModel.timeLimit != 0
        ? Column(
            children: [
              Row(
                children: [
                  TimerWidget(
                    timeLeft: gameModel.player1TimeLeft,
                    isFilled: gameModel.turn == Player.player1,
                  ),
                  const SizedBox(width: 10),
                  TimerWidget(
                    timeLeft: gameModel.player2TimeLeft,
                    isFilled: gameModel.turn == Player.player2,
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],
          )
        : Container(height: 10, color: Colors.red);
  }
}
