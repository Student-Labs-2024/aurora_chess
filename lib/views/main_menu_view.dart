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

  final slogan = "Побеждать\nв шахматах — побеждать\nв жизни";
  final localButton = "Начать игру";
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

    return Scaffold(
      backgroundColor: scheme.background,
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
          minHeight: MediaQuery.of(context).size.height
        ),
        child: IntrinsicHeight(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(height: 54,),
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
                      backGroundColor: scheme.secondaryContainer,
                      iconColor: ColorsConst.neutralColor0,
                      height: 32,
                      width: 32,
                      iconSize: 18,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return const GuideChoseView();
                          })
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 40,),
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 40),
                      child: Text(
                        slogan,
                        style: TextStyle(
                          fontSize: 36,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          color: scheme.primary
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 220),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: SvgPicture.asset("assets/images/icons/$piecesFile.svg"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48,),
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
                const SizedBox(height: 22,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}