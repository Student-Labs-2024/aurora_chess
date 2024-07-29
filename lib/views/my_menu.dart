import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../exports.dart';

class MyMenuView extends StatefulWidget {
  const MyMenuView({super.key});

  @override
  State<MyMenuView> createState() => _MyMenuViewState();
}

class _MyMenuViewState extends State<MyMenuView> {
  final slogan = "Побеждать\nв шахматах — побеждать\nв жизни";
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

    return Scaffold(
      backgroundColor: scheme.background,
      body: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height),
        child: IntrinsicHeight(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 55,
                    ),
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
                          height: 40,
                          width: 40,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return const GuideChoseView();
                            }));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
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
                            child: SvgPicture.asset(
                                "assets/images/icons/$piecesFile.svg"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: NextPageButton(
                      text: localButton,
                      textColor: ColorsConst.primaryColor0,
                      buttonColor: scheme.secondaryContainer,
                      isClickable: true,
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const GameSettingsView();
                        }));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
