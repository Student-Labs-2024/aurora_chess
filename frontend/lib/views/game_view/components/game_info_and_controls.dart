import "../../../exports.dart";
import "package:flutter/material.dart";

class GameInfoAndControls extends StatelessWidget {
  final GameModel gameModel;

  const GameInfoAndControls(this.gameModel, {super.key});

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: ShapeDecoration(
        color: scheme.onInverseSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: RestartExitButtons(gameModel)),
          const SizedBox(width: 10),
          Expanded(child: UndoRedoButtons(gameModel)),
        ],
      ),
    );
  }
}
