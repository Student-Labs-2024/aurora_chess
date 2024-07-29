import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GuideChosePieceButton extends StatelessWidget {
  const GuideChosePieceButton({
    super.key,
    required this.iconName,
    required this.label,
    required this.isPiece,
    this.onTap,
  });

  final String? iconName;
  final String label;
  final bool isPiece;
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
        color: scheme.secondary,
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
                      color: scheme.primary,
                    ),
                    const SizedBox(width: 8,)
                  ],
                ) : const SizedBox(width: 0,),
                Text(
                  label,
                  style: TextStyle(
                    color: scheme.primary,
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SvgPicture.asset(
              "assets/images/icons/back_arrow_icon.svg",
              color: scheme.onPrimaryContainer,
            ),
          ],
        ),
      ),
    );
  }

}