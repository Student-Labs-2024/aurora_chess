import "../../../exports.dart";

class MoveMeta {
  Move? move;
  Player? player;
  ChessPieceType? type;
  bool took = false;
  bool kingCastle = false;
  bool queenCastle = false;
  bool promotion = false;
  ChessPieceType? promotionType;
  bool isCheck = false;
  bool isCheckmate = false;
  bool isStalemate = false;
  bool isDraw = false;
  bool rowIsAmbiguous = false;
  bool colIsAmbiguous = false;

  MoveMeta(this.move, this.player, this.type);
}
