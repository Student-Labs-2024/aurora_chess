import 'package:flutter/material.dart';
import 'package:frontend/exports.dart';
import 'package:sqflite/sqflite.dart';

class PartyHistoryMainView extends StatefulWidget {
  const PartyHistoryMainView({super.key});

  @override
  State<PartyHistoryMainView> createState() => _PartyHistoryMainViewState();
}

class _PartyHistoryMainViewState extends State<PartyHistoryMainView> {
  int currentIndex = 0;
  int currentLength = 0;
  bool isLoading = true;
  List<Map> friendParties = [];
  List<Map> computerParties = [];

  void _getParties() async {
    var databasesPath = await getDatabasesPath();
    String path = "$databasesPath/parties.db";
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(PartyHistoryConst.dbCreateScript);
        });
    List<Map> list =
        await database.rawQuery(PartyHistoryConst.dbGetHistoryScript);

    for (var party in list) {
      if (party["enemy"] == "Компьютер") {
        computerParties.add(party);
      }
      else {
        friendParties.add(party);
      }
    }

    setState(() {
      currentLength = computerParties.length;
      isLoading = false;
    });

    await database.close();
  }

  @override
  void initState() {
    _getParties();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return isLoading
      ? const LoadingWidget()
      : SafeArea(
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
                        currentLength = chose == 0
                            ? computerParties.length
                            : friendParties.length;
                      });
                    },
                  ),
                  currentIndex == 0
                      ? const InfoPartyBar()
                      : const SizedBox(),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: currentLength,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return  OnePartyViewWidget(
                    isComputer: currentIndex == 0,
                    partyData: currentIndex == 0
                        ? computerParties[index]
                        : friendParties[index],
                  );
                }
              ),
            ),
          ],
        ),
      )
    );
  }
}
