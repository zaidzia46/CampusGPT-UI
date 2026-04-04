import 'package:demo_chatbot/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/starry_background.dart';
import 'COMSATS-plus/cgpa-calc(main).dart';
import 'chat_screen.dart';
import 'events_screen.dart';
import 'faqs_screen.dart';
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
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ChatScreen(),
    const CGPAcalc(),
    const FAQsScreen(),
    const SettingsScreen(),
  ];

  final List<String> _screenTitles = [
    'CampusGPT',
    'COMSATS Plus',
    'FAQs',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      drawer: _buildDrawer(context),
      body: StarryBackground(child: _screens[_selectedIndex]),
      appBar: AppBar(
        title: Text(_screenTitles[_selectedIndex]),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0F172A),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF06B6D4),
              // gradient: LinearGradient(
              //   colors: [Color(0xFF7C3AED), Color(0xFF03788c)],
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              // ),
            ),
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
            icon: Icons.feed_outlined,
            title: 'COMSATS Plus',
            index: 1,
            context: context,
          ),
          _buildDrawerItem(
            icon: Icons.help,
            title: 'Frequently Asked Question',
            index: 2,
            context: context,
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            index: 3,
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
    final bool isSelected = _selectedIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Color(0xFF06B6D4) : Colors.white70,
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: isSelected ? Color(0xFF06B6D4) : Colors.white70,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          fontSize: 15,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.white.withOpacity(0.1),
      onTap: () {
        setState(() => _selectedIndex = index);
        Navigator.pop(context);
      },
    );
  }
}
