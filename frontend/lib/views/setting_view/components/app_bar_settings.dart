import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "../../../exports.dart";

class AppBarSettings extends StatelessWidget {
  const AppBarSettings({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomIconButton(
          iconName: "assets/images/icons/left_big_arrow_icon.svg",
          color: scheme.onTertiary,
          iconSize: 40,
          onTap: () {
            context.go(RouteLocations.homeScreen);
          },
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 23,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            color: scheme.primary),
        ),
        ButtonToGuide(
          backGroundColor: scheme.outlineVariant,
          height: 40,
          width: 40,
          onTap: () {
            context.push(RouteLocations.guidebookScreen);
          },
        ),
      ],
    );
  }
}
