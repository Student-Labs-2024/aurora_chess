import "../exports.dart";

int tileToRow(int tile) {
  return (tile / LogicConsts.lenOfRow).floor();
}

int tileToCol(int tile) {
  return tile % LogicConsts.lenOfRow;
}

double getXFromTile(int tile, double tileSize, GameModel gameModel) {
  return gameModel.flip &&
          gameModel.playingWithAI &&
          gameModel.playerSide == Player.player2
      ? ((LogicConsts.lenOfRow - 1) - tileToCol(tile)) * tileSize
      : tileToCol(tile) * tileSize;
}

double getYFromTile(int tile, double tileSize, GameModel gameModel) {
  return gameModel.flip &&
          gameModel.playingWithAI &&
          gameModel.playerSide == Player.player2
      ? ((LogicConsts.lenOfRow - 1) - tileToRow(tile)) * tileSize
      : tileToRow(tile) * tileSize;
}

Player oppositePlayer(Player player) {
  return player == Player.player1 ? Player.player2 : Player.player1;
}

String formatPieceTheme(String themeString) {
  return themeString.toLowerCase().replaceAll(" ", "");
}

String pieceTypeToString(ChessPieceType type) {
  return type.toString().substring(type.toString().indexOf(".") + 1);
}
