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
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
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
                              child: BackArrowButton(gameModel),
                            ),
                            const SizedBox(height: 16),
                            PlayerAndTimerWidget(
                              gameModel: gameModel,
                              currentPlayer: gameModel.playerSide,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 17, bottom: 15),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: SvgPicture.asset(
                                      "assets/images/board.svg",
                                      width: deviceWidth,
                                      height:
                                          deviceWidth * LogicConsts.boardRatio,
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.topCenter,
                                      child: ChessBoardWidget(gameModel)),
                                ],
                              ),
                            ),
                            PlayerAndTimerWidget(
                              gameModel: gameModel,
                              currentPlayer:
                                  oppositePlayer(gameModel.playerSide),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(30),
                              child: GameInfoAndControls(
                                gameModel: gameModel,
                              ),
                            ),
                          ],
                        ),
                        gameModel.isPromotionForPlayer
                            ? Center(child: PieceChooseWindow(gameModel))
                            : Container(),
                        gameModel.gameOver
                            ? Builder(
                                builder: (dialogContext) => Stack(
                                  children: [
                                    Container(
                                      width: deviceWidth,
                                      height: deviceHeight,
                                      color: Colors.black54,
                                    ),
                                    AlertDialog(
                                      insetPadding: EdgeInsets.zero,
                                      backgroundColor: scheme.onBackground,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.0)),
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          top: 32,
                                          bottom: 32,
                                          left: 22,
                                          right: 22),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            getStatus(
                                                gameModel, context, scheme),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: scheme.onTertiary,
                                              fontSize: 28,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          MaterialButton(
                                            onPressed: () async {
                                              if (gameModel.gameOver) {
                                                await addPartyToHistory(gameModel);
                                              }
                                              if (!context.mounted) return;
                                              gameModel.newGame(context);
                                            },
                                            height: 60,
                                            color: scheme.surfaceVariant,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                GamePageConst.gameRestartText,
                                                style: TextStyle(
                                                  color:
                                                      ColorsConst.neutralColor0,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          MaterialButton(
                                            onPressed: () async {
                                              if (gameModel.gameOver) {
                                                await addPartyToHistory(gameModel);
                                              }
                                              gameModel.exitChessView();
                                              if (!context.mounted) return;
                                              context.go(
                                                  RouteLocations.settingsScreen,
                                                  extra: gameModel);
                                              Navigator.of(dialogContext).pop();
                                            },
                                            height: 60,
                                            color: scheme.outline,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Center(
                                              child: Text(
                                                GamePageConst.gameEndText,
                                                style: TextStyle(
                                                  color: scheme.onTertiary,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
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
