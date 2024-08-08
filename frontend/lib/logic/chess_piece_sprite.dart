import "../exports.dart";
import "package:flame/components.dart";
import "package:flame/flame.dart";
import "package:flame/sprite.dart";

class ChessPieceSprite {
  ChessPieceType? type;
  int? tile;
  Sprite? sprite;
  double? spriteX;
  double? spriteY;
  double offsetX = 0;
  double offsetY = 0;
  double maxSprite = 0.1;

  ChessPieceSprite(ChessPiece piece) {
    this.tile = piece.tile;
    this.type = piece.type;
    initSprite(piece);
  }

  void update(double tileSize, GameModel GameModel, ChessPiece piece) {
    if (piece.type != this.type) {
      this.type = piece.type;
      initSprite(piece);
    }
    if (piece.tile != this.tile) {
      this.tile = piece.tile;
      offsetX = 0;
      offsetY = 0;
    }
    var destX = getXFromTile(tile ?? 0, tileSize, GameModel);
    var destY = getYFromTile(tile ?? 0, tileSize, GameModel);
    if ((destX - (spriteX ?? 0)).abs() <= maxSprite) {
      spriteX = destX;
      offsetX = 0;
    } else {
      if (offsetX == 0) {
        offsetX = (destX - (spriteX ?? 0)) / LogicConsts.height;
      }
      if (spriteX != null) {
        spriteX = (spriteX ?? 0) + offsetX;
      }
    }
    if ((destY - (spriteY ?? 0)).abs() <= maxSprite) {
      spriteY = destY;
      offsetY = 0;
    } else {
      if (offsetY == 0) {
        offsetY += (destY - (spriteY ?? 0)) / LogicConsts.height;
      }
      if (spriteX != null) {
        spriteY = (spriteY ?? 0) + offsetY;
      }
    }
  }

  void initSprite(ChessPiece piece) async {
    String color = piece.player == Player.player1 ? "white" : "black";
    String pieceName = pieceTypeToString(piece.type);
    if (piece.type == ChessPieceType.promotion) {
      pieceName = "pawn";
    }
    sprite = Sprite(await Flame.images.load(
        "pieces/${pieceName}_$color.png"));
  }

  void initSpritePosition(double tileSize, GameModel GameModel) {
    spriteX = getXFromTile(tile ?? 0, tileSize, GameModel);
    spriteY = getYFromTile(tile ?? 0, tileSize, GameModel);
  }
}
