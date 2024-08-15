import "package:flutter/material.dart";

import "../../../exports.dart";

class BottomBarGuide extends StatelessWidget {
  const BottomBarGuide({
    super.key,
    required this.index,
    this.onForward,
    this.onBack
  });

  final int index;
  final void Function()? onForward;
  final void Function()? onBack;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 37),
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          index > 0 ?
          CustomIconButton(
            color: scheme.surfaceContainer,
            iconName: GuideStrings.leftArrowIcon,
            iconSize: 40,
            onTap: onBack,
          ): const SizedBox(width: 40,),
          PointsIndicator(
            count: hintsOfPieces.length,
            currentIndex: index,
          ),
          index < hintsOfPieces.length - 1 ?
          CustomIconButton(
            color: scheme.surfaceContainer,
            iconName: GuideStrings.rightArrowIcon,
            iconSize: 40,
            onTap: onForward,
          ) : const SizedBox(width: 40,),
        ],
      ),
    );
  }
}
