import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/exports.dart';

class InfoPartyBar extends StatelessWidget {
  const InfoPartyBar({
    super.key,
    required this.height,
    required this.isComputer,
  });

  final double height;
  final bool isComputer;

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;

    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: scheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(16)
      ),
      child: isComputer ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(PartyHistoryConst.gameResults.length, (index) {
          return InfoBarItem(
            index: index,
            isComputer: isComputer,
          );
        }),
      )
      : Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfoBarItem(
                index: 0,
                isComputer: isComputer,
              ),
              InfoBarItem(
                index: 1,
                isComputer: isComputer,
              )
            ],
          ),
          InfoBarItem(
            index: 2,
            isComputer: isComputer,
          )
        ],
      )
    );
  }
}
