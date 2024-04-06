import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tillkhatam/core/app_helper.dart';

class ThemeProvider with ChangeNotifier {
  String _theme = 'hafiz'; // Default theme color

  String get theme => _theme;

  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String colorValue = prefs.getString(AppHelper.pref1) ?? 'hafiz';
    _theme = colorValue;
    notifyListeners();
  }

  Future<void> setTheme(String color) async {
    _theme = color;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppHelper.pref1, color);
  }
}
