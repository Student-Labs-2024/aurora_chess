import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: scheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(16)
      ),
      child: isComputer ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(PartyHistoryConst.gameResults.length, (index) {
          return Row(
            children: [
              InfoBarItem(
                index: index,
                isComputer: isComputer,
              ),
              SizedBox(
                width: index < 2 ? 16 : 0,
              )
            ],
          );
        }),
      )
      : Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InfoBarItem(
                index: 0,
                isComputer: isComputer,
              ),
              const SizedBox(
                width: 16,
              ),
              InfoBarItem(
                index: 1,
                isComputer: isComputer,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InfoBarItem(
                index: 2,
                isComputer: isComputer,
              ),
            ],
          )
        ],
      )
    );
  }
}
