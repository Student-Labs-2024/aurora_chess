import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/exports.dart';

class InfoBarItem extends StatelessWidget {
  const InfoBarItem({
    super.key,
    required this.index,
    required this.isComputer
  });

  final int index;
  final bool isComputer;

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    List<Color> listOfColorsIcons = [
      scheme.errorContainer,
      scheme.primary,
      ColorsConst.secondaryColor100
    ];

    return Row(
      children: <Widget>[
        SvgPicture.asset(
          PartyHistoryConst.infoPartyIconName,
          height: 24,
          width: 24,
          colorFilter: ColorFilter.mode(listOfColorsIcons[index],
              BlendMode.srcIn),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          isComputer ? PartyHistoryConst.gameResults[index]
              : PartyHistoryConst.friendGameResults[index],
          style: TextStyle(
            color: scheme.primary,
            fontSize: 16,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            height: 0.08,
          ),
        ),
      ],
    );
  }

}