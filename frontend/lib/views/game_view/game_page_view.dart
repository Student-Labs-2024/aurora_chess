import "package:flutter/material.dart";
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
  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.background,
      body: Consumer<GameModel>(
        builder: (context, gameModel, child) {
          return WillPopScope(
            onWillPop: _willPopCallback,
            child: Column(
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
                            context.go(RouteLocations.settingsScreen);
                          },
                        ),
                        const GameStatus(),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: ChessBoardWidget(gameModel)),
                const SizedBox(height: 30),
                const Spacer(),
                Timers(gameModel),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: GameInfoAndControls(gameModel),
                ),
                BottomPadding(),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<bool> _willPopCallback() async {
    widget.gameModel.exitChessView();

    return true;
  }
}
