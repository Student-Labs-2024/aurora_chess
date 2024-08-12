import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/exports.dart';

class OnePartyViewWidget extends StatelessWidget {
  const OnePartyViewWidget({
    super.key,
    required this.partyData,
    required this.isComputer
  });

  final Map partyData;
  final bool isComputer;

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    Map<String, Color> computerListOfColorsIcons = {
      "Победа": scheme.errorContainer,
      "Поражение": scheme.primary,
      "Ничья": ColorsConst.secondaryColor100
    };

    Map<String, Color> friendListOfColorsIcons = {
      "Победа белых": scheme.errorContainer,
      "Победа чёрных": scheme.primary,
      "Ничья": ColorsConst.secondaryColor100
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 24, right: 24),
      height: 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            PartyHistoryConst.infoPartyIconName,
            height: 35,
            width: 35,
            colorFilter: ColorFilter.mode(isComputer
                ? computerListOfColorsIcons[partyData["result"]]!
                : friendListOfColorsIcons[partyData["result"]]!,
                BlendMode.srcIn),
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                partyData["date"],
                style: TextStyle(
                  color: scheme.primary,
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  height: 1
                ),
              ),
              Text(
                partyData["time"],
                style: TextStyle(
                  color: scheme.primary,
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

}