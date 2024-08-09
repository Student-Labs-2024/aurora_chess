import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../exports.dart';

class PieceChooseWindow extends StatelessWidget {
  GameModel gameModel;
  PieceChooseWindow(this.gameModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 245,
      height: 275,
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Выберите фигуру',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/images/pieces/bishop.svg',
                        width: 55,
                        height: 55,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => gameModel.setPieceForPromotion(
                        ChessPieceType.bishop,
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/images/pieces/rook.svg',
                        width: 55,
                        height: 55,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => gameModel.setPieceForPromotion(
                        ChessPieceType.rook,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/images/pieces/knight.svg',
                        width: 55,
                        height: 55,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => gameModel.setPieceForPromotion(
                        ChessPieceType.knight,
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/images/pieces/queen.svg',
                        width: 55,
                        height: 55,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => gameModel.setPieceForPromotion(
                        ChessPieceType.queen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
