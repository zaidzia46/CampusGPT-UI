import 'package:demo_chatbot/api_conn/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../conn_check/conn_check.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final bool isLoading;
  final String query; // NEW
  final String response; // NEW
  int? savedId; // NEW — nullable, not final (changes when saved/unsaved)
  RxBool isLiked;
  RxBool isDisliked;
  RxBool isSaved;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isLoading = false,
    this.query = '',
    this.response = '',
    this.savedId,
    bool liked = false,
    bool disliked = false,
    bool saved = false,
  }) : isLiked = liked.obs,
       isDisliked = disliked.obs,
       isSaved = saved.obs;
}

class ChatController extends GetxController {
  var messages = <ChatMessage>[].obs;
  var llmresponse = '';

  @override
  void onInit() {
    super.onInit();
    messages.add(
      ChatMessage(text: 'Hello! How can I help you today?', isUser: false),
    );
  }

  Future<void> sendMessage(String text) async {
    messages.add(ChatMessage(text: text, isUser: true));
    bool hasInternet = await checkInternetConnection();
    if (!hasInternet) return;
    // 2. Add loader message immediately
    final loaderMessage = ChatMessage(text: '', isUser: false, isLoading: true);
    messages.add(loaderMessage);

    try {
      final response = await APIClient.dio.post(
        '/student/query',
        data: {'query_text': text},
      );
      llmresponse = response.data['response'];

      // 3. Replace loader with actual response
      // Replace loader with actual response
      final index = messages.indexOf(loaderMessage);
      if (index != -1) {
        messages[index] = ChatMessage(
          text: llmresponse,
          isUser: false,
          query: text,
          response: llmresponse,
        );
      }
    } on DioException {
      // 4. Remove loader on error
      messages.remove(loaderMessage);
      Get.snackbar(
        'Error',
        'Please try later',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
}

class QueryFeedbackController extends GetxController {
  final List<String> reasons = [
    "Incorrect or incomplete",
    "Not what I asked for",
    "Slow or buggy",
    "Style or tone",
    "Safety or legal concern",
    "Other",
  ];

  RxString selectedReason = ''.obs;
}
