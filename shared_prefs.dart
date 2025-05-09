import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static Future<void> setLoginStatus({required bool isLoggedIn, required bool isGuest}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
    await prefs.setBool('isGuest', isGuest);
  }

  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('isGuest');
  }
  static Future<bool> isGuestUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isGuest') ?? false;
  }


}
