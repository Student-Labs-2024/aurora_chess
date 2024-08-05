import "package:frontend/constants/colors.dart";
import "package:frontend/views/setting_view/game_settings_view.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

import "../constants/constants.dart";

class ChoseDifficultyButton extends StatelessWidget {
  const ChoseDifficultyButton({
    super.key,
    required this.level,
    required this.countOfIcons,
    required this.currentLevel,
    required this.personalityLevel,
    this.onTap,
  });

  final LevelOfDifficulty level;
  final int countOfIcons;
  final LevelOfDifficulty currentLevel;
  final LevelOfDifficulty personalityLevel;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    Map<LevelOfDifficulty, String> levelOfDifficultyText = {
      LevelOfDifficulty.easy: "Лёгкий",
      LevelOfDifficulty.medium: "Средний",
      LevelOfDifficulty.hard: "Сложный",
      LevelOfDifficulty.personality: "Персональный",
    };
    Map<LevelOfDifficulty, String> description = {
      LevelOfDifficulty.easy: GameSettingConsts.easyDescription,
      LevelOfDifficulty.medium: GameSettingConsts.mediumDescription,
      LevelOfDifficulty.hard: GameSettingConsts.hardDescription,
      LevelOfDifficulty.personality: GameSettingConsts.personalityDescription,
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        height: 60,
        minWidth: double.infinity,
        onPressed: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: level == currentLevel
          ? ColorsConst.primaryColor100
          : scheme.outline,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  levelOfDifficultyText[level] ?? "",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Roboto",
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    // height: 0.11,
                    color: level == currentLevel
                      ? ColorsConst.primaryColor0
                      : scheme.primary,
                  ),
                ),
                Text(
                  description[level] ?? "",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    // height: 0.11,
                    color: level == currentLevel
                        ? ColorsConst.primaryColor0
                        : scheme.primary,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                for (var i = 0; i < countOfIcons; i++)
                  Row(
                    children: [
                      const SizedBox(
                        width: 8,
                      ),
                      SvgPicture.asset(
                        "assets/images/icons/crown_icon.svg",
                        color: level == currentLevel
                          ? ColorsConst.primaryColor0
                          : scheme.primary,
                      ),
                    ],
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
