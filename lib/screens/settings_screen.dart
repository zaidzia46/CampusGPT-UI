import 'package:demo_chatbot/screens/settings/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import 'settings/privacy_policy.dart';
import 'settings/about_app.dart';
import 'settings/feedback_screen.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsController settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(child: settings_body()),
    );
  }

  SingleChildScrollView settings_body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSettingSection(
              title: 'Account',
              children: [
                _buildSettingTile(
                  icon: Icons.lock,
                  title: 'Change Password',
                  subtitle: 'Update your password',
                  onTap: () {
                    Get.to(() => UpdatePwd());
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSettingSection(
              title: 'Feedback',
              children: [
                _buildSettingTile(
                  icon: Icons.person,
                  title: 'Feedback',
                  subtitle: 'Give your feedback',
                  onTap: () {
                    Get.to(() => const FeedbackScreen());
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSettingSection(
              title: 'About',
              children: [
                _buildSettingTile(
                  icon: Icons.info,
                  title: 'About App',
                  subtitle: 'Version 1.0.0',
                  onTap: () {
                    Get.to(AboutApp());
                  },
                ),
                _buildSettingTile(
                  icon: Icons.privacy_tip,
                  title: 'Privacy Policy',
                  subtitle: 'Read our policy',
                  onTap: () {
                    Get.to(PrivacyPolicy());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontFamily: 'p-m-font',
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF06B6D4)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: 'p-m-font',
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFFCBD5E1),
                      fontFamily: 'p-m-font',
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
