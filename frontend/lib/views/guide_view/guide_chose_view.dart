import "package:flutter/material.dart";
import "package:frontend/router/router.dart";
import "package:go_router/go_router.dart";
import "guide_view.dart";

List<String> piecesIcons = [
  "pawn.svg",
  "rook.svg",
  "knight.svg",
  "bishop.svg",
  "queen.svg",
  "king.svg",
];

enum Pieces { pawn, rook, knight, bishop, queen, king }

class GuideChoseView extends StatelessWidget {
  static GuideChoseView builder(BuildContext context, GoRouterState state) =>
      const GuideChoseView();
  const GuideChoseView({super.key});
  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                AppBarGuide(
                  isMainGuide: true,
                  iconName: GuideStrings.appbarMainIcon,
                  iconColor: scheme.onTertiary,
                  bottomMargin: 21,
                  header: GuideStrings.guideHeader,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: pieces.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return SingleChildScrollView(
                        child: GuideChosePieceButton(
                          iconName: index < 6 ? "assets/images/pieces/${piecesIcons[index]}" : null,
                          label: pieces[index],
                          isPiece: index < 6,
                          buttonColor: scheme.secondary,
                          iconArrowColor: scheme.onPrimaryContainer,
                          textColor: scheme.primary,
                          onTap: () {
                            context.push(RouteLocations.guideScreen, extra: index);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
              child: GuideChosePieceButton(
                iconName: null,
                label: GuideStrings.partyHistoryPage,
                isPiece: false,
                buttonColor: scheme.onTertiaryContainer,
                iconArrowColor: scheme.surfaceDim,
                textColor: scheme.surfaceDim,
                onTap: () {
                  context.push(RouteLocations.partyHistoryScreen);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
