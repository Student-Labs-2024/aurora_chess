import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/exports.dart';

class ChoseDifficultyButton extends StatelessWidget {
  const ChoseDifficultyButton({
    super.key,
    required this.level,
    required this.countOfIcons,
    required this.currentLevel,
    this.onTap,
  });

  final LevelOfDifficulty level;
  final int countOfIcons;
  final LevelOfDifficulty currentLevel;
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
        color: level == currentLevel ? ColorsConst.primaryColor100 : scheme.outline,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              levelOfDifficultyText[level] ?? "",
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Roboto',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: level == currentLevel ? ColorsConst.primaryColor0 : scheme.primary,
              ),
            ),
            Row(
              children: [
                for(var i = 0; i < countOfIcons; i++)
                  Row(
                    children: [
                      const SizedBox(width: 8,),
                      SvgPicture.asset(
                        "assets/images/icons/crown_icon.svg",
                        color: level == currentLevel ? ColorsConst.primaryColor0 : scheme.primary,
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