import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";
import "package:sqflite/sqflite.dart";
import "../../exports.dart";

class GameView extends StatefulWidget {
  final GameModel gameModel;

  const GameView(this.gameModel, {super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  bool isLoading = true;

  Future<Map> _getSettings() async {
    var databasesPath = await getDatabasesPath();
    String path = "$databasesPath/settings.db";
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(GameSettingConsts.dbCreateScript);
    });
    List<Map> list =
        await database.rawQuery(GameSettingConsts.dbGetSettingsScript);

    return list.first;
  }

  void _setSettings() async {
    Map data = await _getSettings();
    widget.gameModel.setPlayerCount(data["withComputer"] + 1);
    widget.gameModel.setPlayerSide(Player.values[data["colorPieces"]]);
    widget.gameModel.setTimeLimit(data["durationGame"]);
    widget.gameModel.setAIDifficulty(GameSettingConsts
        .difficultyLevels[LevelOfDifficulty.values[data["levelOfDifficulty"]]]);
    await widget.gameModel.setAllowUndoRedo(data["isMoveBack"] == 0);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _setSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return isLoading
        ? const LoadingWidget()
        : SafeArea(
            child: Scaffold(
              backgroundColor: scheme.background,
              body: Consumer<GameModel>(
                builder: (context, gameModel, child) {
                  return WillPopScope(
                    onWillPop: _willPopCallback,
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MoveList(gameModel),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 30,
                              ),
                              child: SizedBox(
                                height: 30,
                                child: Stack(
                                  children: [
                                    CustomIconButton(
                                      iconName:
                                          "assets/images/icons/left_big_arrow_icon.svg",
                                      color: scheme.secondary,
                                      iconSize: 32,
                                      onTap: () {
                                        context
                                            .go(RouteLocations.settingsScreen);
                                      },
                                    ),
                                    const GameStatus(),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const TextRegular('Робот'),
                                  Expanded(child: Container()),
                                  TimerWidget(
                                    timeLeft: gameModel.player2TimeLeft,
                                    isFilled: gameModel.turn == Player.player2,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(30),
                                child: ChessBoardWidget(gameModel)),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const TextRegular('Игрок'),
                                  Expanded(child: Container()),
                                  TimerWidget(
                                    timeLeft: gameModel.player1TimeLeft,
                                    isFilled: gameModel.turn == Player.player1,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(30),
                              child: GameInfoAndControls(gameModel),
                            ),
                          ],
                        ),
                        gameModel.isPromotionForPlayer
                            ? Center(child: PieceChooseWindow(gameModel))
                            : Container()
                      ],
                    ),
                  );
                },
              ),
            ),
          );
  }

  Future<bool> _willPopCallback() async {
    widget.gameModel.exitChessView();

    return true;
  }
}
