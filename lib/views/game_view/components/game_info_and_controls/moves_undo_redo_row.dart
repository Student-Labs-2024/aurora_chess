import 'package:flutter/material.dart';
import 'package:frontend/model/game_model.dart';
import 'package:frontend/views/game_view/components/game_info_and_controls/undo_redo_buttons.dart';

class MovesUndoRedoRow extends StatelessWidget {
  final GameModel gameModel;

  const MovesUndoRedoRow(this.gameModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            gameModel.allowUndoRedo ? UndoRedoButtons(gameModel) : Container(),
          ],
        ),
        gameModel.showMoveHistory || gameModel.allowUndoRedo
            ? const SizedBox(height: 10)
            : Container(),
      ],
    );
  }
}
