import 'package:shared_preferences/shared_preferences.dart';

const String _kFlipBoardPrefs = "fbem";

class UserSettings {
  static Future<bool> get flipBoardEachTurn async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_kFlipBoardPrefs) ?? false;
  }

  static Future<bool> setFlipBoardEachTurn(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(_kFlipBoardPrefs, value);
  }
}
