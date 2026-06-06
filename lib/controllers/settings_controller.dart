import 'dart:convert';

import 'package:demo_chatbot/screens/splash_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final _storage = const FlutterSecureStorage();
  final userRole = ''.obs; // ← add this

  @override
  void onInit() {
    super.onInit();
    loadUserRole(); // ← add this
  }

  Future<void> loadUserRole() async {
    try {
      final token = await _storage.read(key: 'access_token');
      if (token == null) return;

      final parts = token.split('.');
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final data = jsonDecode(payload);

      userRole.value = data['role'] ?? '';
    } catch (_) {}
  }

  void logout() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(SplashScreenState.KEYLOGIN, false);
    print('User logged out');
  }
}
