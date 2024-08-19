import "package:flutter/material.dart";
import "../../../../exports.dart";

class MoveList extends StatelessWidget {
  final GameModel gameModel;
  final ScrollController scrollController = ScrollController();

  MoveList(this.gameModel, {super.key});

  final int len = 8;
  final int baseChar = 97;
  final String pieceName = "assets/images/pieces/";

  @override
  Widget build(BuildContext context) {

    final scheme = Theme.of(context).colorScheme;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Container(
      height: 40,
      margin: const EdgeInsets.only(top: 7, bottom: 16),
      decoration: BoxDecoration(
        color: scheme.onInverseSurface,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        padding: const EdgeInsets.only(right: 24),
        child: Row(
          children: List.generate(gameModel.moveMetaList.length, (index) {
            final MoveMeta move = gameModel.moveMetaList[index];
            return Row(
              children: [
                index % 2 == 0 ?
                Row(
                  children: [
                    const SizedBox(width: 24,),
                    Text(
                      "${((index + 1) / 2).ceil().toString()}.",
                      style: TextStyle(
                        color: scheme.error,
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                    ),
                  ],
                ) : const SizedBox(width: 4,),
                const SizedBox(width: 4,),
                move.type != ChessPieceType.promotion ?
                  Row(
                    children: [
                      Image.asset(
                        "$pieceName${move.type!.name}_"
                            "${PiecesColor.values[move.player!.index].name}.png",
                        width: 22,
                      ),
                      const SizedBox(width: 4,)
                    ],
                  ) : const SizedBox(),
                Text(
                  _moveToString(move),
                  style: TextStyle(
                    color: move.player!.index == 0
                        ? ColorsConst.primaryColor0
                        : ColorsConst.neutralColor300,
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                )
              ],
            );
          }),
        )
      ),
    );
  }

  void _scrollToBottom() {
    if (gameModel.moveListUpdated) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      gameModel.moveListUpdated = false;
    }
  }

  String _moveToString(MoveMeta meta) {
    String move;
    if (meta.kingCastle) {
      move = "O-O";
    } else if (meta.queenCastle) {
      move = "O-O-O";
    } else {
      String takeString = meta.took ? "x" : "";
      String promotion = meta.promotion
          ? "=${_pieceToChar(meta.promotionType ?? ChessPieceType.promotion)}"
          : "";
      String tile = _intToTile(meta.move!.to, len);
      move = "$takeString$tile$promotion";
    }
    String check = meta.isCheck ? "+" : "";
    String checkmate = meta.isCheckmate && !meta.isStalemate ? "#" : "";
    return "$move$check$checkmate";
  }

  String _intToTile(int tile, int len) {
    String row;
    String col;
    if (gameModel.playerCount == 1 && gameModel.playerSide == Player.player2) {
      col = GamePageConst.listOfColumns[tile % len];
      row = ((tile / len).floor() + 1).toString();
    }
    else {
      row = "${len - tileToRow(tile)}";
      col = _colToChar(tileToCol(tile));
    }
    return "$col$row";
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
