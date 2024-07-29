import 'package:frontend/model/app_model.dart';
import 'package:frontend/theme/theme_data.dart';
import 'package:frontend/views/my_menu.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'logic/shared_functions.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppModel(),
      child: MyApp(),
    ),
  );
  _loadFlameAssets();
}

void _loadFlameAssets() async {
  List<String> pieceImages = [];
  for (var color in ['black', 'white']) {
    for (var piece in ['king', 'queen', 'rook', 'bishop', 'knight', 'pawn']) {
      pieceImages
          .add('pieces/${formatPieceTheme("Classic")}/${piece}_$color.png');
    }
  }
  await Flame.images.loadAll(pieceImages);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //theme: Provider.of<AppModel>(context).newTheme,
      theme: lightMode,
      home: MyMenuView(),
    );
  }
}
