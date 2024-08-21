import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";
import "../../exports.dart";

class GameView extends StatefulWidget {
  final GameModel gameModel;

  const GameView(this.gameModel, {super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  bool isLoading = true;
  bool isMoveBack = true;
  bool isThreats = true;
  bool isHints = true;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
    return isLoading
        ? const LoadingWidget()
        : Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Consumer<GameModel>(
              builder: (context, gameModel, child) {
                return PopScope(
                  canPop: true,
                  onPopInvoked: _willPopCallback,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MoveList(gameModel),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                            ),
                            child: SizedBox(
                              height: 40,
                              child: Stack(
                                children: [
                                  CustomIconButton(
                                    iconName:
                                        "assets/images/icons/left_big_arrow_icon.svg",
                                    color: scheme.outlineVariant,
                                    iconSize: 40,
                                    onTap: () {
                                      context
                                          .go(RouteLocations.settingsScreen, extra: gameModel);
                                    },
                                  ),
                                  const GameStatus(),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16,),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                NameWithAdvantageForPlayer(
                                  player: Player.player2,
                                  gameModel: gameModel,
                                ),
                                Expanded(child: Container()),
                                gameModel.timeLimit == 0
                                  ? const SizedBox(height: 48,)
                                  : TimerWidget(
                                    timeLeft: gameModel.player2TimeLeft,
                                    isFilled: gameModel.turn == Player.player2,
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 17, bottom: 15),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: SvgPicture.asset(
                                    "assets/images/board.svg",
                                    width: width,
                                    height: width * LogicConsts.boardRatio,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: ChessBoardWidget(gameModel)
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                NameWithAdvantageForPlayer(
                                  player: Player.player1,
                                  gameModel: gameModel,
                                ),
                                Expanded(child: Container()),
                                gameModel.timeLimit == 0
                                  ? const SizedBox(height: 48,)
                                  : TimerWidget(
                                    timeLeft: gameModel.player1TimeLeft,
                                    isFilled: gameModel.turn == Player.player1,
                                  ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: GameInfoAndControls(gameModel: gameModel,),
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

  Future<void> _willPopCallback(bool didPop) async {
    widget.gameModel.exitChessView();
  }
}
