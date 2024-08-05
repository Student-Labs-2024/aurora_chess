import "package:flutter/material.dart";
import "package:frontend/constants/colors.dart";

import "../setting_view.dart";

class DropdownWidget extends StatefulWidget {
  DropdownWidget({
    super.key,
    required this.values,
    required this.initValue, 
    this.onTap
  });

  final List<LevelOfDifficulty> values;
  final LevelOfDifficulty initValue;
  final void Function(LevelOfDifficulty?)? onTap;

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  bool isOpened = false;
  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return PopupMenuButton<LevelOfDifficulty>(
      popUpAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 10),
      ),
      itemBuilder: (context) {
        return widget.values.map((LevelOfDifficulty value) {
          return PopupMenuItem(
            height: 20,
            padding: EdgeInsets.zero,
            value: value,
            onTap: () {
              setState(() {
                isOpened = false;
              });
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      GameSettingConsts.personalLevelOfDifficultyText[value]!,
                      style: const TextStyle(
                        color: ColorsConst.neutralColor200,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    )
                  ],
                ),
                SizedBox(height: value == widget.values.first ? 10 : 0,)
              ],
            )
          );
        }).toList();
      },
      constraints: const BoxConstraints(
        minWidth: 123,
        maxWidth: 123,
      ),
      position: PopupMenuPosition.under,
      color: scheme.outline,
      padding: EdgeInsets.zero,
      initialValue: widget.initValue,
      shape: const OutlineInputBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.zero,
          bottom: Radius.circular(16)
        ),
        borderSide: BorderSide.none,
        gapPadding: 0,
      ),
      onSelected: widget.onTap,
      onOpened: () {
        setState(() {
          isOpened = true;
        });
      },
      onCanceled: () {
        setState(() {
          isOpened = false;
        });
      },
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 9),
        constraints: const BoxConstraints(
          maxHeight: 40,
          minWidth: 123,
          maxWidth: 123
        ),
        decoration: BoxDecoration(
          color: scheme.tertiaryContainer,
          borderRadius: BorderRadius.vertical(
            top: const Radius.circular(16),
            bottom: Radius.circular(isOpened ? 0 : 16)
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              GameSettingConsts.personalLevelOfDifficultyText[widget.initValue]!,
              style: const TextStyle(
                color: ColorsConst.primaryColor0,
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                height: 0.08,
              ),
            ),
            Icon(
              isOpened ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: scheme.onInverseSurface,
            ),
          ],
        ),
      ),
    );
  }
}
