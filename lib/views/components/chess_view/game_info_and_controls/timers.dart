import 'package:frontend/model/game_model.dart';
import 'package:frontend/views/components/chess_view/game_info_and_controls/timer_widget.dart';
import 'package:flutter/material.dart';

class Timers extends StatelessWidget {
  final GameModel gameModel;

  Timers(this.gameModel);

  @override
  Widget build(BuildContext context) {
    return gameModel.timeLimit != 0
        ? Column(
            children: [
              Row(
                children: [
                  TimerWidget(
                    timeLeft: gameModel.player1TimeLeft,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  TimerWidget(
                    timeLeft: gameModel.player2TimeLeft,
                    color: Colors.black,
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],
          )
        : Container();
  }
}
