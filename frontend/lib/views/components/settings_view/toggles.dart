import "dart:io";

import "package:frontend/model/game_model.dart";
import "package:flutter/material.dart";

import "toggle.dart";

class Toggles extends StatelessWidget {
  final GameModel gameModel;

  const Toggles(this.gameModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Toggle(
          "Show Hints",
          toggle: gameModel.showHints,
          setFunc: gameModel.setShowHints,
        ),
        Toggle(
          "Allow Undo/Redo",
          toggle: gameModel.allowUndoRedo,
          setFunc: gameModel.setAllowUndoRedo,
        ),
        Toggle(
          "Show Move History",
          toggle: gameModel.showMoveHistory,
          setFunc: gameModel.setShowMoveHistory,
        ),
        Platform.isAndroid
            ? Toggle(
                "Sound Enabled",
                toggle: gameModel.soundEnabled,
                setFunc: gameModel.setSoundEnabled,
              )
            : Container(),
      ],
    );
  }
}
