import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:demo_chatbot/screens/splash_screen.dart';
import '../widgets/starry_background.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<OnboardingPage> pages = [
    OnboardingPage(
      title: 'Welcome to AI Campus Assistant',
      description:
          'Your smart campus guide designed to help you quickly find important university information anytime.',
      icon: Icons.school,
    ),
    OnboardingPage(
      title: 'Ask Anything About Campus',
      description:
          'Get instant answers about admissions, schedules, faculty, campus facilities, and university policies.',
      icon: Icons.chat_bubble_outline,
    ),
    OnboardingPage(
      title: 'Fast & Reliable Information',
      description:
          'Receive accurate responses based on official university documents powered by AI technology.',
      icon: Icons.smart_toy,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarryBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    return OnboardingPageWidget(page: pages[index]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        pages.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: _currentPage == index
                                ? const Color(0xFF06B6D4)
                                : const Color(0xFF334155),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_currentPage == pages.length - 1) {
                            var prefs = await SharedPreferences.getInstance();
                            await prefs.setBool(
                              SplashScreenState.ONBOARDKEY,
                              true,
                            );
                            Get.offAll(() => const LoginScreen());
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Text(
                          _currentPage == pages.length - 1
                              ? 'Get Started'
                              : 'Next',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  const OnboardingPageWidget({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isSmallScreen = size.width < 380;
    final double titleSize = isSmallScreen ? 24 : 28;
    final double bodySize = isSmallScreen ? 14.5 : 16;
    final double iconBoxSize = isSmallScreen ? 104 : 120;
    final double iconSize = isSmallScreen ? 52 : 60;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: iconBoxSize,
                    height: iconBoxSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF7C3AED),
                          const Color(0xFF06B6D4),
                        ],
                      ),
                    ),
                    child: Icon(page.icon, size: iconSize, color: Colors.white),
                  ),
                  SizedBox(height: isSmallScreen ? 24 : 32),
                  Text(
                    page.title,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: titleSize,
                      height: 1.15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'p-b-font',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    page.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: bodySize,
                      height: 1.4,
                      color: const Color(0xFFCBD5E1),
                      fontFamily: 'i-m-font',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
