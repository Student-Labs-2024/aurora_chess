import "package:frontend/views/components/custom_icon_button.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class AppBarGuide extends StatelessWidget {
  const AppBarGuide({
    super.key,
    required this.isMainGuide,
    required this.iconName,
    required this.iconColor,
    required this.bottomMargin,
    required this.header
  });

  final bool isMainGuide;
  final String iconName;
  final Color iconColor;
  final double bottomMargin;
  final String header;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.only(
          left: 24, right: 24, top: 40, bottom: bottomMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isMainGuide
              ? const SizedBox(
                  width: 42,
                )
              : CustomIconButton(
                  iconName: iconName,
                  color: iconColor,
                  iconSize: 42,
                  onTap: () {
                    context.pop();
                  },
                ),
          Text(
            header,
            style: TextStyle(
              color: scheme.surface,
              fontSize: 20,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w700,
              height: 0.05
            ),
          ),
          isMainGuide
              ? CustomIconButton(
                  iconName: iconName,
                  color: iconColor,
                  iconSize: 42,
                  onTap: () {
                    context.pop();
                  },
                )
              : const SizedBox(
                  width: 42,
                ),
        ],
      ),
    );
  }
}
