import 'package:frontend/model/game_model.dart';
import 'package:frontend/views/game_view/components/game_info_and_controls/timer_widget.dart';
import 'package:flutter/material.dart';

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
                    color: Colors.red,
                  ),
                  const SizedBox(width: 10),
                  TimerWidget(
                    timeLeft: gameModel.player2TimeLeft,
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],
          )
        : Container(height: 10, color: Colors.red);
  }
}
