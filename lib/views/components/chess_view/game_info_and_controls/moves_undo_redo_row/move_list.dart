import 'package:frontend/logic/chess_piece.dart';
import 'package:frontend/logic/move_calculation/move_classes/move_meta.dart';
import 'package:frontend/logic/shared_functions.dart';
import 'package:frontend/model/app_model.dart';
import 'package:frontend/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:frontend/views/components/shared/text_variable.dart';
import 'package:flutter/material.dart';

class MoveList extends StatelessWidget {
  final AppModel appModel;
  final ScrollController scrollController = ScrollController();

  MoveList(this.appModel);

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Container(
      height: 60,
      decoration: BoxDecoration(
        //borderRadius: BorderRadius.all(Radius.circular(15)),
        color: scheme.surfaceTint,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Center(child: TextRegular(_allMoves())),
      ),
    );
  }

  void _scrollToBottom() {
    if (appModel.moveListUpdated) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      appModel.moveListUpdated = false;
    }
  }

  String _allMoves() {
    var moveString = '';
    appModel.moveMetaList.asMap().forEach((index, move) {
      var turnNumber = ((index + 1) / 2).ceil();
      if (index % 2 == 0) {
        moveString += index == 0 ? '$turnNumber. ' : '   $turnNumber. ';
      }
      moveString += _moveToString(move);
      if (index % 2 == 0) {
        moveString += ' ';
      }
    });
    if (appModel.gameOver) {
      if (appModel.turn == Player.player1) {
        moveString += ' ';
      }
      if (appModel.stalemate) {
        moveString += '  ½-½';
      } else {
        moveString += appModel.turn == Player.player2 ? '  1-0' : '  0-1';
      }
    }
    return moveString;
  }

  String _moveToString(MoveMeta meta) {
    String move;
    if (meta.kingCastle) {
      move = 'O-O';
    } else if (meta.queenCastle) {
      move = 'O-O-O';
    } else {
      String ambiguity = meta.rowIsAmbiguous
          ? '${_colToChar(tileToCol(meta.move?.from ?? 0))}'
          : '';
      ambiguity +=
          meta.colIsAmbiguous ? '${8 - tileToRow(meta.move?.from ?? 0)}' : '';
      String takeString = meta.took ? 'x' : '';
      String promotion = meta.promotion
          ? '=${_pieceToChar(meta.promotionType ?? ChessPieceType.promotion)}'
          : '';
      String row = '${8 - tileToRow(meta.move?.to ?? 0)}';
      String col = '${_colToChar(tileToCol(meta.move?.to ?? 0))}';
      move =
          '${_pieceToChar(meta.type ?? ChessPieceType.promotion)}$ambiguity$takeString' +
              '$col$row$promotion';
    }
    String check = meta.isCheck ? '+' : '';
    String checkmate = meta.isCheckmate && !meta.isStalemate ? '#' : '';
    return move + '$check$checkmate';
  }

  String _pieceToChar(ChessPieceType type) {
    switch (type) {
      case ChessPieceType.king:
        {
          return 'K';
        }
      case ChessPieceType.queen:
        {
          return 'Q';
        }
      case ChessPieceType.rook:
        {
          return 'R';
        }
      case ChessPieceType.bishop:
        {
          return 'B';
        }
      case ChessPieceType.knight:
        {
          return 'N';
        }
      case ChessPieceType.pawn:
        {
          return '';
        }
      default:
        {
          return '?';
        }
    }
  }

  String _colToChar(int col) {
    return String.fromCharCode(97 + col);
  }
}
