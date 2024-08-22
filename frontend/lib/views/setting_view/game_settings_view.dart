import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:sqflite/sqflite.dart";
import "../../exports.dart";

class GameSettingsView extends StatefulWidget {
  
  const GameSettingsView(this.gameModel, {super.key});
  final GameModel gameModel;

  @override
  State<GameSettingsView> createState() => _GameSettingsViewState();
}

enum Enemy { computer, player }

enum PiecesColor { white, random, black }

enum LevelOfDifficulty { easy, medium, hard, personality }

class _GameSettingsViewState extends State<GameSettingsView>
    with TickerProviderStateMixin {
  Enemy enemy = Enemy.computer;
  Player piecesColor = Player.random;
  LevelOfDifficulty gameMode = LevelOfDifficulty.easy;
  LevelOfDifficulty personalityGameMode = LevelOfDifficulty.easy;
  bool isLoading = true;
  bool isDBEmpty = false;
  bool withoutTime = true;
  bool isPersonality = false;
  bool isMoveBack = true;
  bool isThreats = false;
  bool isHints = false;
  int countOfTabs = 2;
  int durationOfGame = 15;
  int addingOfMove = 0;
  bool isSettingsEdited = false;
  late String path;

  void setEnemy(int chose) {
    setState(() {
      isSettingsEdited = true;
      enemy = Enemy.values[chose];
      widget.gameModel.setPlayerCount(chose + 1);
    });
  }

  void setPiecesColor(int chose) {
    setState(() {
      isSettingsEdited = true;
      piecesColor = Player.values[chose];
      widget.gameModel.setPlayerSide(piecesColor);
    });
  }

  void setIsTime(int chose) {
    setState(() {
      isSettingsEdited = true;
      withoutTime = chose == 0;
      if (withoutTime) {
        widget.gameModel.setTimeLimit(0);
      }
      else {
        widget.gameModel.setTimeLimit(durationOfGame);
      }
    });
  }

  void setGameMode(int chose) {
    setState(() {
      isSettingsEdited = true;
      gameMode = LevelOfDifficulty.values[chose];
      if (!isPersonality) {
        widget.gameModel.setAIDifficulty(
          GameSettingConsts.difficultyLevels[gameMode]
        );
      }
      else {
        widget.gameModel.setAIDifficulty(
          GameSettingConsts.difficultyLevels[personalityGameMode]
        );
      }
    });
  }

  void setPersonalityGameMode(int chose) {
    setState(() {
      isSettingsEdited = true;
      personalityGameMode = LevelOfDifficulty.values[chose];
      widget.gameModel.setAIDifficulty(
        GameSettingConsts.difficultyLevels[personalityGameMode]
      );
    });
  }

  void setMinutes(chose) {
    setState(() {
      if(!withoutTime) {
        widget.gameModel.setTimeLimit(chose);
      }
      isSettingsEdited = true;
      durationOfGame = chose;
    });
  }

  void setSeconds(chose) {
    setState(() {
      isSettingsEdited = true;
      addingOfMove = chose == GameSettingConsts.longDashSymbol ? 0 : chose;
      widget.gameModel.setAddingOnMove(addingOfMove);
    });
  }

  void setIsPersonality(bool chose) {
    setState(() {
      isSettingsEdited = true;
      isPersonality = chose;
      widget.gameModel.setIsPersonalityMode(chose);
    });
  }

  void setAdditionSettings(int index) {
    if (index < 3) {
      setState(() {
        setIsMoveBack(index < 2);
        setIsThreats(index == 0);
        setIsHints(index == 0);
      });
    }
  }

  void setIsMoveBack(bool chose) {
    setState(() {
      isSettingsEdited = true;
      isMoveBack = chose;
      widget.gameModel.setAllowUndoRedo(chose);
    });
  }

  void setIsThreats(bool chose) {
    setState(() {
      isSettingsEdited = true;
      isThreats = chose;
    });
  }

  void setIsHints(bool chose) {
    setState(() {
      isSettingsEdited = true;
      isHints = chose;
      widget.gameModel.setShowHint(chose);
    });
  }

  Future<void> getSettings() async {
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(GameSettingConsts.dbCreateScript);
        });
    List<Map> list =
    await database.rawQuery(GameSettingConsts.dbGetSettingsScript);

    if (list.isNotEmpty) {
      Map data = list.first;
      setEnemy(data["withComputer"]);
      setPiecesColor(data["colorPieces"]);
      setIsTime(data["withoutTime"]);
      setMinutes(data["durationGame"]);
      setSeconds(data["addingOnMove"]);
      setIsPersonality(data["isPersonality"] == 0);
      if (isPersonality) {
        setPersonalityGameMode(data["levelOfDifficulty"]);
        setGameMode(3);
      } else {
        setGameMode(data["levelOfDifficulty"]);
      }
      setIsMoveBack(data["isMoveBack"] == 0);
      setIsThreats(data["isThreats"] == 0);
      setIsHints(data["isHints"] == 0);
      setState(() {
        isDBEmpty = true;
      });
    }
    else {
      widget.gameModel.setTimeLimit(0);
    }

    await database.close();
  }

  Future<void> setSettings() async {
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(GameSettingConsts.dbCreateScript);
        });
    List<int> updatedSettings = [
      enemy.index,
      piecesColor.index,
      withoutTime ? 0 : 1,
      durationOfGame,
      addingOfMove,
      isPersonality ? personalityGameMode.index : gameMode.index,
      isPersonality ? 0 : 1,
      isMoveBack ? 0 : 1,
      isThreats ? 0 : 1,
      isHints ? 0 : 1
    ];

    if (isDBEmpty) {
      await database.rawUpdate(
          GameSettingConsts.dbUpdateSettingsScript, updatedSettings);
    } else {
      await database.rawInsert(
          GameSettingConsts.dbSetSettingsScript, updatedSettings);
    }

    await database.close();
  }

  void onInit() async {
    var databasesPath = await getDatabasesPath();
    String p = "$databasesPath/settings.db";
    setState(() {
      path = p;
    });
    await getSettings();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return isLoading
        ? const LoadingWidget()
        : DefaultTabController(
          length: countOfTabs,
          child: Scaffold(
            backgroundColor: scheme.background,
            body: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width,
                          minHeight: MediaQuery.of(context).size.height
                      ),
                      child: IntrinsicHeight(
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 24, right: 24, top: 24
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AppBarSettings(
                                  label: GameSettingConsts.appBarLabel
                              ),
                      
                              CustomTabBar(
                                initialIndex: enemy.index,
                                header: GameSettingConsts.gameModeText,
                                subTitles: [
                                  GameSettingConsts.gameWithComputerText,
                                  GameSettingConsts.gameWithHumanText,
                                ],
                                isSettingsPage: true,
                                onTap: setEnemy,
                              ),
                              enemy == Enemy.computer ?
                                ChoseColorWidget(
                                  piecesColor: piecesColor,
                                  onTap: (player) {
                                    setPiecesColor(player.index);
                                  },
                                ) : const SizedBox(),
                      
                              CustomTabBar(
                                initialIndex: withoutTime ? 0 : 1,
                                header: GameSettingConsts.timeText,
                                subTitles: [
                                  GameSettingConsts.gameWithoutTimeText,
                                  GameSettingConsts.gameWithTimeText,
                                ],
                                isSettingsPage: true,
                                onTap: setIsTime,
                              ),
                      
                              !withoutTime
                                  ? Column(
                                children: [
                                  ChoseTimeCarousel(
                                    values: GameSettingConsts
                                        .listOfDurations,
                                    type: "minutes",
                                    header: GameSettingConsts
                                        .minutesSubtitle,
                                    startValue:durationOfGame,
                                    onChanged: setMinutes,
                                  ),
                                  ChoseTimeCarousel(
                                    values: GameSettingConsts
                                        .listOfAdditions,
                                    type: "seconds",
                                    header: GameSettingConsts
                                        .secondsSubtitle,
                                    startValue: addingOfMove == 0
                                        ? GameSettingConsts.longDashSymbol
                                        : addingOfMove,
                                    onChanged: setSeconds,
                                  ),
                                ],
                              )
                                  : const SizedBox(),
                              enemy == Enemy.computer
                                  ? Column(
                                children: [
                                  TextHeading(
                                    text: GameSettingConsts
                                        .levelDifficultyText,
                                    topMargin: 32,
                                    bottomMargin: 16,
                                  ),
                                  Column(
                                    children: List.generate(
                                      LevelOfDifficulty.values
                                         .length, (index) {
                                        return ChoseDifficultyButton(
                                          level: LevelOfDifficulty
                                              .values[index],
                                          countOfIcons: (index + 1) %
                                              LevelOfDifficulty.values.length,
                                          currentLevel: gameMode,
                                          personalityLevel:
                                          personalityGameMode,
                                          onTap: () {
                                            setIsPersonality(index == 3);
                                            setGameMode(index);
                                            setAdditionSettings(index);
                                          },
                                        );
                                      })),
                                ],
                              )
                                  : const SizedBox(),
                              enemy == Enemy.computer && isPersonality
                                  ? Column(
                                children: [
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  SettingsRow(
                                    text: GameSettingConsts
                                        .personalLevelDifficultyText,
                                    modalText: ModalStrings
                                        .choseDiffModalText,
                                    modalHeader: GameSettingConsts
                                        .choseDiffModalHeader,
                                    initValue: personalityGameMode,
                                    isChoseDiff: true,
                                    onChose: (value) {
                                      setPersonalityGameMode(value!.index);
                                    },
                                  ),
                                  SettingsRow(
                                    chose: isMoveBack,
                                    text: GameSettingConsts
                                        .moveBackText,
                                    modalText: ModalStrings
                                        .moveBackModalText,
                                    modalHeader: GameSettingConsts
                                        .moveBackText,
                                    isChoseDiff: false,
                                    onChanged: setIsMoveBack,
                                  ),
                                  SettingsRow(
                                    chose: isThreats,
                                    text:
                                    GameSettingConsts.threatsText,
                                    modalText:
                                    ModalStrings.threatsModalText,
                                    modalHeader:
                                    GameSettingConsts.threatsText,
                                    isChoseDiff: false,
                                    onChanged: setIsThreats,
                                  ),
                                  SettingsRow(
                                    chose: isHints,
                                    text: GameSettingConsts.hintsText,
                                    modalText:
                                    ModalStrings.hintsModalText,
                                    modalHeader:
                                    GameSettingConsts.hintsText,
                                    isChoseDiff: false,
                                    onChanged: setIsHints,
                                  ),
                                ],
                              )
                                  : const SizedBox(),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: scheme.background,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 15, bottom: 23, left: 23, right: 23
                        ),
                        child: NextPageButton(
                          text: GameSettingConsts.startGameText,
                          textColor: ColorsConst.primaryColor0,
                          buttonColor: scheme.secondaryContainer,
                          isClickable: true,
                          onTap: () async {
                            if (isSettingsEdited || !isDBEmpty) {
                              await setSettings();
                            }
                            if (!context.mounted) return;
                            widget.gameModel.newGame(context, notify: false);
                            context.go(RouteLocations.gameScreen,
                                extra: widget.gameModel);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
  }
}
