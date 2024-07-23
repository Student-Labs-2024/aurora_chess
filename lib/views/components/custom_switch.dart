import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../exports.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({super.key, required this.onChanged});
  final void Function() onChanged;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ThemeProvider>(context, listen: false);
    var scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 90,
      height: 40,
      child: FittedBox(
        fit: BoxFit.fill,
        child: CupertinoSwitch(
          value: provider.isDarkMode,
          onChanged: (value) {
            onChanged();
          }
        ),
      ),
    );
  }

}