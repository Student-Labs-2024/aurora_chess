import 'dart:ui';

import 'package:frontend/logic/shared_functions.dart';
import 'package:frontend/model/game_model.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

class PiecePreview extends Game {
  GameModel gameModel;

  Map<int, String> get imageMap {
    return {
      0: 'pieces/${formatPieceTheme(gameModel.pieceTheme)}/king_black.png',
      1: 'pieces/${formatPieceTheme(gameModel.pieceTheme)}/queen_white.png',
      2: 'pieces/${formatPieceTheme(gameModel.pieceTheme)}/rook_white.png',
      3: 'pieces/${formatPieceTheme(gameModel.pieceTheme)}/bishop_black.png',
      4: 'pieces/${formatPieceTheme(gameModel.pieceTheme)}/knight_black.png',
      5: 'pieces/${formatPieceTheme(gameModel.pieceTheme)}/pawn_white.png',
    };
  }

  Map<int, Sprite> spriteMap = Map();
  bool rendered = false;

  PiecePreview(this.gameModel) {
    loadSpriteImages();
  }

  loadSpriteImages() async {
    for (var index = 0; index < 6; index++) {
      spriteMap[index] = Sprite(await Flame.images.load(imageMap[index] ?? ""));
    }
  }

  @override
  void render(Canvas canvas) {
    for (var index = 0; index < 6; index++) {
      canvas.drawRect(
        Rect.fromLTWH((index % 2) * 40.0, (index / 2).floor() * 40.0, 40, 40),
        Paint()
          ..color = (index + (index / 2).floor()) % 2 == 0
              ? Color(0xFFC6BAAA)
              : Color(0xFF806C61),
      );
      spriteMap[index]?.render(
        canvas,
        size: Vector2(30, 30),
        position: Vector2(
          (index % 2) * 40.0 + 5,
          (index / 2).floor() * 40.0 + 5,
        ),
      );
    }
  }

  @override
  void update(double t) {}
}
