import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About App'), elevation: 0),
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
                        'AI Campus Assistant is a mobile application designed to help students, faculty, and visitors quickly access important campus information through an intelligent chatbot interface.\n\n',
                  ),

                  TextSpan(
                    text:
                        'The application uses Artificial Intelligence to understand user questions and provide accurate answers based on official university information. Instead of searching through multiple websites or notice boards, users can simply ask the assistant and receive instant responses.\n\n',
                  ),

                  TextSpan(
                    text: 'Key Features\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  TextSpan(
                    text:
                        '• AI-powered chatbot for campus queries\n'
                        '• Quick access to university information\n'
                        '• Answers based on official documents\n'
                        '• Feedback system to improve responses\n'
                        '• Simple and user-friendly interface\n\n',
                  ),

                  TextSpan(
                    text:
                        'The goal of AI Campus Assistant is to make campus information more accessible and reduce the time students spend searching for important details.\n\n',
                  ),

                  TextSpan(
                    text: 'Developed By\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  TextSpan(
                    text:
                        'Muhammad Talha\n'
                        'Muhammad Zaid Zia\n\n'
                        'Bachelor of Science in Computer Science\n'
                        'COMSATS University Islamabad - Sahiwal Campus\n\n',
                  ),

                  TextSpan(
                    text: 'Supervisor\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  TextSpan(text: 'Mr. Arslan Sarwar\n\n'),
                  TextSpan(
                    text: 'Version 1.0.0',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
