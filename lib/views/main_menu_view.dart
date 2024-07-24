import 'package:flutter/material.dart';
import 'package:frontend/exports.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainMenuView extends StatefulWidget {
  const MainMenuView({super.key});

  @override
  State<MainMenuView> createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {

  var textStyles = const TextStyles();
  final slogan = "Побеждать в шахматах — побеждать в жизни";
  final netButton = "Сетевая игра";
  final localButton = "Локальная игра";
  String piecesFile = "";



  @override
  initState() {
    piecesFile = "pieces_light";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ThemeProvider>(context, listen: false);
    var scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: scheme.background,
        body: ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height
          ),
          child: IntrinsicHeight(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomSwitch(
                        onChanged: (value) {
                          setState(() {
                            provider.toggleTheme();
                            piecesFile = provider.isDarkMode ? "pieces_dark" : "pieces_light";
                          });
                        },
                      ),
                      ButtonToGuide(
                        backGroundColor: scheme.onPrimaryContainer,
                        iconColor: ColorsConst.neutralColor0,
                        height: 32,
                        width: 32,
                        iconSize: 18,
                        onTap: () {},
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 40, top: 20),
                        child: Text(
                          slogan,
                          style: textStyles.title1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 190),
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: SvgPicture.asset("assets/images/icons/$piecesFile.svg"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30,),
                  const SizedBox(height: 60,),
                  const SizedBox(height: 24,),
                  NextPageButton(
                    text: localButton,
                    textColor: ColorsConst.primaryColor0,
                    buttonColor: scheme.secondaryContainer,
                    isClickable: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return const GameSettingsView();
                        })
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}