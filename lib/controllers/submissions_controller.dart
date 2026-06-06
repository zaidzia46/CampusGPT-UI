import 'package:demo_chatbot/api_conn/dio.dart';
import 'package:get/get.dart';

class SubmissionsController extends GetxController {
  final mySubmissions = <dynamic>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadMySubmissions();
  }

  Future<void> loadMySubmissions() async {
    isLoading.value = true;
    try {
      final data = await APIClient.getMySubmissions();
      mySubmissions.value = data;
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }
}
