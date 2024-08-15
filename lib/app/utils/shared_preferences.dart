import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> setAsFirstEnterIntroPage() async {
    await _prefs?.setBool("as_first_intro_page", false);
  }

  static bool get getAsFirstEnterIntroPage {
    return _prefs?.getBool("as_first_intro_page") ?? true;
  }
}
