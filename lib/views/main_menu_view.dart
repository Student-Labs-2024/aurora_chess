import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/exports.dart';
import 'package:frontend/views/components/components.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainMenuView extends StatefulWidget {
  const MainMenuView({super.key});

  @override
  State<MainMenuView> createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {

  var textStyles = const TextStyles();
  final String slogan = "Побеждать в шахматах — побеждать в жизни";
  final String netButton = "Сетевая игра";
  final String localButton = "Локальная игра";
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
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 27),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomSwitch(
                    onChanged: () {
                      setState(() {
                        provider.toggleTheme();
                        piecesFile = provider.isDarkMode ? "pieces_dark" : "pieces_light";
                      });
                    },
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: scheme.primary,
                      ),
                      child: Icon(
                        Icons.question_mark,
                        color: scheme.background,
                      )
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(right: 40, top: 47),
                child: Text(
                  slogan,
                  style: textStyles.title1,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: SvgPicture.asset("assets/images/icons/$piecesFile.svg"),
              ),
              const SizedBox(height: 30,),
              NextPageButton(
                text: netButton,
                textColor: ColorsConst.primaryColor0,
                buttonColor: scheme.onSecondaryContainer,
                onTap: () {print(netButton);},
              ),
              const SizedBox(height: 24,),
              NextPageButton(
                text: localButton,
                textColor: scheme.background,
                buttonColor: scheme.secondaryContainer,
                onTap: () {print(localButton);},
              ),
            ],
          ),
        ),
      ),
    );
  }
}