import "../../../../../exports.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

class UndoRedoButtons extends StatelessWidget {
  final GameModel gameModel;

  bool get undoEnabled {
    if (gameModel.playingWithAI) {
      return (gameModel.game?.board.moveStack.length ?? 0) > 1 &&
          !gameModel.isAIsTurn;
    } else {
      return gameModel.game?.board.moveStack.isNotEmpty ?? false;
    }
  }

  bool get redoEnabled {
    if (gameModel.playingWithAI) {
      return (gameModel.game?.board.redoStack.length ?? 0) > 1 &&
          !gameModel.isAIsTurn;
    } else {
      return gameModel.game?.board.redoStack.isNotEmpty ?? false;
    }
  }

  const UndoRedoButtons(this.gameModel, {super.key});

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: IconButton(
            icon: SvgPicture.asset(
              "assets/images/icons/left_arrow_icon.svg",
              color: scheme.primary,
            ),
            onPressed: undoEnabled ? () => undo() : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: IconButton(
            icon: SvgPicture.asset(
              "assets/images/icons/right_arrow_icon.svg",
              color: scheme.primary,
            ),
            onPressed: redoEnabled ? () => redo() : null,
          ),
        ),
      ],
    );
  }

  void undo() {
    if (gameModel.playingWithAI) {
      gameModel.game?.undoTwoMoves();
    } else {
      gameModel.game?.undoMove();
    }
  }

  void redo() {
    if (gameModel.playingWithAI) {
      gameModel.game?.redoTwoMoves();
    } else {
      gameModel.game?.redoMove();
    }
  }
}
