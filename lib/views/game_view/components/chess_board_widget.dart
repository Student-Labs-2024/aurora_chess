import 'package:flame/game.dart';
import '../../../exports.dart';
import 'package:flutter/material.dart';

class ChessBoardWidget extends StatelessWidget {
  final GameModel gameModel;

  const ChessBoardWidget(this.gameModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 4,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Color(0x88000000),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 68,
          height: MediaQuery.of(context).size.width - 68,
          child: GameWidget(game: gameModel.game!),
        ),
      ),
    );
  }
}
