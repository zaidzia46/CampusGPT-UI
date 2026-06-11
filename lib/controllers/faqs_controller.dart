import 'package:get/get.dart';

class FAQ {
  final String question;
  final String answer;

  FAQ({required this.question, required this.answer});
}

class FAQsController extends GetxController {
  var faqs = <FAQ>[].obs;

  @override
  void onInit() {
    super.onInit();
    faqs.addAll([
      FAQ(
        question: 'What is AI Campus Assistant?',
        answer:
            'AI Campus Assistant is a smart chatbot that helps students and staff find campus-related information.',
      ),
      FAQ(
        question: 'What kind of questions can I ask?',
        answer:
            'You can ask about admissions, fee structure, academic schedules, room locations, faculty information and campus facilities.',
      ),
      FAQ(
        question: 'What should I do if the answer is incorrect?',
        answer: 'You can report incorrect responses using the feedback option.',
      ),
      FAQ(
        question: 'Why does the chatbot sometimes not answer my question?',
        answer:
            'If the information is not available in the system’s knowledge base, the chatbot may not be able to answer it.',
      ),
      FAQ(
        question: 'Does the app store my previous questions?',
        answer:
            'Yes, you can save your specific chats by enabling the save option under chat.',
      ),
      FAQ(
        question: 'Do I need internet to use the app?',
        answer:
            'Yes, an internet connection is required because the chatbot communicates with the server to retrieve information and generate responses.',
      ),
      FAQ(
        question: 'Who manages the information in the system?',
        answer:
            'Authorized university administrators manage the knowledge base by uploading documents and reviewing feedback.',
      ),
    ]);
  }
}
