import 'package:demo_chatbot/screens/COMSATS-plus/sem-gpa-calculator.dart';
import 'package:demo_chatbot/screens/COMSATS-plus/target-cgpa-calculator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

import 'cgpa-calculator.dart';
import 'course-grade-calculator.dart';

class CGPAcalc extends StatelessWidget {
  const CGPAcalc({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildcalcTile(
                  icon: Icons.insert_chart_outlined_sharp,
                  title: 'Course Grade Calculator',
                  subtitle:
                      'Calculate the grade of a course by entering its details',
                  onTap: () {
                    Get.to(() => CourseGradeCalculator());
                  },
                ),
                _buildcalcTile(
                  icon: Icons.insert_chart_outlined_sharp,
                  title: 'Semester GPA Calculator',
                  subtitle:
                      'Calculate the GPA of a semester by entering the GPA and credit hours of each course',
                  onTap: () {
                    Get.to(() => SemesterGPAcalculator());
                  },
                ),
                _buildcalcTile(
                  icon: Icons.insert_chart_outlined_sharp,
                  title: 'CGPA Calculator',
                  subtitle:
                      'Calculate CGPA by entering previous CGPA and current semester GPA',
                  onTap: () {
                    Get.to(() => CGPAcalculator());
                  },
                ),
                _buildcalcTile(
                  icon: Icons.insert_chart_outlined_sharp,
                  title: 'GPA Planning Calculator',
                  subtitle:
                      'Determine the minimum GPA needed in current semester to achieve a target CGPA',
                  onTap: () {
                    Get.to(() => TargetCGPAcalculator());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildcalcTile({
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
                      fontFamily: 'p-m-font',
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFFCBD5E1),
                      fontWeight: FontWeight.w900,
                      fontFamily: 'p-s-font',
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
