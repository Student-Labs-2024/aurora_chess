import "package:frontend/exports.dart";
import "package:flame/flame.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:provider/provider.dart";

void main() {
  runApp(
    const MyApp()
  );
  _loadFlameAssets();
}

void _loadFlameAssets() async {
  List<String> pieceImages = [];
  for (var color in ["black", "white"]) {
    for (var piece in ["king", "queen", "rook", "bishop", "knight", "pawn"]) {
      pieceImages
          .add("pieces/${piece}_$color.png");
    }
  }
  await Flame.images.loadAll(pieceImages);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GameModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: Provider.of<ThemeProvider>(context).themeData,
            routerConfig: router,
          );
        }
      ),
    );
  }
}
