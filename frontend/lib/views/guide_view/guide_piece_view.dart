import "package:flutter/material.dart";
import "../../exports.dart";

Map<String, List<String>> hintsOfPieces = {
  "Пешка": GuideStrings.hintsOfPawn,
  "Ладья": GuideStrings.hintsOfRook,
  "Конь": GuideStrings.hintsOfKnight,
  "Слон": GuideStrings.hintsOfBishop,
  "Ферзь": GuideStrings.hintsOfQueen,
  "Король": GuideStrings.hintsOfKing,
  "Взятие на проходе": GuideStrings.hintsOfTaking,
  "Рокировка": GuideStrings.hintsOfCastling,
};

Map<String, List<String>> imgOfHints = {
  "Пешка": GuideHintsNameConst.pawnHints,
  "Ладья": GuideHintsNameConst.rookHints,
  "Конь": GuideHintsNameConst.knightHints,
  "Слон": GuideHintsNameConst.bishopHints,
  "Ферзь": GuideHintsNameConst.queenHints,
  "Король": GuideHintsNameConst.kingHints,
  "Взятие на проходе": GuideHintsNameConst.takingHints,
  "Рокировка": GuideHintsNameConst.castlingHints,
};

class GuideView extends StatefulWidget {
  const GuideView({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<GuideView> createState() => _GuideViewState();
}

class _GuideViewState extends State<GuideView> {
  int index = 0;
  PageController carouselController = PageController(viewportFraction: 0.85,);

  @override
  void initState() {
    setState(() {
      index = widget.index;
    });
    super.initState();
  }

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
                  isMainGuide: false,
                  iconName: GuideStrings.appbarIcon,
                  iconColor: scheme.onTertiary,
                  bottomMargin: 32,
                  header: GuideStrings.guideHeader,
                ),
                GuidePieceCarousel(
                  pieceIndex: index,
                  index: 0,
                  carouselController: carouselController,
                ),
              ],
            ),
            BottomBarGuide(
              index: index,
              onBack: () {
                if (index > 0) {
                  setState(() {
                    index -= 1;
                    carouselController.jumpToPage(0);
                  });
                }
              },
              onForward: () {
                if (index < hintsOfPieces.length - 1) {
                  setState(() {
                    index += 1;
                    carouselController.jumpToPage(0);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
