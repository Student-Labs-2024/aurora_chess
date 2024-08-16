import "../../../exports.dart";
import "package:flutter/material.dart";

class GameInfoAndControls extends StatelessWidget {
  final GameModel gameModel;
  final bool isMoveBack;
  final bool isHints;

  const GameInfoAndControls({
    super.key,
    required this.gameModel,
    required this.isMoveBack,
    required this.isHints,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
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
          Expanded(child: RestartExitButtons(gameModel, isHints)),
          const SizedBox(width: 10),
          Expanded(child: UndoRedoButtons(gameModel, isMoveBack)),
        ],
      ),
    );
  }
}
