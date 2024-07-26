import 'package:frontend/model/app_model.dart';
import 'package:frontend/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return Consumer<AppModel>(
      builder: (context, appModel, child) => Row(
        children: [
          Text(
            _getStatus(appModel),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: scheme.primary,
              fontSize: 25,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              height: 0.07,
            ),
          ),
          !appModel.gameOver && appModel.playerCount == 1 && appModel.isAIsTurn
              ? CupertinoActivityIndicator(radius: 12)
              : Container()
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  String _getStatus(AppModel appModel) {
    if (!appModel.gameOver) {
      if (appModel.playerCount == 1) {
        if (appModel.isAIsTurn) {
          return 'Ход противника ';
        } else {
          return 'Ваш ход';
        }
      } else {
        if (appModel.turn == Player.player1) {
          return 'Ход белых';
        } else {
          return 'Ход чёрных';
        }
      }
    } else {
      if (appModel.stalemate) {
        return 'Ничья';
      } else {
        if (appModel.playerCount == 1) {
          if (appModel.isAIsTurn) {
            return 'Вы выиграли!';
          } else {
            return 'Вы проиграли';
          }
        } else {
          if (appModel.turn == Player.player1) {
            return 'Выиграли чёрные';
          } else {
            return 'Выиграли белые';
          }
        }
      }
    }
  }
}
