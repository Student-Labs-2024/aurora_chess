import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../exports.dart';

// ignore: must_be_immutable
class BackArrowButton extends StatelessWidget {
  GameModel gameModel;
  BackArrowButton(this.gameModel, {super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 40,
      child: Stack(
        children: [
          CustomIconButton(
            iconName: GamePageConst.leftBigArrow,
            color: scheme.outlineVariant,
            iconSize: 40,
            onTap: () async {
              if (gameModel.gameOver) {
                await addPartyToHistory(gameModel);
                context.go(RouteLocations.settingsScreen, extra: gameModel);
              } else {
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
                      titlePadding: const EdgeInsets.only(
                          top: 32, bottom: 0, left: 22, right: 22),
                      contentPadding: const EdgeInsets.only(
                          top: 16, bottom: 32, left: 22, right: 22),
                      title: Text(
                        GamePageConst.gameBackModalHeader,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 28,
                          color: scheme.onTertiary,
                        ),
                      ),
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
                                GamePageConst.continueGameText,
                                style: TextStyle(
                                  color: ColorsConst.neutralColor0,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          MaterialButton(
                            onPressed: () async {
                              await addPartyToHistory(gameModel);
                              context.go(RouteLocations.settingsScreen,
                                  extra: gameModel);
                              Navigator.of(dialogContext).pop();
                            },
                            height: 60,
                            color: scheme.outline,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                GamePageConst.gameGiveUpText,
                                style: TextStyle(
                                  color: scheme.onTertiary,
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
              }
            },
          ),
          const GameStatus(),
        ],
      ),
    );
  }
}
