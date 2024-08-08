import 'package:flutter/material.dart';
import 'package:frontend/exports.dart';

class PartyHistoryMainView extends StatefulWidget {
  const PartyHistoryMainView({super.key});

  @override
  State<PartyHistoryMainView> createState() => _PartyHistoryMainViewState();
}

class _PartyHistoryMainViewState extends State<PartyHistoryMainView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            AppBarGuide(
              isMainGuide: false,
              iconName: PartyHistoryConst.appbarIconName,
              iconColor: scheme.onTertiary,
              bottomMargin: 32,
              header: PartyHistoryConst.partyHistoryHeader,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  CustomTabBar(
                    initialIndex: currentIndex,
                    header: "",
                    subTitles: [
                      GameSettingConsts.gameWithComputerText,
                      GameSettingConsts.gameWithHumanText,
                    ],
                    isSettingsPage: false,
                    onTap: (chose) {
                      setState(() {
                        currentIndex = chose;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const InfoPartyBar(),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
