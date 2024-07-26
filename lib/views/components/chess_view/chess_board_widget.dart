import 'package:frontend/model/app_model.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChessBoardWidget extends StatelessWidget {
  final AppModel appModel;

  ChessBoardWidget(this.appModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 4,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Color(0x88000000),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          child: GameWidget(game: appModel.game!),
          width: MediaQuery.of(context).size.width - 68,
          height: MediaQuery.of(context).size.width - 68,
        ),
      ),
    );
  }
}
