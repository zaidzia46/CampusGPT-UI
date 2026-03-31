import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Privacy Policy'), elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'p-s-font',
                  fontSize: 16,
                  color: Colors.white,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text:
                        'Your privacy is important to us. This Privacy Policy explains how AI Campus Assistant handles your information.\n\n',
                  ),

                  TextSpan(
                    text: 'Information We Collect\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  TextSpan(
                    text:
                        'The application may collect basic information such as:\n\n'
                        '• User queries submitted to the chatbot\n'
                        '• Feedback provided by users\n'
                        '• Basic account information if login is required\n\n'
                        'This information is used only to improve the accuracy and performance of the AI assistant.\n\n',
                  ),

                  TextSpan(
                    text: 'How We Use the Information\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  TextSpan(
                    text:
                        'The collected information is used to:\n\n'
                        '• Process and answer user queries\n'
                        '• Improve chatbot responses\n'
                        '• Identify missing or incorrect information in the knowledge base\n\n',
                  ),

                  TextSpan(
                    text: 'Data Security\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  TextSpan(
                    text:
                        'All communication between the mobile application and the backend server is secured to protect user data.\n\n',
                  ),

                  TextSpan(
                    text: 'Third-Party Services\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  TextSpan(
                    text:
                        'The application may use AI services to generate responses. These services process queries only to generate relevant answers.\n\n',
                  ),

                  TextSpan(
                    text: 'Data Sharing\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  TextSpan(
                    text:
                        'We do not sell, trade, or share personal information with third parties.\n\n',
                  ),

                  TextSpan(
                    text: 'Changes to This Policy\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  TextSpan(
                    text:
                        'This privacy policy may be updated in future versions of the application.\n\n',
                  ),

                  TextSpan(
                    text: 'Contact\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  TextSpan(
                    text:
                        'If you have questions about this policy, please contact the development team through the feedback section of the app.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
