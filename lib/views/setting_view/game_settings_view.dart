import 'package:frontend/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../exports.dart';
import 'package:sqflite/sqflite.dart';

class GameSettingsView extends StatefulWidget {
  const GameSettingsView({super.key});

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
  int durationOfGame = 30;
  int addingOfMove = 10;
  bool isSettingsEdited = false;
  late String path;
  late TabController _tabColorController;
  late TabController _tabTimeController;

  void setEnemy(int chose) {
    setState(() {
      isSettingsEdited = true;
      enemy = Enemy.values[chose];
    });
  }

  void setPiecesColor(int chose) {
    setState(() {
      isSettingsEdited = true;
      piecesColor = Player.values[chose];
    });
  }

  void setIsTime(int chose) {
    setState(() {
      isSettingsEdited = true;
      withoutTime = chose == 0;
    });
  }

  void setGameMode(int chose) {
    setState(() {
      isSettingsEdited = true;
      gameMode = LevelOfDifficulty.values[chose];
    });
  }

  void setPersonalityGameMode(int chose) {
    setState(() {
      isSettingsEdited = true;
      personalityGameMode = LevelOfDifficulty.values[chose];
    });
  }

  void setMinutes(chose) {
    setState(() {
      isSettingsEdited = true;
      durationOfGame = chose;
    });
  }

  void setSeconds(chose) {
    setState(() {
      isSettingsEdited = true;
      addingOfMove = chose;
    });
  }

  void setIsPersonality(bool chose) {
    setState(() {
      isSettingsEdited = true;
      isPersonality = chose;
    });
  }

  void setIsMoveBack(bool chose) {
    setState(() {
      isSettingsEdited = true;
      isMoveBack = chose;
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
    });
  }

  Future<void> getSettings() async {
    Database database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(GameSettingConsts.dbCreateScript);
      }
    );
    List<Map> list = await database.rawQuery(
      GameSettingConsts.dbGetSettingsScript
    );

    print(list);

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
      }
      else {
        setGameMode(data["levelOfDifficulty"]);
      }
      setIsMoveBack(data["isMoveBack"] == 0);
      setIsThreats(data["isThreats"] == 0);
      setIsHints(data["isHints"] == 0);
      setState(() {
        isDBEmpty = true;
      });
    }

    await database.close();
  }

  Future<void> setSettings() async {
    Database database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(GameSettingConsts.dbCreateScript);
      }
    );
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
      int count = await database.rawUpdate(
        GameSettingConsts.dbUpdateSettingsScript,
        updatedSettings
      );
      print("update: $count");
    }
    else {
      int id = await database.rawInsert(
        GameSettingConsts.dbSetSettingsScript,
        updatedSettings
      );
      print("insert: $id");
    }

    await database.close();
  }

  void onInit() async {
    var databasesPath = await getDatabasesPath();
    String p = '$databasesPath/settings.db';
    setState(() {
      path = p;
    });
    await getSettings();

    _tabColorController = TabController(
      length: 2, vsync: this, initialIndex: enemy.index
    );
    _tabTimeController = TabController(
      length: 2, vsync: this, initialIndex: withoutTime ? 0 : 1
    );

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
    var scheme = Theme.of(context).colorScheme;
    return isLoading ?
    const LoadingWidget() :
      Consumer<AppModel>(
      builder: (context, appModel, child) {
        return DefaultTabController(
          length: countOfTabs,
          child: Scaffold(
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width,
                      minHeight: MediaQuery.of(context).size.height
                    ),
                    child: IntrinsicHeight(
                      child: Container(
                        margin:
                          const EdgeInsets.only(left: 24, right: 24, top: 55),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AppBarSettings(label: GameSettingConsts.appBarLabel),
                            TextHeading(
                              text: GameSettingConsts.gameModeText,
                              topMargin: 32,
                              bottomMargin: 16,
                            ),
                            PreferredSize(
                              preferredSize: const Size.fromHeight(44),
                              child: ClipRRect(
                                borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                                child: Container(
                                  height: 44,
                                  padding: const EdgeInsets.all(4),
                                  decoration: ShapeDecoration(
                                    color: scheme.outline,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: TabBar(
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    dividerColor: Colors.transparent,
                                    indicator: const BoxDecoration(
                                      color: ColorsConst.primaryColor100,
                                      borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    ),
                                    controller: _tabColorController,
                                    onTap: (index) {
                                      setState(() {
                                        final playerCount = index + 1;
                                        appModel.setPlayerCount(playerCount);
                                        setEnemy(index);
                                      });
                                    },
                                    labelPadding: EdgeInsets.zero,
                                    unselectedLabelColor:
                                      ColorsConst.neutralColor300,
                                    tabs: [
                                      TabItem(
                                        title: GameSettingConsts.gameWithComputerText,
                                        index: 0,
                                        currentIndex: _tabColorController.index,
                                      ),
                                      TabItem(
                                        title: GameSettingConsts.gameWithHumanText,
                                        index: 1,
                                        currentIndex: _tabColorController.index,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            TextHeading(
                              text: GameSettingConsts.colorPiecesText,
                              topMargin: 32,
                              bottomMargin: 16,
                            ),
                            Row(
                              children: [
                                ColorChoseButton(
                                  variant: Player.player1,
                                  chose: piecesColor,
                                  onTap: () {
                                    appModel.setPlayerSide(Player.player1);
                                    setPiecesColor(0);
                                  },
                                ),
                                const SizedBox(
                                  width: 11,
                                ),
                                ColorChoseButton(
                                  variant: Player.random,
                                  chose: piecesColor,
                                  onTap: () {
                                    appModel.setPlayerSide(Player.random);
                                    setPiecesColor(1);
                                  },
                                ),
                                const SizedBox(
                                  width: 11,
                                ),
                                ColorChoseButton(
                                  variant: Player.player2,
                                  chose: piecesColor,
                                  onTap: () {
                                    appModel.setPlayerSide(Player.player2);
                                    setPiecesColor(2);
                                  },
                                ),
                              ],
                            ),
                            TextHeading(
                              text: GameSettingConsts.timeText,
                              topMargin: 32,
                              bottomMargin: 16,
                            ),
                            PreferredSize(
                              preferredSize: const Size.fromHeight(44),
                              child: ClipRRect(
                                borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                                child: Container(
                                  height: 44,
                                  padding: const EdgeInsets.all(4),
                                  decoration: ShapeDecoration(
                                    color: scheme.outline,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: TabBar(
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    dividerColor: Colors.transparent,
                                    controller: _tabTimeController,
                                    indicator: const BoxDecoration(
                                      color: ColorsConst.primaryColor100,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    onTap: (index) {
                                      setIsTime(index);
                                      if (index == 0) {
                                        appModel.setTimeLimit(0);
                                      }
                                    },
                                    labelPadding: EdgeInsets.zero,
                                    unselectedLabelColor:
                                      ColorsConst.neutralColor300,
                                    tabs: [
                                      TabItem(
                                        title: GameSettingConsts.gameWithoutTimeText,
                                        index: 0,
                                        currentIndex: _tabTimeController.index,
                                      ),
                                      TabItem(
                                        title: GameSettingConsts.gameWithTimeText,
                                        index: 1,
                                        currentIndex: _tabTimeController.index,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            !withoutTime
                              ? Column(
                                children: [
                                  ChoseTimeCarousel(
                                    values: GameSettingConsts.listOfDurations,
                                    type: 'minutes',
                                    header: GameSettingConsts.minutesSubtitle,
                                    startValue: durationOfGame,
                                    onChanged: setMinutes,
                                  ),
                                  ChoseTimeCarousel(
                                    values: GameSettingConsts.listOfAdditions,
                                    type: 'seconds',
                                    header: GameSettingConsts.secondsSubtitle,
                                    startValue: addingOfMove,
                                    onChanged: setSeconds,
                                  ),
                                ],
                              ) : const SizedBox(),
                            enemy == Enemy.computer
                              ? Column(
                                children: [
                                  TextHeading(
                                    text: GameSettingConsts.levelDifficultyText,
                                    topMargin: 32,
                                    bottomMargin: 16,
                                  ),
                                  Column(
                                    children: List.generate(LevelOfDifficulty.values.length, (index) {
                                      return ChoseDifficultyButton(
                                        level: LevelOfDifficulty.values[index],
                                        countOfIcons: (index + 1) % 4,
                                        currentLevel: gameMode,
                                        personalityLevel: personalityGameMode,
                                        onTap: () {
                                          GameSettingConsts.difficultyLevels[
                                            index == 3 ? personalityGameMode
                                            : LevelOfDifficulty.values[index]
                                          ];
                                          setIsPersonality(index == 3);
                                          setGameMode(index);
                                        },
                                      );
                                    })
                                  ),
                                ],
                              ) : const SizedBox(),
                            enemy == Enemy.computer && isPersonality
                              ? Column(
                                children: [
                                  const SizedBox(height: 16,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "$personalityGameMode",
                                        style: TextStyle(
                                          color: scheme.primary,
                                          fontSize: 16,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setPersonalityGameMode((personalityGameMode.index + 1) % 3);
                                        },
                                        icon: const Icon(Icons.add, size: 30,)
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 8,),
                                  SettingsRow(
                                    chose: isMoveBack,
                                    text: GameSettingConsts.moveBackText,
                                    modalText: ModalStrings.moveBackModalText,
                                    modalHeader: GameSettingConsts.moveBackText,
                                    onChanged: (chose) {
                                      setIsMoveBack(chose);
                                      setState(() {
                                        appModel.setAllowUndoRedo(chose);
                                      });
                                    },
                                  ),
                                  SettingsRow(
                                    chose: isThreats,
                                    text: GameSettingConsts.threatsText,
                                    modalText: ModalStrings.threatsModalText,
                                    modalHeader: GameSettingConsts.threatsText,
                                    onChanged: setIsThreats,
                                  ),
                                  SettingsRow(
                                    chose: isHints,
                                    text: GameSettingConsts.hintsText,
                                    modalText: ModalStrings.hintsModalText,
                                    modalHeader: GameSettingConsts.hintsText,
                                    onChanged: setIsHints,
                                  ),
                                ],
                            ) : const SizedBox(),
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
                      padding: const EdgeInsets.only(top: 15, bottom: 23, left: 23, right: 23),
                      child: NextPageButton(
                        text: GameSettingConsts.startGameText,
                        textColor: ColorsConst.primaryColor0,
                        buttonColor: scheme.secondaryContainer,
                        isClickable: true,
                        onTap: () async {
                          if (isSettingsEdited || !isDBEmpty) {
                            await setSettings();
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                appModel.newGame(context, notify: false);
                                return GameView(appModel);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
