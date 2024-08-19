import "package:flame/game.dart";
import "../../../exports.dart";
import "package:flutter/material.dart";

class ChessBoardWidget extends StatelessWidget {
  final GameModel gameModel;

  const ChessBoardWidget(this.gameModel, {super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin:  EdgeInsets.only(
          left: (width * LogicConsts.boardWidthMarginRatio).ceil().toDouble(),
          right: (width * LogicConsts.boardWidthMarginRatio).ceil().toDouble()
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(
          width: (width * (1 - LogicConsts.boardWidthMarginRatio * 2))
              .ceil().toDouble(),
          height: (width * (1 - LogicConsts.boardWidthMarginRatio * 2))
              .ceil().toDouble(),
          child: GameWidget(game: gameModel.game!, ),
        ),
      ),
    );
  }
}
