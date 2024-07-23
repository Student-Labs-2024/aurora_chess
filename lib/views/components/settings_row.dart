import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/constants/colors.dart';

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.chose,
    required this.text,
    this.onChanged
  });

  final bool chose;
  final String text;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return Container(
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
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 10,),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
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