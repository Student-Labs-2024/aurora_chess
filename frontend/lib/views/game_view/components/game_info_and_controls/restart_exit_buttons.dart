import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:go_router/go_router.dart";
import "../../../../exports.dart";

class RestartExitButtons extends StatelessWidget {
  final GameModel gameModel;

  const RestartExitButtons(this.gameModel, {super.key});

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
              showDialog(
                context: context,
                builder: (dialogContext) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  child: AlertDialog(
                    insetPadding: EdgeInsets.zero,
                    backgroundColor: scheme.onBackground,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    contentPadding: const EdgeInsets.only(
                        top: 32, bottom: 32, left: 22, right: 22),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MaterialButton(
                          onPressed: () => {
                            Navigator.of(dialogContext).pop(),
                          },
                          height: 60,
                          color: scheme.surfaceVariant,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Text(
                              'Продолжить',
                              style: TextStyle(
                                color: ColorsConst.neutralColor0,
                                fontFamily: "Roboto",
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        MaterialButton(
                          onPressed: () => {
                            gameModel.newGame(context),
                            Navigator.of(dialogContext).pop(),
                          },
                          height: 60,
                          color: scheme.outline,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              'Перезапустить матч',
                              style: TextStyle(
                                color: scheme.onTertiary,
                                fontFamily: "Roboto",
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        MaterialButton(
                          height: 60,
                          color: scheme.outline,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          onPressed: () {
                            if (gameModel.gameOver) {
                              addPartyToHistory(gameModel);
                            }
                            gameModel.exitChessView();
                            if (!context.mounted) return;
                            context.go(RouteLocations.settingsScreen,
                                extra: gameModel);
                            Navigator.of(dialogContext).pop();
                          },
                          child: Center(
                            child: Text(
                              'Закончить игру',
                              style: TextStyle(
                                color: scheme.onTertiary,
                                fontFamily: "Roboto",
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: IconButton(
            icon: SvgPicture.asset(
              GamePageConst.lampIcon,
              colorFilter: ColorFilter.mode(
                  (gameModel.showHint || gameModel.playerCount == 2)
                      ? scheme.primary
                      : scheme.onError,
                  BlendMode.srcIn),
            ),
            highlightColor: Colors.white.withOpacity(0.3),
            onPressed: (gameModel.showHint || gameModel.playerCount == 2)
                ? () {
                    gameModel.game!.aiHint();
                  }
                : null,
          ),
        ),
      ],
    );
  }
}
