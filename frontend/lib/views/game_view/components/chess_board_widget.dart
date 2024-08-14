import "package:flame/game.dart";
import "../../../exports.dart";
import "package:flutter/material.dart";

class ChessBoardWidget extends StatelessWidget {
  final GameModel gameModel;

  const ChessBoardWidget(this.gameModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 14, right: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - LogicConsts.boardMargin,
          height: MediaQuery.of(context).size.width - LogicConsts.boardMargin,
          child: GameWidget(game: gameModel.game!, ),
        ),
      ),
    );
  }
}
