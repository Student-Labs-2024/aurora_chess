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
          children: [
            AppBarGuide(
              isMainGuide: true,
              iconName: "assets/images/icons/cancel.svg",
              iconColor: scheme.onTertiary,
              bottomMargin: 21,
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
                      onTap: () {
                        context.push(RouteLocations.guideScreen, extra: index);
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
