import 'package:demo_chatbot/api_conn/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/feedback_controller.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final FeedbackController feedbackController = Get.put(FeedbackController());
  final TextEditingController feedbackTextController = TextEditingController();

  Future<void> sendFeedback() async {
    try {
      final response = await APIClient.dio.post(
        '/student/feedback',
        data: {
          'feedback': feedbackTextController.text,
          'rating': feedbackController.rating.value,
        },
      );
      if (response.data['message'] == 'success') {
        Get.snackbar(
          'Success',
          'Thank you for your feedback!',
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.greenAccent.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Please try later',
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.greenAccent.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } on DioException {
      Get.snackbar(
        'Error',
        'Please try later',
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.greenAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send Feedback'), elevation: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How are we doing?',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontFamily: 'p-b-font',
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Rate your experience',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'p-b-font',
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        feedbackController.countRatings(index);
                      },
                      child: Icon(
                        Icons.star,
                        size: 40,
                        color: feedbackController.rating.value > index
                            ? const Color(0xFFFFD700)
                            : const Color(0xFF334155),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Your feedback',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'p-m-font',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                cursorColor: Color(0xFF06B6D4),
                controller: feedbackTextController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Tell us what you think...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: feedbackController.rating.value != 0
                        ? () {
                            sendFeedback();
                            Get.back();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF06B6D4),
                    ),
                    child: const Text('Submit Feedback'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
