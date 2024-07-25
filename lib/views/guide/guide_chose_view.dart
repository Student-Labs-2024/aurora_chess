import 'package:flutter/material.dart';

import '../../exports.dart';

List<String> pieces = ["Пешка", "Ладья", "Конь", "Слон", "Ферзь", "Король"];
List<String> piecesIcons = [
  "pawn.svg",
  "rook.svg",
  "knight.svg",
  "bishop.svg",
  "queen.svg",
  "king.svg",
];
enum Pieces {
  pawn,
  rook,
  knight,
  bishop,
  queen,
  king
}

class GuideChoseView extends StatelessWidget {
  const GuideChoseView({super.key});
  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Column(
        children: [
          AppBarGuide(
            isMainGuide: true,
            iconName: "assets/images/icons/cancel.svg",
            iconColor: scheme.onSurface,
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
                    iconName: "assets/images/pieces/${piecesIcons[index]}",
                    label: pieces[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return GuideView(index: index,);
                        })
                      );
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

}