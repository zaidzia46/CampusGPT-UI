import 'dart:async';
import 'package:demo_chatbot/api_conn/dio.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final unreadCount = 0.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    loadUnreadCount();
    _timer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => loadUnreadCount(),
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> loadUnreadCount() async {
    try {
      final count = await APIClient.getUnreadCount();
      unreadCount.value = count;
    } catch (_) {}
  }

  void resetCount() => unreadCount.value = 0;
}
