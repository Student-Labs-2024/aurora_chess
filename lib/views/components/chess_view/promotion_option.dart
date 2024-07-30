
import 'package:flutter/material.dart';
import 'package:frontend/logic/chess_piece.dart';
import 'package:frontend/logic/shared_functions.dart';
import 'package:frontend/model/game_model.dart';
import 'package:frontend/views/components/main_menu_view/game_options/side_picker.dart';

class PromotionOption extends StatelessWidget {
  final GameModel gameModel;
  final ChessPieceType promotionType;

  const PromotionOption(this.gameModel, this.promotionType, {super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image(
        image: AssetImage(
          'assets/images/pieces/${formatPieceTheme(gameModel.pieceTheme)}' +
              '/${pieceTypeToString(promotionType)}_${_playerColor()}.png',
        ),
      ),
      onPressed: () {
        gameModel.game?.promote(promotionType);
        gameModel.update();
        Navigator.pop(context);
      },
    );
  }

  String _playerColor() {
    return gameModel.turn == Player.player1 ? 'white' : 'black';
  }
}
