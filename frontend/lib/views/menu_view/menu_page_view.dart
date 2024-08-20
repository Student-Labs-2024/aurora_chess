import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";
import "../../exports.dart";

class MyMenuView extends StatefulWidget {
  static MyMenuView builder(BuildContext context, GoRouterState state) =>
      const MyMenuView();
  const MyMenuView({super.key});

  @override
  State<MyMenuView> createState() => _MyMenuViewState();
}

class _MyMenuViewState extends State<MyMenuView> {

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    final scheme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final aspectRatio = height / width;
    return Scaffold(
      backgroundColor: scheme.background,
      body: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: width, minHeight: height),
          child: IntrinsicHeight(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomSwitch(provider),
                          ButtonToGuide(
                            backGroundColor: scheme.secondaryContainer,
                            height: 40,
                            width: 40,
                            onTap: () {
                              context.push(RouteLocations.guidebookScreen);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        MenuPageStringConst.slogan,
                        style: TextStyle(
                          fontSize: 36,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          color: scheme.primary
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "${MenuPageStringConst.pathToIcon}pieces.png",
                          width: aspectRatio > 2
                              ? width * 0.9
                              : (height - width) * 0.8,
                        ),
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
                        text: MenuPageStringConst.localButton,
                        textColor: ColorsConst.primaryColor0,
                        buttonColor: scheme.secondaryContainer,
                        isClickable: true,
                        onTap: () {
                          context.go(RouteLocations.settingsScreen);
                        },
                      ),
                    ),
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
