import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

class GuideChosePieceButton extends StatelessWidget {
  const GuideChosePieceButton({
    super.key,
    required this.iconName,
    required this.label,
    required this.isPiece,
    required this.buttonColor,
    required this.iconArrowColor,
    required this.textColor,
    this.onTap,
  });

  final String? iconName;
  final String label;
  final bool isPiece;
  final Color buttonColor;
  final Color iconArrowColor;
  final Color textColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        height: 48,
        minWidth: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        color: buttonColor,
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                isPiece ?
                Row(
                  children: [
                    SvgPicture.asset(
                      iconName!,
                      colorFilter: ColorFilter.mode(
                          scheme.primary, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 8,)
                  ],
                ) : const SizedBox(width: 0,),
                Text(
                  label,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SvgPicture.asset(
              "assets/images/icons/back_arrow_icon.svg",
              colorFilter: ColorFilter.mode(iconArrowColor, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }

}