import "../../exports.dart";

const kingTable = [
  -30,
  -40,
  -40,
  -50,
  -50,
  -40,
  -40,
  -30,
  -30,
  -40,
  -40,
  -50,
  -50,
  -40,
  -40,
  -30,
  -30,
  -40,
  -40,
  -50,
  -50,
  -40,
  -40,
  -30,
  -30,
  -40,
  -40,
  -50,
  -50,
  -40,
  -40,
  -30,
  -20,
  -30,
  -30,
  -40,
  -40,
  -30,
  -30,
  -20,
  -10,
  -20,
  -20,
  -20,
  -20,
  -20,
  -20,
  -10,
  20,
  20,
  0,
  0,
  0,
  0,
  20,
  20,
  20,
  30,
  10,
  0,
  0,
  10,
  30,
  20
];

const kingEndgameTable = [
  -50,
  -40,
  -30,
  -20,
  -20,
  -30,
  -40,
  -50,
  -30,
  -20,
  -10,
  0,
  0,
  -10,
  -20,
  -30,
  -30,
  -10,
  20,
  30,
  30,
  20,
  -10,
  -30,
  -30,
  -10,
  30,
  40,
  40,
  30,
  -10,
  -30,
  -30,
  -10,
  30,
  40,
  40,
  30,
  -10,
  -30,
  -30,
  -10,
  20,
  30,
  30,
  20,
  -10,
  -30,
  -30,
  -30,
  0,
  0,
  0,
  0,
  -30,
  -30,
  -50,
  -30,
  -30,
  -30,
  -30,
  -30,
  -30,
  -50
];

const queenTable = [
  -20,
  -10,
  -10,
  -5,
  -5,
  -10,
  -10,
  -20,
  -10,
  0,
  0,
  0,
  0,
  0,
  0,
  -10,
  -10,
  0,
  5,
  5,
  5,
  5,
  0,
  -10,
  -5,
  0,
  5,
  5,
  5,
  5,
  0,
  -5,
  0,
  0,
  5,
  5,
  5,
  5,
  0,
  -5,
  -10,
  5,
  5,
  5,
  5,
  5,
  0,
  -10,
  -10,
  0,
  5,
  0,
  0,
  0,
  0,
  -10,
  -20,
  -10,
  -10,
  -5,
  -5,
  -10,
  -10,
  -20
];

const rookTable = [
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  5,
  10,
  10,
  10,
  10,
  10,
  10,
  5,
  -5,
  0,
  0,
  0,
  0,
  0,
  0,
  -5,
  -5,
  0,
  0,
  0,
  0,
  0,
  0,
  -5,
  -5,
  0,
  0,
  0,
  0,
  0,
  0,
  -5,
  -5,
  0,
  0,
  0,
  0,
  0,
  0,
  -5,
  -5,
  0,
  0,
  0,
  0,
  0,
  0,
  -5,
  0,
  0,
  0,
  5,
  5,
  0,
  0,
  0
];

const bishopTable = [
  -20,
  -10,
  -10,
  -10,
  -10,
  -10,
  -10,
  -20,
  -10,
  0,
  0,
  0,
  0,
  0,
  0,
  -10,
  -10,
  0,
  5,
  10,
  10,
  5,
  0,
  -10,
  -10,
  5,
  5,
  10,
  10,
  5,
  5,
  -10,
  -10,
  0,
  10,
  10,
  10,
  10,
  0,
  -10,
  -10,
  10,
  10,
  10,
  10,
  10,
  10,
  -10,
  -10,
  5,
  0,
  0,
  0,
  0,
  5,
  -10,
  -20,
  -10,
  -10,
  -10,
  -10,
  -10,
  -10,
  -20
];

const knightTable = [
  -50,
  -40,
  -30,
  -30,
  -30,
  -30,
  -40,
  -50,
  -40,
  -20,
  0,
  0,
  0,
  0,
  -20,
  -40,
  -30,
  0,
  10,
  15,
  15,
  10,
  0,
  -30,
  -30,
  5,
  15,
  20,
  20,
  15,
  5,
  -30,
  -30,
  0,
  15,
  20,
  20,
  15,
  0,
  -30,
  -30,
  5,
  10,
  15,
  15,
  10,
  5,
  -30,
  -40,
  -20,
  0,
  5,
  5,
  0,
  -20,
  -40,
  -50,
  -40,
  -30,
  -30,
  -30,
  -30,
  -40,
  -50
];

const pawnTable = [
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  50,
  50,
  50,
  50,
  50,
  50,
  50,
  50,
  10,
  10,
  20,
  30,
  30,
  20,
  10,
  10,
  5,
  5,
  10,
  25,
  25,
  10,
  5,
  5,
  0,
  0,
  0,
  20,
  20,
  0,
  0,
  0,
  5,
  -5,
  -10,
  0,
  0,
  -10,
  -5,
  5,
  5,
  10,
  10,
  -20,
  -20,
  10,
  10,
  5,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0
];

int squareValue(ChessPiece piece, bool inEndGame) {
  var tile = piece.player == Player.player1
      ? piece.tile
      : piece.tile + (LogicConsts.countOfSquares - LogicConsts.lenOfRow)
      - 2 * LogicConsts.lenOfRow * (piece.tile / LogicConsts.lenOfRow).floor();
  int value;
  switch (piece.type) {
    case ChessPieceType.pawn:
      {
        value = pawnTable[tile];
      }
      break;
    case ChessPieceType.knight:
      {
        value = knightTable[tile];
      }
      break;
    case ChessPieceType.bishop:
      {
        value = bishopTable[tile];
      }
      break;
    case ChessPieceType.rook:
      {
        value = rookTable[tile];
      }
      break;
    case ChessPieceType.queen:
      {
        value = queenTable[tile];
      }
      break;
    case ChessPieceType.king:
      {
        value = inEndGame ? kingEndgameTable[tile] : kingTable[tile];
      }
      break;
    default:
      {
        value = 0;
      }
      break;
  }
  return piece.player == Player.player1 ? value : -value;
}
