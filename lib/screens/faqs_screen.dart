import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/faqs_controller.dart';

class FAQsScreen extends StatefulWidget {
  const FAQsScreen({Key? key}) : super(key: key);

  @override
  State<FAQsScreen> createState() => _FAQsScreenState();
}

class _FAQsScreenState extends State<FAQsScreen> {
  final FAQsController faqsController = Get.put(FAQsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(child: feedback_body()),
    );
  }

  Obx feedback_body() {
    return Obx(() {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqsController.faqs.length,
        itemBuilder: (context, index) {
          final faq = faqsController.faqs[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: ExpansionTile(
              shape: Border(),
              collapsedShape: Border(),
              title: Text(
                faq.question,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontFamily: 'p-m-font',
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    faq.answer,
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFFCBD5E1),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
