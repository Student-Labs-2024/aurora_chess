import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "../guide_view.dart";

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

class GuidePieceCarousel extends StatelessWidget {
  const GuidePieceCarousel({
    super.key,
    required this.pieceIndex,
    required this.index,
    required this.carouselController,
  });
  final int index;
  final int pieceIndex;
  final PageController carouselController;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var scheme = Theme.of(context).colorScheme;
    String name = pieces[pieceIndex];
    return Column(
      children: [
        Text(
          name,
          style: TextStyle(
            color: scheme.primary,
            fontSize: 24,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w700,
            height: 0.05,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        SizedBox(
          height: height - 260,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            physics: const PageScrollPhysics(),
            controller: carouselController,
            itemCount: imgOfHints[name]!.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  SvgPicture.asset(
                    "assets/images/guide_boards/${imgOfHints[name]![index]}",
                    height: 280,
                  ),
                  HintDescription(
                    text: hintsOfPieces[name]![index],
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
