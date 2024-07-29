import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
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
  "Пешка": ["pawn_first_hint.svg", "pawn_second_hint.svg", "pawn_third_hint.svg"],
  "Ладья": ["rook_first_hint.svg"],
  "Конь": ["knight_first_hint.svg", "knight_second_hint.svg"],
  "Слон": ["bishop_first_hint.svg",],
  "Ферзь": ["queen_first_hint.svg"],
  "Король": ["king_first_hint.svg", "king_second_hint.svg", "king_third_hint.svg", "king_fourth_hint.svg", "king_fifth_hint.svg"],
  "Взятие на проходе": ["taking_first_hint.svg", "taking_second_hint.svg", "taking_third_hint.svg"],
  "Рокировка": ["castling_first_hint.svg", "castling_second_hint.svg", "castling_third_hint.svg"],
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


class GuidePieceView extends StatelessWidget {
  const GuidePieceView({
    super.key,
    required this.pieceIndex,
  });

  final int pieceIndex;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var scheme = Theme.of(context).colorScheme;
    String name = pieces[pieceIndex];
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
        const SizedBox(height: 32,),
        SizedBox(
          height: height - 270,
          child: InfiniteCarousel.builder(
            itemCount: imgOfHints[name]!.length,
            itemExtent: width - 100,
            center: true,
            onIndexChanged: (index) {},
            axisDirection: Axis.horizontal,
            loop: false,
            itemBuilder: (context, itemIndex, realIndex) {
              return Center(
                child: Column(
                  children: [
                    SvgPicture.asset("assets/images/guide_boards/${imgOfHints[name]![itemIndex]}", height: 280,),
                    HintDescription(text: hintsOfPieces[name]![itemIndex],)
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

}