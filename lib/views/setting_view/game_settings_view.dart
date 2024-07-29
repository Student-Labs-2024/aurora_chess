import 'package:frontend/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../exports.dart';

class GameSettingsView extends StatefulWidget {
  const GameSettingsView({super.key});

  @override
  State<GameSettingsView> createState() => _GameSettingsViewState();
}

enum Enemy { computer, player }
enum PiecesColor { black, white, random }
enum LevelOfDifficulty { easy, medium, hard }

class _GameSettingsViewState extends State<GameSettingsView>
    with TickerProviderStateMixin {
  Enemy enemy = Enemy.computer;
  Player piecesColor = Player.random;
  LevelOfDifficulty gameMode = LevelOfDifficulty.easy;
  bool withTime = true;
  bool isMoveBack = true;
  bool isThreats = false;
  bool isHints = false;
  int countOfTabs = 2;
  int durationOfGame = 30;
  int addingOfMove = 10;
  late TabController _tabColorController;
  late TabController _tabTimeController;

  void setPiecesColor(Player chose) {
    setState(() {
      piecesColor = chose;
    });
  }

  void setGameMode(LevelOfDifficulty chose) {
    setState(() {
      gameMode = chose;
    });
  }

  void setMinutes(chose) {
    setState(() {
      durationOfGame = chose;
    });
  }

  void setSeconds(chose) {
    setState(() {
      addingOfMove = chose;
    });
  }

  @override
  void initState() {
    _tabColorController = TabController(length: 2, vsync: this);
    _tabTimeController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return Consumer<AppModel>(
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
                            AppBarSettings(label: GameSettingStringConst.appBarLabel),
                            TextHeading(
                              text: GameSettingStringConst.gameModeText,
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
                                        enemy = index == 0
                                          ? Enemy.computer
                                          : Enemy.player;
                                      });
                                    },
                                    labelPadding: EdgeInsets.zero,
                                    unselectedLabelColor:
                                      ColorsConst.neutralColor300,
                                    tabs: [
                                      TabItem(
                                        title: GameSettingStringConst.gameWithComputerText,
                                        index: 0,
                                        currentIndex: _tabColorController.index,
                                      ),
                                      TabItem(
                                        title: GameSettingStringConst.gameWithHumanText,
                                        index: 1,
                                        currentIndex: _tabColorController.index,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            TextHeading(
                              text: GameSettingStringConst.colorPiecesText,
                              topMargin: 32,
                              bottomMargin: 16,
                            ),
                            Row(
                              children: [
                                ColorChoseButton(
                                  variant: Player.player1,
                                  chose: appModel.selectedSide,
                                  onTap: () {
                                    appModel.setPlayerSide(Player.player1);
                                    setPiecesColor(Player.player1);
                                  },
                                ),
                                const SizedBox(
                                  width: 11,
                                ),
                                ColorChoseButton(
                                  variant: Player.random,
                                  chose: appModel.selectedSide,
                                  onTap: () {
                                    appModel.setPlayerSide(Player.random);
                                    setPiecesColor(Player.random);
                                  },
                                ),
                                const SizedBox(
                                  width: 11,
                                ),
                                ColorChoseButton(
                                  variant: Player.player2,
                                  chose: appModel.selectedSide,
                                  onTap: () {
                                    appModel.setPlayerSide(Player.player2);
                                    setPiecesColor(Player.player2);
                                  },
                                ),
                              ],
                            ),
                            TextHeading(
                              text: GameSettingStringConst.timeText,
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
                                      setState(() {
                                        if (index == 0) {
                                          withTime = true;
                                        } else {
                                          withTime = false;
                                          appModel.setTimeLimit(0);
                                        }
                                      });
                                    },
                                    labelPadding: EdgeInsets.zero,
                                    unselectedLabelColor:
                                      ColorsConst.neutralColor300,
                                    tabs: [
                                      TabItem(
                                        title: GameSettingStringConst.gameWithTimeText,
                                        index: 0,
                                        currentIndex: _tabTimeController.index,
                                      ),
                                      TabItem(
                                        title: GameSettingStringConst.gameWithoutTimeText,
                                        index: 1,
                                        currentIndex: _tabTimeController.index,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            withTime
                              ? Column(
                                children: [
                                  ChoseTimeCarousel(
                                    values: GameSettingStringConst.listOfDurations,
                                    type: 'minutes',
                                    header: GameSettingStringConst.minutesSubtitle,
                                    startValue: durationOfGame,
                                    onChanged: setMinutes,
                                  ),
                                  ChoseTimeCarousel(
                                    values: GameSettingStringConst.listOfAdditions,
                                    type: 'seconds',
                                    header: GameSettingStringConst.secondsSubtitle,
                                    startValue: addingOfMove,
                                    onChanged: setSeconds,
                                  ),
                                ],
                              ) : const SizedBox(),
                            enemy == Enemy.computer
                              ? Column(
                                children: [
                                  TextHeading(
                                    text: GameSettingStringConst.levelDifficultyText,
                                    topMargin: 32,
                                    bottomMargin: 16,
                                  ),
                                  Column(
                                    children: List.generate(LevelOfDifficulty.values.length, (index) {
                                      return ChoseDifficultyButton(
                                        level: LevelOfDifficulty.values[index],
                                        countOfIcons: index + 1,
                                        currentLevel: gameMode,
                                        onTap: () {
                                          appModel.setAIDifficulty(3);
                                          setGameMode(LevelOfDifficulty.values[index]);
                                        },
                                      );
                                    })
                                  ),
                                ],
                              ) : const SizedBox(),
                            enemy == Enemy.computer
                              ? Column(
                                children: [
                                  TextHeading(
                                    text: GameSettingStringConst.additionalSettingsText,
                                    topMargin: 32,
                                    bottomMargin: 16,
                                  ),
                                  SettingsRow(
                                    chose: isMoveBack,
                                    text: GameSettingStringConst.moveBackText,
                                    modalText: ModalStrings.moveBackModalText,
                                    modalHeader: GameSettingStringConst.moveBackText,
                                    onChanged: (chose) {
                                      setState(() {
                                        appModel.setAllowUndoRedo(chose);
                                        isMoveBack = chose;
                                      });
                                    },
                                  ),
                                  SettingsRow(
                                    chose: isThreats,
                                    text: GameSettingStringConst.threatsText,
                                    modalText: ModalStrings.threatsModalText,
                                    modalHeader: GameSettingStringConst.threatsText,
                                    onChanged: (chose) {
                                      setState(() {
                                        isThreats = chose;
                                      });
                                    },
                                  ),
                                  SettingsRow(
                                    chose: isHints,
                                    text: GameSettingStringConst.hintsText,
                                    modalText: ModalStrings.hintsModalText,
                                    modalHeader: GameSettingStringConst.hintsText,
                                    onChanged: (chose) {
                                      setState(() {
                                        isHints = chose;
                                      });
                                    },
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
                        text: GameSettingStringConst.startGameText,
                        textColor: ColorsConst.primaryColor0,
                        buttonColor: scheme.secondaryContainer,
                        isClickable: true,
                        onTap: () {
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
