import 'package:frontend/model/app_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UndoRedoButtons extends StatelessWidget {
  final AppModel appModel;

  bool get undoEnabled {
    if (appModel.playingWithAI) {
      return (appModel.game?.board.moveStack.length ?? 0) > 1 &&
          !appModel.isAIsTurn;
    } else {
      return appModel.game?.board.moveStack.isNotEmpty ?? false;
    }
  }

  bool get redoEnabled {
    if (appModel.playingWithAI) {
      return (appModel.game?.board.redoStack.length ?? 0) > 1 &&
          !appModel.isAIsTurn;
    } else {
      return appModel.game?.board.redoStack.isNotEmpty ?? false;
    }
  }

  UndoRedoButtons(this.appModel);

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
        SizedBox(width: 10),
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
    if (appModel.playingWithAI) {
      appModel.game?.undoTwoMoves();
    } else {
      appModel.game?.undoMove();
    }
  }

  void redo() {
    if (appModel.playingWithAI) {
      appModel.game?.redoTwoMoves();
    } else {
      appModel.game?.redoMove();
    }
  }
}
