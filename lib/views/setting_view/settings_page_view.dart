import 'package:flutter/material.dart';
import 'package:frontend/model/game_model.dart';
import 'package:frontend/views/components/settings_view/piece_theme_picker.dart';
import 'package:frontend/views/components/shared/rounded_button.dart';

import 'package:provider/provider.dart';

import '../components/settings_view/app_theme_picker.dart';
import '../components/shared/bottom_padding.dart';
import '../components/shared/text_variable.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(
      builder: (context, gameModel, child) => Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            const TextLarge('Settings'),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const ClampingScrollPhysics(),
                children: [
                  const AppThemePicker(),
                  const SizedBox(height: 20),
                  const PieceThemePicker(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 30),
            RoundedButton(
              'Back',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            BottomPadding(),
          ],
        ),
      ),
    );
  }
}
