import "package:carousel_slider/carousel_slider.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "../../views.dart";

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
    required this.carouselController
  });
  final int index;
  final int pieceIndex;
  final CarouselController carouselController;

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
          height: height - 270,
          child: CarouselSlider.builder(
            carouselController: carouselController,
            itemCount: imgOfHints[name]!.length,
            options: CarouselOptions(
              initialPage: 0,
              aspectRatio: 9 / 14,
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
}