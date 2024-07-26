import 'package:frontend/constants/colors.dart';
import 'package:frontend/model/app_model.dart';
import 'package:frontend/theme/theme.dart';
import 'package:frontend/views/components/button_to_guide.dart';
import 'package:frontend/views/components/custom_switch.dart';
import 'package:frontend/views/components/next_page_button.dart';
import 'package:frontend/views/game_settings_view.dart';
import 'package:frontend/views/guide/guide_chose_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

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
    var provider = Provider.of<AppModel>(context, listen: false);
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
                      height: 54,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomSwitch(
                          onChanged: (value) {
                            setState(() {
                              //provider.toggleTheme();
                              //provider.theme == lightMode ? piecesFile = "pieces_light" : piecesFile = "pieces_dark";
                            });
                          },
                        ),
                        ButtonToGuide(
                          backGroundColor: scheme.onPrimaryContainer,
                          iconColor: ColorsConst.neutralColor0,
                          height: 32,
                          width: 32,
                          iconSize: 18,
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
                                color: scheme.primary),
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
