import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:frontend/exports.dart";

class CustomSwitch extends StatefulWidget {
  CustomSwitch(this.provider, {super.key});
  ThemeProvider provider;

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  final activeIcon = "assets/images/icons/dark_switch.svg";
  final inactiveIcon = "assets/images/icons/light_switch.svg";


  @override
  Widget build(BuildContext context) {
    bool isToggle =  widget.provider.isDarkMode;
    var scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => widget.provider.toggleTheme(),
      child: Container(
        height: 40,
        width: 69,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: scheme.secondaryContainer,
        ),
        child: AnimatedAlign(
          alignment: isToggle ? Alignment.centerRight : Alignment.centerLeft,
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
            child: SvgPicture.asset(isToggle ? activeIcon : inactiveIcon),
          ),
        ),
      ),
    );
  }
}
