import "dart:math";
import "../../exports.dart";

const initialAlpha = -40000;
const stalemateAlpha = -20000;
const initialBeta = 40000;
const stalemateBeta = 20000;

Move calculateAIMove(Map args) {
  ChessBoard board = args["board"];
  if (board.possibleOpenings.isNotEmpty) {
    return _openingMove(board, args["aiPlayer"]);
  } else {
    return _alphaBeta(board, args["aiPlayer"], Move(0, 0), 0,
            args["aiDifficulty"], initialAlpha, initialBeta)
        .move;
  }
}

MoveAndValue _alphaBeta(ChessBoard board, Player player, Move move, int depth,
    int maxDepth, int alpha, int beta) {
  if (depth == maxDepth) {
    return MoveAndValue(move, boardValue(board));
  }
  var bestMove = MoveAndValue(
      Move(0, 0), player == Player.player1 ? initialAlpha : initialBeta);
  for (var move in allMoves(player, board, maxDepth)) {
    push(move, board, promotionType: move.promotionType);
    var result = _alphaBeta(
        board, oppositePlayer(player), move, depth + 1, maxDepth, alpha, beta);
    result.move = move;
    pop(board);
    if (player == Player.player1) {
      if (result.value > bestMove.value) {
        bestMove = result;
      }
      alpha = max(alpha, bestMove.value);
      if (alpha >= beta) {
        break;
      }
    } else {
      if (result.value < bestMove.value) {
        bestMove = result;
      }
      beta = min(beta, bestMove.value);
      if (beta <= alpha) {
        break;
      }
    }
  }
  if (bestMove.value.abs() == initialBeta && !kingInCheck(player, board)) {
    if (piecesForPlayer(player, board).length == 1) {
      bestMove.value =
          player == Player.player1 ? stalemateBeta : stalemateAlpha;
    } else {
      bestMove.value =
          player == Player.player1 ? stalemateAlpha : stalemateBeta;
    }
  }
  return bestMove;
}

Move _openingMove(ChessBoard board, Player aiPlayer) {
  List<Move> possibleMoves = board.possibleOpenings
      .map((opening) => opening[board.moveCount])
      .toList();
  return possibleMoves[Random.secure().nextInt(possibleMoves.length)];
}
