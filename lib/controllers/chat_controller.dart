import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:demo_chatbot/api_conn/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  RxBool isLiked;
  RxBool isDisliked;

  ChatMessage({
    required this.text,
    required this.isUser,
    bool liked = false,
    bool disliked = false,
  }) : isLiked = liked.obs,
       isDisliked = disliked.obs;
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

  Future<bool> checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> sendMessage(String text) async {
    messages.add(ChatMessage(text: text, isUser: true));
    bool hasInternet = await checkInternet();
    if (!hasInternet) {
      Get.snackbar(
        "No Internet",
        "Please check your internet connection",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    try {
      final response = await APIClient.dio.post(
        '/student/query',
        data: {'query_text': text},
      );
      llmresponse = response.data['response'];
    } on DioException {
      Get.snackbar(
        'Error',
        'Please try later',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.greenAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
    Future.delayed(const Duration(seconds: 1), () {
      messages.add(ChatMessage(text: llmresponse, isUser: false));
    });
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
