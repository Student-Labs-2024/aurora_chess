import 'package:flutter/material.dart';

class AppTheme {
  String? name;
  LinearGradient? background;
  Color lightTile;
  Color darkTile;
  Color moveHint;
  Color checkHint;
  Color latestMove;
  Color border;

  AppTheme({
    this.name,
    this.background,
    this.lightTile = const Color(0xFFC9B28F),
    this.darkTile = const Color(0xFF69493b),
    this.moveHint = const Color(0xdd5c81c4),
    this.latestMove = const Color(0xccc47937),
    this.checkHint = const Color(0x88ff0000),
    this.border = const Color(0xffffffff),
  });
}

List<AppTheme> get themeList {
  var themeList = <AppTheme>[
    AppTheme(
      name: 'Grey',
      background: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xffb2b2b2),
          Color(0xff4e4e4e),
        ],
      ),
      lightTile: Color(0xFFC6BAAA),
      darkTile: Color(0xFF806C61),
      moveHint: Color(0xdd555555),
      checkHint: Color(0xff333333),
      latestMove: Color(0xdddddddd),
    ),
    AppTheme(
      name: 'Dark',
      background: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff1e1e1e),
          Color(0xff2e2e2e),
        ],
      ),
      lightTile: Color(0xff444444),
      darkTile: Color(0xff333333),
      border: Color(0xff555555),
    ),
  ];
  return themeList;
}
