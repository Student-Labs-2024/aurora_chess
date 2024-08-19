import "../../../../exports.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

class UndoRedoButtons extends StatelessWidget {
  final GameModel gameModel;
  final bool isMoveBack;

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

  const UndoRedoButtons(this.gameModel, this.isMoveBack, {super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: IconButton(
            icon: SvgPicture.asset(
              GamePageConst.leftArrow,
              colorFilter: ColorFilter.mode(
                (isMoveBack || gameModel.playerCount == 2)
                    ? scheme.primary : scheme.onError,
                BlendMode.srcIn
              ),
            ),
            highlightColor: Colors.white.withOpacity(0.3),
            onPressed: ((isMoveBack || gameModel.playerCount == 2)
                && undoEnabled)  ? () => undo() : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: IconButton(
            icon: SvgPicture.asset(
              GamePageConst.rightArrow,
              colorFilter: ColorFilter.mode(
                (isMoveBack || gameModel.playerCount == 2)
                    ? scheme.primary : scheme.onError,
                BlendMode.srcIn
              ),
            ),
            highlightColor: Colors.white.withOpacity(0.3),
            onPressed: ((isMoveBack || gameModel.playerCount == 2)
                && redoEnabled) ? () => redo() : null,
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
