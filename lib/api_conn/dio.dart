import 'dart:convert';

import 'package:demo_chatbot/screens/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../controllers/settings_controller.dart';

class APIClient {
  static final FlutterSecureStorage storage = const FlutterSecureStorage();
  static final String baseUrl = dotenv.env['API_URL'] ?? '';
  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: baseUrl,
            headers: {'Content-Type': 'application/json'},
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final accesstoken = await storage.read(key: 'access_token');
              if (accesstoken != null ||
                  !options.path.contains('login') ||
                  !options.path.contains('register') ||
                  !options.path.contains('forgot-password')) {
                options.headers['Authorization'] = 'Bearer $accesstoken';
              }

              return handler.next(options);
            },
            onError: (DioException error, handler) async {
              final SettingsController settingsController = Get.put(
                SettingsController(),
              );
              if (error.response?.statusCode == 401) {
                final newaccesstoken = await refreshtoken();
                if (newaccesstoken != null) {
                  final option = error.requestOptions;
                  option.headers['Authorization'] = 'Bearer $newaccesstoken';

                  final clonedRequest = await APIClient.dio.fetch(
                    error.requestOptions,
                  );

                  return handler.resolve(clonedRequest);
                } else {
                  settingsController.logout();
                  await storage.deleteAll();
                  Get.offAll(() => const LoginScreen());
                }
              }
              return handler.next(error);
            },
          ),
        );
  static Future<String?> refreshtoken() async {
    final refresh_token = await storage.read(key: 'refresh_token');
    try {
      final response = await Dio().post(
        '$baseUrl/refresh',
        data: jsonEncode(refresh_token),
      );

      final newAccessToken = response.data["access_token"];
      // print("New access token: $newAccessToken");
      await storage.write(key: 'access_token', value: newAccessToken);
      // print('-----------new_access_token_generated-----------------');
      return newAccessToken;
    } on DioException catch (e) {
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      return null;
    }
  }

  static Future<List<dynamic>> getNotifications() async {
    final res = await dio.get('/student/notifications');
    return res.data;
  }

  static Future<int> getUnreadCount() async {
    final res = await dio.get('/student/notifications/unread-count');
    return res.data['unread_count'];
  }

  static Future<void> markAsRead(int notificationId) async {
    await dio.patch('/student/notifications/$notificationId/read');
  }

  static Future<void> markAllRead() async {
    await dio.patch('/student/notifications/mark-all-read');
  }

  static Future<List<dynamic>> getMySubmissions() async {
    final res = await dio.get('/student/faculty/my-submissions');
    return res.data;
  }
}
