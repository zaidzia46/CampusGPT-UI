import 'package:demo_chatbot/screens/splash_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var currentUser = ''.obs;
  var isLoadingForSignup = false.obs;
  var isLoadingForLogin = false.obs;

  void login(String email, String password) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(SplashScreenState.KEYLOGIN, true);
    currentUser.value = email;
  }
}
