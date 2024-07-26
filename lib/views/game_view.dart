import 'package:frontend/model/app_model.dart';
import 'package:frontend/views/components/chess_view/chess_board_widget.dart';
import 'package:frontend/views/components/chess_view/game_info_and_controls.dart';
import 'package:frontend/views/components/chess_view/game_info_and_controls/game_status.dart';
import 'package:frontend/views/components/chess_view/game_info_and_controls/moves_undo_redo_row/move_list.dart';
import 'package:frontend/views/components/custom_icon_button.dart';
import 'package:frontend/views/components/shared/bottom_padding.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameView extends StatefulWidget {
  final AppModel appModel;

  GameView(this.appModel);

  @override
  State<GameView> createState() => _GameViewState(appModel);
}

class _GameViewState extends State<GameView> {
  AppModel appModel;

  _GameViewState(this.appModel);

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.background,
      body: Consumer<AppModel>(
        builder: (context, appModel, child) {
          return WillPopScope(
            onWillPop: _willPopCallback,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MoveList(appModel),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 30,
                  ),
                  child: Container(
                    height: 30,
                    child: Stack(
                      children: [
                        CustomIconButton(
                          iconName:
                              "assets/images/icons/left_big_arrow_icon.svg",
                          color: scheme.secondary,
                          iconSize: 32,
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        GameStatus(),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: ChessBoardWidget(appModel),
                ),
                SizedBox(height: 30),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: GameInfoAndControls(appModel),
                ),
                BottomPadding(),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<bool> _willPopCallback() async {
    appModel.exitChessView();

    return true;
  }
}
