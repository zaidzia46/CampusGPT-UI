import 'package:demo_chatbot/screens/splash_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  void logout() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(SplashScreenState.KEYLOGIN, false);
    print('User logged out');
  }
}
