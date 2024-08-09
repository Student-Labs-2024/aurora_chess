import '../exports.dart';

class LogicConsts {
  static const secondsToHint = 50; //25-60 seconds is best choice
  static const int priceOfPawn = 100;
  static const int priceOfKnight = 320;
  static const int priceOfBishop = 330;
  static const int priceOfRook = 500;
  static const int priceOfQueen = 900;
  static const int priceOfKing = 20000;
  static const int countOfSquares = 64;
  static const int lenOfRow = 8;
  static const int height = 10;
  static const int minCountOfPieces = 3;
  static const int baseChar = 97;
  static const int offset = 5;
  static const int advantageOfPawn = 1;
  static const int advantageOfKnight = 3;
  static const int advantageOfBishop = 3;
  static const int advantageOfRook = 5;
  static const int advantageOfQueen = 9;

  static const Map<ChessPieceType, int> advantagesForPieces = {
    ChessPieceType.pawn: advantageOfPawn,
    ChessPieceType.knight: advantageOfKnight,
    ChessPieceType.bishop: advantageOfBishop,
    ChessPieceType.rook: advantageOfRook,
    ChessPieceType.queen: advantageOfQueen,
    ChessPieceType.king: 0,
  };

  static const startPlayersPiecesAdvantage = 49;
}
