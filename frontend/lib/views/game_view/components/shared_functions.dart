import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../../../exports.dart';

String getResult(GameModel gameModel) {
  if (gameModel.gameOver) {
    if (gameModel.stalemate || gameModel.draw) {
      return "Ничья";
    } else {
      if (gameModel.playerCount == 1) {
        if (gameModel.isAIsTurn) {
          return "Победа";
        } else {
          return "Поражение";
        }
      } else {
        if (gameModel.turn == Player.player1) {
          return "Победа чёрных";
        } else {
          return "Победа белых";
        }
      }
    }
  }
  else {
    if (gameModel.playerCount == 1) {
      return "Поражение";
    }
    else {
      return "Ничья";
    }
  }

}

List<String> getPartyData(GameModel gameModel) {
  String enemy = PartyHistoryConst.gameEnemies[gameModel.playerCount - 1];
  String formattedDate = DateFormat("dd.MM.yyyy").format(DateTime.now());
  String formattedTime = DateFormat.Hm().format(DateTime.now());
  String durationGame = _formatDuration(gameModel.durationOfGame);
  String result = getResult(gameModel);
  String color = gameModel.playerSide == Player.player1 ? "белые" : "чёрные";
  return [enemy, formattedDate, formattedTime, durationGame, result, color];
}

Future<void> addPartyToHistory(GameModel gameModel) async {
  var databasesPath = await getDatabasesPath();
  String path = "$databasesPath/parties.db";
  Database database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    await db.execute(PartyHistoryConst.dbCreateScript);
  });
  await database.rawInsert(
      PartyHistoryConst.dbInsertPartyScript, getPartyData(gameModel));

  await database.close();
}

String _formatDuration(Duration duration) {
  int hours = duration.inHours;
  String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return hours == 0 ? "$minutes:$seconds" : "$hours:$minutes:$seconds";
}
