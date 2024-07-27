import 'package:frontend/model/app_model.dart';
import 'package:frontend/views/components/chess_view/game_info_and_controls/moves_undo_redo_row/undo_redo_buttons.dart';
import 'package:flutter/cupertino.dart';

class MovesUndoRedoRow extends StatelessWidget {
  final AppModel appModel;

  MovesUndoRedoRow(this.appModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            appModel.allowUndoRedo
                ? Container(child: UndoRedoButtons(appModel))
                : Container(),
          ],
        ),
        appModel.showMoveHistory || appModel.allowUndoRedo
            ? SizedBox(height: 10)
            : Container(),
      ],
    );
  }
}
