import "package:frontend/constants/colors.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.chose,
    required this.text,
    required this.modalHeader,
    required this.modalText,
    this.onChanged,
  });

  final bool chose;
  final String text;
  final String modalHeader;
  final String modalText;
  final void Function(bool)? onChanged;

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
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0))
                        ),
                        contentPadding: const EdgeInsets.only(top: 8, bottom: 32, left: 32, right: 32),
                        title: Text(
                          modalHeader,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w600,
                            fontSize: 36,
                            color: scheme.primary
                          ),
                        ),
                        content: Container(
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
                  color: scheme.tertiaryContainer,
                ),
              ),
            ],
          ),
          Theme(
            data: ThemeData(useMaterial3: false),
            child: Switch(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: chose,
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
