import "package:flutter/material.dart";
import "theme_data.dart";

class ThemeProvider extends ChangeNotifier {

  late ThemeData _themeData;
  String _theme = "light";

  ThemeData get themeData {
    _themeData = _theme == "dark" ? darkMode : lightMode;
    return _themeData;
  }

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() async {
    if (_themeData == lightMode) {
      _theme = "dark";
      themeData = darkMode;
    }
    else {
      _theme = "light";
      themeData = lightMode;
    }
  }
}