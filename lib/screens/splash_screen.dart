import 'package:demo_chatbot/screens/login_screen.dart';
import 'package:demo_chatbot/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/starry_background.dart';
import 'onboarding_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:demo_chatbot/api_conn/dio.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  static const String ONBOARDKEY = 'onboarding_key';
  static const String KEYLOGIN = 'login_key';
  static bool keyboardOPEN = true;

  @override
  void initState() {
    super.initState();
    _clearHistory();
    wheretogo();
  }

  Future<void> _clearHistory() async {
    await APIClient.dio.delete('/student/clear-history');
  }

  Future<void> wheretogo() async {
    var prefs = await SharedPreferences.getInstance();
    var onBoard = prefs.getBool(ONBOARDKEY);
    var login = prefs.getBool(KEYLOGIN);
    print('before _-_-_-_-_-_-_-_-_-_-_-_-$login _-_-_-_-_-_-_-_-_-_-_-_-');

    if (onBoard != null) {
      if (!onBoard) {
        Future.delayed(const Duration(seconds: 3), () {
          Get.offAll(() => const OnboardingScreen());
        });
      } else {
        if (login != null) {
          print(
            'not null _-_-_-_-_-_-_-_-_-_-_-_-$login _-_-_-_-_-_-_-_-_-_-_-_-',
          );
          if (!login) {
            print(
              'false _-_-_-_-_-_-_-_-_-_-_-_-$login _-_-_-_-_-_-_-_-_-_-_-_-',
            );
            Future.delayed(const Duration(seconds: 3), () {
              Get.offAll(() => const LoginScreen());
            });
          } else {
            print(
              'true _-_-_-_-_-_-_-_-_-_-_-_-$login _-_-_-_-_-_-_-_-_-_-_-_-',
            );
            Future.delayed(const Duration(seconds: 3), () {
              Get.offAll(() => const MainScreen());
            });
          }
        } else {
          print(
            'false _-_-_-_-_-_-_-_-_-_-_-_-$login _-_-_-_-_-_-_-_-_-_-_-_-',
          );
          Future.delayed(const Duration(seconds: 3), () {
            Get.offAll(() => const LoginScreen());
          });
        }
      }
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Get.offAll(() => const OnboardingScreen());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarryBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [const Color(0xFF7C3AED), const Color(0xFF06B6D4)],
                  ),
                ),
                child: Lottie.asset(
                  'assets/animation/splash_anim.json',
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF06B6D4),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'CampusGPT',
                style: TextStyle(
                  fontSize: 28,
                  // fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontFamily: 'p-m-font',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your University Guide',
                style: TextStyle(
                  fontSize: 15.5,
                  color: const Color(0xFFCBD5E1),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'i-s-font',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
