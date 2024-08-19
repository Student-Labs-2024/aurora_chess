import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";
import "package:sqflite/sqflite.dart";
import "../../../../exports.dart";

class RestartExitButtons extends StatelessWidget {
  final GameModel gameModel;
  final bool isHints;

  const RestartExitButtons(this.gameModel, this.isHints, {super.key});

  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return hours == 0 ? "$minutes:$seconds" : "$hours:$minutes:$seconds";
  }

  String getResult() {
    if (gameModel.stalemate) {
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

  List<String> _getPartyData() {
    String enemy = PartyHistoryConst.gameEnemies[gameModel.playerCount - 1];
    String formattedDate = DateFormat("dd.MM.yyyy").format(DateTime.now());
    String formattedTime = DateFormat.Hm().format(DateTime.now());
    int firstTimeLeft = Duration(minutes: gameModel.timeLimit).inSeconds
        - gameModel.player1TimeLeft.inSeconds;
    int secondTimeLeft = Duration(minutes: gameModel.timeLimit).inSeconds
        - gameModel.player2TimeLeft.inSeconds;
    Duration duration = Duration(seconds: (firstTimeLeft + secondTimeLeft));
    String durationGame = _formatDuration(duration);
    String result = getResult();
    String color = gameModel.turn == Player.player1 ? "чёрные" : "белые";
    return [enemy, formattedDate, formattedTime, durationGame, result, color];
  }

  Future<void> _addPartyToHistory() async {
    var databasesPath = await getDatabasesPath();
    String path = "$databasesPath/parties.db";
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(PartyHistoryConst.dbCreateScript);
        });
    await database.rawInsert(PartyHistoryConst.dbInsertPartyScript, _getPartyData());

    await database.close();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: IconButton(
            icon: SvgPicture.asset(
              GamePageConst.menuIcon,
              colorFilter: ColorFilter.mode(scheme.primary, BlendMode.srcIn),
            ),
            highlightColor: Colors.white.withOpacity(0.3),
            onPressed: () async {
              if (gameModel.gameOver) {
                await _addPartyToHistory();
              }
              gameModel.exitChessView();
              if (!context.mounted) return;
              context.go(RouteLocations.settingsScreen);
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: IconButton(
            icon: SvgPicture.asset(
              GamePageConst.lampIcon,
              colorFilter: ColorFilter.mode(
                (isHints || gameModel.playerCount == 2)
                    ? scheme.primary : scheme.onError,
                BlendMode.srcIn
              ),
            ),
            highlightColor: Colors.white.withOpacity(0.3),
            onPressed: (isHints || gameModel.playerCount == 2) ? () {
              gameModel.game!.aiHint();
            } : null,
          ),
        ),
      ],
    );
  }
}
