import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/exports.dart';

class InfoPartyBar extends StatelessWidget {
  const InfoPartyBar({super.key});

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    List<Color> listOfColorsIcons = [
      scheme.errorContainer,
      scheme.primary,
      ColorsConst.secondaryColor100
    ];

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(16)
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(PartyHistoryConst.gameResults.length, (index) {
            return Row(
              children: [
                SvgPicture.asset(
                  PartyHistoryConst.infoPartyIconName,
                  height: 24,
                  width: 24,
                  color: listOfColorsIcons[index],
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  PartyHistoryConst.gameResults[index],
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
          }),
        ),
      ),
    );
  }
}
