import "package:flutter/material.dart";
import "package:frontend/model/game_model.dart";
import "package:frontend/views/components/settings_view/piece_preview.dart";
import "package:frontend/views/components/shared/text_variable.dart";
import "package:flame/game.dart";

import "package:provider/provider.dart";

class PieceThemePicker extends StatelessWidget {
  const PieceThemePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(
      builder: (context, gameModel, child) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: TextSmall("Piece Theme"),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: Container(
              height: 120,
              decoration: const BoxDecoration(color: const Color(0x20000000)),
              child: Row(
                children: [
                  SizedBox(
                    height: 120,
                    width: 80,
                    child: GameWidget(
                      game: PiecePreview(gameModel),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
