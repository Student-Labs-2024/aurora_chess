import "package:dartchess/dartchess.dart";
import "../model/game_model.dart";
import "../views/game_view/game_view.dart";
import "chess_piece.dart";
import "move_calculation/move_classes/move_meta.dart";
import "shared_functions.dart";


Setup setup = Setup.parseFen(GamePageConst.startPos);
Chess pos = Chess.fromSetup(setup);
int _len = 8;
int baseChar = 97;

String updatePos(MoveMeta meta, GameModel gameModel) {
  String currentPos = gameModel.lastPos;
  String lastPos = "";

  Chess pos = Chess.fromSetup(Setup.parseFen(currentPos));
  String strMove = _moveToString(meta, gameModel);
  Move? move = Move.fromUci(strMove);

  if (move != null) {
    if (pos.isLegal(move)) {
      Position<Chess> newPos = pos.play(move);
      lastPos = newPos.fen;
      gameModel.posList.add(lastPos);
    }
  }
  return lastPos;
}

String _moveToString(MoveMeta meta, GameModel gameModel) {
  String move;
  int fromTile = meta.move!.from;
  int toTile = meta.move!.to;
  if ((meta.queenCastle || meta.kingCastle) && meta.type == ChessPieceType.rook) {
    int buf = fromTile;
    fromTile = toTile;
    toTile = buf;
  }
  String promotion = meta.promotion
    ? pieceToChar(meta.promotionType ?? ChessPieceType.promotion) : "";

  String strMove = "${intToTile(fromTile, gameModel, true)}${intToTile(toTile, gameModel, true)}";
  move = "$strMove$promotion";

  return move;
}

bool checkDraw(GameModel gameModel, String lastPos) {
  if (gameModel.posList.length < 3) {
    return false;
  }

  if (checkCountInvite(gameModel.posList)) {
    return true;
  }

  List<String> list = lastPos.split(" ");
  if (list[list.length - 2] == "50") {
    return true;
  }

  Chess pos = Chess.fromSetup(Setup.parseFen(lastPos));
  if (pos.isInsufficientMaterial) {
    return true;
  }

  return false;
}

bool checkCountInvite(List<String> posList) {
  List<String> onlyPosList = [];
  for (var element in posList) {
    onlyPosList.add(element.split(" ").first);
  }
  var map = {};

  for (var element in onlyPosList) {

    if(!map.containsKey(element)) {
      map[element] = 1;
    } else {
      map[element] += 1;
    }
  }
  if (map.values.contains(3)) {
    return true;
  }

  return false;
}

String intToTile(int tile, GameModel gameModel, bool isDartChess) {
  String row;
  String col;

  if (gameModel.playerCount == 1 && gameModel.playerSide == Player.player2 && !isDartChess) {
    col = GamePageConst.listOfColumns[tile % _len];
    row = ((tile / _len).floor() + 1).toString();
  }
  else {
    row = "${_len - tileToRow(tile)}";
    col = colToChar(tileToCol(tile));
  }
  return "$col$row";
}

String colToChar(int col) {
  return String.fromCharCode(baseChar + col);
}

String pieceToChar(ChessPieceType type) {
  switch (type) {
    case ChessPieceType.king:
      {
        return "k";
      }
    case ChessPieceType.queen:
      {
        return "q";
      }
    case ChessPieceType.rook:
      {
        return "r";
      }
    case ChessPieceType.bishop:
      {
        return "b";
      }
    case ChessPieceType.knight:
      {
        return "n";
      }
    case ChessPieceType.pawn:
      {
        return "";
      }
    default:
      {
        return "";
      }
  }
}
