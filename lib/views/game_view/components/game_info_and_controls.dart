import '../../../exports.dart';
import 'package:flutter/material.dart';

class GameInfoAndControls extends StatelessWidget {
  final GameModel gameModel;

  const GameInfoAndControls(this.gameModel, {super.key});

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: ShapeDecoration(
        color: scheme.surfaceTint,
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
