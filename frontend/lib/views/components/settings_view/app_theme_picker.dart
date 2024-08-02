import "package:flutter/material.dart";
import "package:frontend/model/game_model.dart";
import "package:frontend/views/components/shared/text_variable.dart";

import "package:provider/provider.dart";

class AppThemePicker extends StatelessWidget {
  const AppThemePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(
      builder: (context, GameModel, child) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: TextSmall("App Theme"),
          ),
          Container(
            height: 120,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Color(0x20000000),
            ),
          )
        ],
      ),
    );
  }
}
