import 'package:frontend/model/app_model.dart';
import 'package:frontend/views/components/chess_view/game_info_and_controls/moves_undo_redo_row/undo_redo_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'game_info_and_controls/restart_exit_buttons.dart';

class GameInfoAndControls extends StatelessWidget {
  final AppModel appModel;

  GameInfoAndControls(this.appModel);

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
      child: Container(
        child: Row(
          children: [
            Expanded(child: RestartExitButtons(appModel)),
            SizedBox(width: 10),
            Expanded(child: UndoRedoButtons(appModel)),
          ],
        ),
      ),
    );
  }
}
