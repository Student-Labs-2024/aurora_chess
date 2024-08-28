import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../../../../exports.dart";

class GameStatus extends StatelessWidget {
  const GameStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Consumer<GameModel>(
      builder: (context, gameModel, child) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            getStatus(gameModel, context, scheme),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: scheme.primary,
              fontSize: 20,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              height: 0.07,
            ),
          ),
          !gameModel.gameOver &&
                  gameModel.playerCount == 1 &&
                  gameModel.isAIsTurn
              ? const CupertinoActivityIndicator(radius: 12)
              : Container()
        ],
      ),
    );
  }
}

String getStatus(
    GameModel gameModel, BuildContext context, ColorScheme scheme) {
  if (!gameModel.gameOver) {
    if (gameModel.playerCount == 1) {
      if (gameModel.isAIsTurn) {
        return "Ход противника ";
      } else {
        return "Ваш ход";
      }
    } else {
      if (gameModel.turn == Player.player1) {
        return "Ход белых";
      } else {
        return "Ход чёрных";
      }
    }
  } else {
    if (gameModel.stalemate) {
      return "Ничья";
    } else {
      if (gameModel.playerCount == 1) {
        if (gameModel.isAIsTurn) {
          return "Вы выиграли!";
        } else {
          return "Вы проиграли";
        }
      } else {
        if (gameModel.turn == Player.player1) {
          return "Выиграли чёрные";
        } else {
          return "Выиграли белые";
        }
      }
    }
  }
}
