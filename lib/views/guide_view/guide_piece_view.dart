import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../exports.dart';

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

List<String> pieces = [
  "Пешка",
  "Ладья",
  "Конь",
  "Слон",
  "Ферзь",
  "Король",
  "Взятие на проходе",
  "Рокировка"
];

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
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              AppBarGuide(
                isMainGuide: false,
                iconName: "assets/images/icons/left_big_arrow_icon.svg",
                iconColor: scheme.onTertiary,
              ),
              GuidePieceView(
                pieceIndex: index,
                index: 0,
              ),
            ],
          ),
          BottomBarGuide(
            index: index,
            onBack: () {
              setState(() {
                if (index > 0) {
                  setState(() {
                    index -= 1;
                  });
                }
              });
            },
            onForward: () {
              setState(() {
                if (index < hintsOfPieces.length - 1) {
                  setState(() {
                    index += 1;
                  });
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

class GuidePieceView extends StatefulWidget {
  const GuidePieceView({
    super.key,
    required this.pieceIndex,
    required this.index,
  });
  final int index;
  final int pieceIndex;

  @override
  State<GuidePieceView> createState() => _GuidePieceViewState();
}

class _GuidePieceViewState extends State<GuidePieceView> {
  late CarouselController carouselController;

  @override
  void initState() {
    carouselController = CarouselController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var scheme = Theme.of(context).colorScheme;
    String name = pieces[widget.pieceIndex];
    return Column(
      children: [
        Text(
          name,
          style: TextStyle(
            color: scheme.primary,
            fontSize: 24,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            height: 0.05,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        SizedBox(
          height: height - 270,
          child: CarouselSlider.builder(
            carouselController: carouselController,
            itemCount: imgOfHints[name]!.length,
            options: CarouselOptions(
              initialPage: 0,
              aspectRatio: 9 / 13,
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
              enlargeFactor: 0.2,
              viewportFraction: 0.7,
            ),
            itemBuilder: (context, itemIndex, realIndex) {
              return Center(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "assets/images/guide_boards/${imgOfHints[name]![itemIndex]}",
                      height: 280,
                    ),
                    HintDescription(
                      text: hintsOfPieces[name]![itemIndex],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

}
