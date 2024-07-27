import 'package:frontend/model/app_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RestartExitButtons extends StatelessWidget {
  final AppModel appModel;

  RestartExitButtons(this.appModel);

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
                appModel.newGame(context);
              }),
        ),
        SizedBox(width: 10),
        Expanded(
          child: IconButton(
              icon: SvgPicture.asset(
                "assets/images/icons/lamp_icon.svg",
                color: scheme.primary,
              ),
              onPressed: () {
                appModel.exitChessView();
                Navigator.pop(context);
              }),
        ),
      ],
    );
  }
}
