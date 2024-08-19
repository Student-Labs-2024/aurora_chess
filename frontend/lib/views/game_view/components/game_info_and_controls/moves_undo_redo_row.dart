import "package:flutter/material.dart";
import "../../../../exports.dart";

class MovesUndoRedoRow extends StatelessWidget {
  final GameModel gameModel;

  const MovesUndoRedoRow(this.gameModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            gameModel.allowUndoRedo ? UndoRedoButtons(gameModel, true) : Container(),
          ],
        ),
        gameModel.showMoveHistory || gameModel.allowUndoRedo
            ? const SizedBox(height: 10)
            : Container(),
      ],
    );
  }
}
