import 'package:frontend/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../exports.dart';

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
  final String appBarLabel = "Параметры";
  final String gameModeText = "Режим игры";
  final String colorPiecesText = "Цвет фигур";
  final String timeText = "Время";
  final String levelDifficultyText = "Уровень сложности";
  final String additionalSettingsText = "Дополнительно";
  final String startGameText = "Начать партию";
  final String gameWithComputerText = "С компьютером";
  final String gameWithHumanText = "С другом";
  final String gameWithTimeText = "С часами";
  final String gameWithoutTimeText = "Без часов";
  final String minutesSubtitle = "Минут на партию";
  final String secondsSubtitle = "Добавление секунд на ход";
  final String moveBackText = "Возврат ходов";
  final String threatsText = "Угрозы";
  final String hintsText = "Подсказки";

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

  List<int> listOfDurations = [
    1,
    2,
    3,
    4,
    5,
    10,
    15,
    20,
    25,
    30,
    40,
    60,
    80,
    90,
    120
  ];
  List<int> listOfAdditions = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    15,
    20,
    30,
    45,
    60
  ];

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
                      minHeight: MediaQuery.of(context).size.height),
                    child: IntrinsicHeight(
                      child: Container(
                        margin:
                          const EdgeInsets.only(left: 24, right: 24, top: 55),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AppBarSettings(label: appBarLabel),
                            TextHeading(
                              text: gameModeText,
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
                                        title: gameWithComputerText,
                                        index: 0,
                                        currentIndex: _tabColorController.index,
                                      ),
                                      TabItem(
                                        title: gameWithHumanText,
                                        index: 1,
                                        currentIndex: _tabColorController.index,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            TextHeading(
                              text: colorPiecesText,
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
                              text: timeText,
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
                                        title: gameWithTimeText,
                                        index: 0,
                                        currentIndex: _tabTimeController.index,
                                      ),
                                      TabItem(
                                        title: gameWithoutTimeText,
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
                                    values: listOfDurations,
                                    type: 'minutes',
                                    header: minutesSubtitle,
                                    startValue: durationOfGame,
                                    onChanged: setSeconds,
                                  ),
                                  ChoseTimeCarousel(
                                    values: listOfAdditions,
                                    type: 'seconds',
                                    header: secondsSubtitle,
                                    startValue: addingOfMove,
                                    onChanged: setSeconds,
                                  ),
                                ],
                              ) : const SizedBox(),
                            enemy == Enemy.computer
                              ? Column(
                                children: [
                                  TextHeading(
                                    text: levelDifficultyText,
                                    topMargin: 32,
                                    bottomMargin: 16,
                                  ),
                                  ChoseDifficultyButton(
                                    level: LevelOfDifficulty.easy,
                                    countOfIcons: 1,
                                    currentLevel: gameMode,
                                    onTap: () {
                                      appModel.setAIDifficulty(1);
                                      setGameMode(LevelOfDifficulty.easy);
                                    },
                                  ),
                                  ChoseDifficultyButton(
                                    level: LevelOfDifficulty.medium,
                                    countOfIcons: 2,
                                    currentLevel: gameMode,
                                    onTap: () {
                                      appModel.setAIDifficulty(3);
                                      setGameMode(LevelOfDifficulty.medium);
                                    },
                                  ),
                                  ChoseDifficultyButton(
                                    level: LevelOfDifficulty.hard,
                                    countOfIcons: 3,
                                    currentLevel: gameMode,
                                    onTap: () {
                                      appModel.setAIDifficulty(6);
                                      setGameMode(LevelOfDifficulty.hard);
                                    },
                                  ),
                                ],
                              ) : const SizedBox(),
                            enemy == Enemy.computer
                              ? Column(
                                children: [
                                  TextHeading(
                                    text: additionalSettingsText,
                                    topMargin: 32,
                                    bottomMargin: 16,
                                  ),
                                  SettingsRow(
                                    chose: isMoveBack,
                                    text: moveBackText,
                                    modalText: ModalStrings.moveBackModalText,
                                    modalHeader: moveBackText,
                                    onChanged: (chose) {
                                      setState(() {
                                        appModel.setAllowUndoRedo(chose);
                                        isMoveBack = chose;
                                      });
                                    },
                                  ),
                                  SettingsRow(
                                    chose: isThreats,
                                    text: threatsText,
                                    modalText: ModalStrings.threatsModalText,
                                    modalHeader: threatsText,
                                    onChanged: (chose) {
                                      setState(() {
                                        isThreats = chose;
                                      });
                                    },
                                  ),
                                  SettingsRow(
                                    chose: isHints,
                                    text: hintsText,
                                    modalText: ModalStrings.hintsModalText,
                                    modalHeader: hintsText,
                                    onChanged: (chose) {
                                      setState(() {
                                        isHints = chose;
                                      });
                                    },
                                  ),
                                ],
                            ) : const SizedBox(),
                            const Spacer(),
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
                        text: startGameText,
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
