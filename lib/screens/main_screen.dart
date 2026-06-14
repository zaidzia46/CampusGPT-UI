import 'dart:async';

import 'package:demo_chatbot/controllers/settings_controller.dart';
import 'package:demo_chatbot/controllers/main_screen_controller.dart';
import 'package:demo_chatbot/screens/saved_chats.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../api_conn/dio.dart';
import '../controllers/notification_controller.dart';
import '../widgets/starry_background.dart';
import 'COMSATS-plus/cgpa-calc(main).dart';
import 'SubmitInfoScreen.dart';
import 'chat_screen.dart';
import 'events_screen.dart';
import 'faqs_screen.dart';
import 'notifications_screen.dart';
import 'settings/feedback_screen.dart';
import 'login_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final SettingsController settingsController = Get.put(SettingsController());
  final NotificationController notifController = Get.put(
    NotificationController(),
  );
  final MainScreenController mainScreenController = Get.put(
    MainScreenController(),
  );

  Future<bool> _handleBackPressed() async {
    if (mainScreenController.selectedIndex.value != 0) {
      mainScreenController.setIndex(0);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackPressed,
      child: Obx(() {
        final bool isFaculty = settingsController.userRole.value == 'faculty';
        final int settingsIndex = isFaculty ? 5 : 4;
        final List<Widget> _screens = [
          const ChatScreen(),
          const SavedChats(),
          const CGPAcalc(),
          const FAQsScreen(),
          if (isFaculty) const SubmitInfoScreen(),
          const SettingsScreen(),
        ];

        final List<String> _screenTitles = [
          'CampusGPT',
          'Saved Chats',
          'COMSATS Plus',
          'FAQs',
          if (isFaculty) 'Submit Information',
          'Settings',
        ];

        final int activeIndex = mainScreenController.selectedIndex.value.clamp(
          0,
          _screens.length - 1,
        );

        return Scaffold(
          extendBody: true,
          drawer: _buildDrawer(context),
          body: StarryBackground(child: _screens[activeIndex]),
          appBar: AppBar(
            title: Text(_screenTitles[activeIndex]),
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Scaffold(
                            extendBody: true,
                            appBar: AppBar(
                              title: const Text('Notifications'),
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                            ),
                            body: StarryBackground(
                              child: NotificationsScreen(
                                onAllRead: () => notifController.resetCount(),
                              ),
                            ),
                          ),
                        ),
                      );
                      notifController.loadUnreadCount();
                    },
                  ),

                  // ← Obx replaces setState here
                  Obx(
                    () => notifController.unreadCount.value > 0
                        ? Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                notifController.unreadCount.value > 99
                                    ? '99+'
                                    : '${notifController.unreadCount.value}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    final bool isFaculty = settingsController.userRole.value == 'faculty';
    final int settingsIndex = isFaculty ? 5 : 4;

    return Drawer(
      backgroundColor: const Color(0xFF0F172A),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF06B6D4)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.school, size: 40, color: Color(0xFF06B6D4)),
                ),
                const SizedBox(height: 12),
                Text(
                  'CampusGPT',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Your smart university guide',
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.chat_bubble,
            title: 'CampusGPT',
            index: 0,
            context: context,
          ),
          _buildDrawerItem(
            icon: Icons.bookmarks_sharp,
            title: 'Saved Chats',
            index: 1,
            context: context,
          ),
          _buildDrawerItem(
            icon: Icons.feed_outlined,
            title: 'COMSATS Plus',
            index: 2,
            context: context,
          ),
          _buildDrawerItem(
            icon: Icons.help,
            title: 'Frequently Asked Question',
            index: 3,
            context: context,
          ),
          if (settingsController.userRole.value == 'faculty')
            _buildDrawerItem(
              icon: Icons.upload_file_outlined,
              title: 'Submit Information',
              index: 4,
              context: context,
            ),
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            index: settingsIndex,
            context: context,
          ),
          const Divider(color: Colors.white10),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: Text(
              'Logout',
              style: GoogleFonts.inter(
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              settingsController.logout();
              Get.offAll(() => const LoginScreen());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
    required BuildContext context,
  }) {
    return Obx(() {
      final bool isSelected = mainScreenController.selectedIndex.value == index;
      return ListTile(
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFF06B6D4) : Colors.white70,
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            color: isSelected ? const Color(0xFF06B6D4) : Colors.white70,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 15,
          ),
        ),
        selected: isSelected,
        selectedTileColor: Colors.white.withOpacity(0.1),
        onTap: () {
          mainScreenController.setIndex(index);
          Navigator.pop(context);
        },
      );
    });
  }
}
