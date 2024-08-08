import "../exports.dart";

enum ChessPieceType { pawn, rook, knight, bishop, king, queen, promotion }

class ChessPiece {
  int id;
  ChessPieceType type;
  Player player;
  int moveCount = 0;
  int tile;


  int get value {
    int value = 0;
    switch (type) {
      case ChessPieceType.pawn:
        {
          value = LogicConsts.priceOfPawn;
        }
        break;
      case ChessPieceType.knight:
        {
          value = LogicConsts.priceOfKnight;
        }
        break;
      case ChessPieceType.bishop:
        {
          value = LogicConsts.priceOfBishop;
        }
        break;
      case ChessPieceType.rook:
        {
          value = LogicConsts.priceOfRook;
        }
        break;
      case ChessPieceType.queen:
        {
          value = LogicConsts.priceOfQueen;
        }
        break;
      case ChessPieceType.king:
        {
          value = LogicConsts.priceOfKing;
        }
        break;
      default:
        {
          value = 0;
        }
    }
    return (player == Player.player1) ? value : -value;
  }

  ChessPiece(this.id, this.type, this.player, this.tile);
}
