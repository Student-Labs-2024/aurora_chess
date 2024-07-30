import 'package:flutter/cupertino.dart';
import 'package:frontend/model/game_model.dart';

import 'game_options/ai_difficulty_picker.dart';
import 'game_options/game_mode_picker.dart';
import 'game_options/side_picker.dart';
import 'game_options/time_limit_picker.dart';

class GameOptions extends StatelessWidget {
  final GameModel gameModel;

  GameOptions(this.gameModel);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        physics: ClampingScrollPhysics(),
        children: [
          GameModePicker(
            gameModel.playerCount,
            gameModel.setPlayerCount,
          ),
          SizedBox(height: 20),
          gameModel.playerCount == 1
              ? Column(
                  children: [
                    AIDifficultyPicker(
                      gameModel.aiDifficulty,
                      gameModel.setAIDifficulty,
                    ),
                    SizedBox(height: 20),
                    SidePicker(
                      gameModel.selectedSide,
                      gameModel.setPlayerSide,
                    ),
                    SizedBox(height: 20),
                  ],
                )
              : Container(),
          TimeLimitPicker(
            selectedTime: gameModel.timeLimit,
            setTime: gameModel.setTimeLimit,
          ),
        ],
      ),
    );
  }
}
