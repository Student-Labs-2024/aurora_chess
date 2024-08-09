import "package:flutter/material.dart";
import "../../../../exports.dart";

class MoveList extends StatelessWidget {
  final GameModel gameModel;
  final ScrollController scrollController = ScrollController();

  MoveList(this.gameModel, {super.key});

  final int len = 8;
  final int baseChar = 97;

  @override
  Widget build(BuildContext context) {

    var scheme = Theme.of(context).colorScheme;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: scheme.surfaceTint,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Center(child: TextRegular(_allMoves())),
      ),
    );
  }

  void _scrollToBottom() {
    if (gameModel.moveListUpdated) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      gameModel.moveListUpdated = false;
    }
  }

  String _allMoves() {
    var moveString = "";
    gameModel.moveMetaList.asMap().forEach((index, move) {
      var turnNumber = ((index + 1) / 2).ceil();
      if (index % 2 == 0) {
        moveString += index == 0 ? "$turnNumber. " : "   $turnNumber. ";
      }
      moveString += _moveToString(move);
      if (index % 2 == 0) {
        moveString += " ";
      }
    });
    if (gameModel.gameOver) {
      if (gameModel.turn == Player.player1) {
        moveString += " ";
      }
      if (gameModel.stalemate) {
        moveString += "  ½-½";
      } else {
        moveString += gameModel.turn == Player.player2 ? "  1-0" : "  0-1";
      }
    }
    return moveString;
  }

  String _moveToString(MoveMeta meta) {
    String move;
    if (meta.kingCastle) {
      move = "O-O";
    } else if (meta.queenCastle) {
      move = "O-O-O";
    } else {
      String ambiguity = meta.rowIsAmbiguous
          ? _colToChar(tileToCol(meta.move?.from ?? 0))
          : "";
      ambiguity +=
          meta.colIsAmbiguous ? "${len - tileToRow(meta.move?.from ?? 0)}" : "";
      String takeString = meta.took ? "x" : "";
      String promotion = meta.promotion
          ? "=${_pieceToChar(meta.promotionType ?? ChessPieceType.promotion)}"
          : "";
      String row = "${len - tileToRow(meta.move?.to ?? 0)}";
      String col = _colToChar(tileToCol(meta.move?.to ?? 0));
      move =
          "${_pieceToChar(meta.type ?? ChessPieceType.promotion)}"
              "$ambiguity$takeString$col$row$promotion";
    }
    String check = meta.isCheck ? "+" : "";
    String checkmate = meta.isCheckmate && !meta.isStalemate ? "#" : "";
    return "$move$check$checkmate";
  }

  String _pieceToChar(ChessPieceType type) {
    switch (type) {
      case ChessPieceType.king:
        {
          return "K";
        }
      case ChessPieceType.queen:
        {
          return "Q";
        }
      case ChessPieceType.rook:
        {
          return "R";
        }
      case ChessPieceType.bishop:
        {
          return "B";
        }
      case ChessPieceType.knight:
        {
          return "N";
        }
      case ChessPieceType.pawn:
        {
          return "";
        }
      default:
        {
          return "?";
        }
    }
  }

  String _colToChar(int col) {
    return String.fromCharCode(baseChar + col);
  }
}
