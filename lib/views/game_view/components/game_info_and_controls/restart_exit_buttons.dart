import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../exports.dart';

class RestartExitButtons extends StatelessWidget {
  final GameModel gameModel;

  const RestartExitButtons(this.gameModel, {super.key});

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: IconButton(
            icon: SvgPicture.asset(
              "assets/images/icons/gridicons_menus.svg",
              color: scheme.primary,
            ),
            onPressed: () {
              gameModel.newGame(context);
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: IconButton(
            icon: SvgPicture.asset(
              "assets/images/icons/lamp_icon.svg",
              color: scheme.primary,
            ),
            onPressed: () {
              gameModel.exitChessView();
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
