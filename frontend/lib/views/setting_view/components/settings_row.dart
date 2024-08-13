import "package:frontend/constants/colors.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

import "../setting_view.dart";

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    this.chose,
    required this.text,
    required this.modalHeader,
    required this.modalText,
    required this.isChoseDiff,
    this.initValue,
    this.choseDiffWidget,
    this.onChanged,
    this.onChose,
  });

  final bool? chose;
  final String text;
  final String modalHeader;
  final String modalText;
  final bool isChoseDiff;
  final LevelOfDifficulty? initValue;
  final Widget? choseDiffWidget;
  final void Function(bool)? onChanged;
  final void Function(LevelOfDifficulty?)? onChose;

  List<LevelOfDifficulty> getPersonalityList(LevelOfDifficulty initValue) {
    List<LevelOfDifficulty> list = LevelOfDifficulty.values.sublist(0, 3);
    list.remove(initValue);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return Container(
      height: 30,
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                text,
                style: TextStyle(
                  color: scheme.primary,
                  fontSize: 16,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      child: AlertDialog(
                        insetPadding: EdgeInsets.zero,
                        backgroundColor: scheme.onBackground,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        titlePadding: const EdgeInsets.only(
                            top: 32, bottom: 0, left: 22, right: 22),
                        contentPadding: const EdgeInsets.only(
                            top: 16, bottom: 32, left: 22, right: 22),
                        title: Text(
                          modalHeader,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w500,
                            fontSize: 28,
                            color: scheme.primary
                          ),
                        ),
                        content: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            modalText,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: scheme.primary
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                icon: SvgPicture.asset(
                  "assets/images/icons/question_icon.svg",
                  colorFilter: ColorFilter.mode(scheme.tertiaryContainer,
                      BlendMode.srcIn),
                ),
              ),
            ],
          ),
          isChoseDiff ?
          DropdownWidget(
            values: getPersonalityList(initValue!),
            initValue: initValue!,
            onTap: onChose,
          ) :
          Theme(
            data: ThemeData(useMaterial3: false),
            child: Switch(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: chose!,
              inactiveThumbColor: scheme.surfaceTint,
              inactiveTrackColor: scheme.outline,
              activeColor: scheme.inversePrimary,
              activeTrackColor: ColorsConst.primaryColor100,
              onChanged: onChanged,
            ),
          )
        ],
      ),
    );
  }
}
