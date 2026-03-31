import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/comsats_plus_controller.dart';

class CGPAcalculator extends StatelessWidget {
  final CGPAcalculatorController cgpaController = Get.put(
    CGPAcalculatorController(),
  );

  final TextEditingController preCreditsController = TextEditingController();

  final TextEditingController currCgpaController = TextEditingController();

  final TextEditingController currCreditsController = TextEditingController();

  final TextEditingController currGpaController = TextEditingController();

  double result = 0.0;

  void calculate() {
    try {
      double preCredits = double.parse(preCreditsController.text.trim());
      double currCgpa = double.parse(currCgpaController.text.trim());
      double currCredits = double.parse(currCreditsController.text.trim());
      double currGpa = double.parse(currGpaController.text.trim());

      if (currGpa > 4 || currCgpa > 4) {
        Get.snackbar(
          'Wrong Information',
          'CGPA and GPA should be less than 4',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white,
        );
        return;
      }

      if (currGpa < 0 || currCgpa < 0 || preCredits < 0 || currCredits < 0) {
        Get.snackbar(
          'Wrong Information',
          'Credit hours and GPA cannot be negative.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white,
        );
        return;
      }

      double add1 = (preCredits * currCgpa) + (currCredits * currGpa);
      double add2 = preCredits + currCredits;
      cgpaController.calcgpa(add1, add2);
    } catch (e) {
      print(e);
      Get.snackbar(
        'Wrong Information',
        'Please fill all the fields correctly',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  bool validatefields() {
    final text1 = preCreditsController.text.trim();
    final text2 = currCgpaController.text.trim();
    final text3 = currCreditsController.text.trim();
    final text4 = currGpaController.text.trim();

    if (text1.isEmpty || text2.isEmpty || text3.isEmpty || text4.isEmpty) {
      Get.snackbar(
        'Missing Information',
        'Please fill all the fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CGPA Calculator'), elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildtextfield(
                  label: 'Previous Credits',
                  controller: preCreditsController,
                ),
                _buildtextfield(
                  label: 'Current CGPA',
                  controller: currCgpaController,
                ),
                _buildtextfield(
                  label: 'Current Semester Credits',
                  controller: currCreditsController,
                ),
                _buildtextfield(
                  label: 'Current Semester GPA',
                  controller: currGpaController,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (validatefields()) {
                      calculate();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF06B6D4),
                  ),
                  child: Text('Calculate'),
                ),
                SizedBox(height: 40),
                Obx(
                  () => TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: cgpaController.result / 4),
                    duration: Duration(milliseconds: 700),
                    builder: (context, value, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: CircularProgressIndicator(
                              value: value,
                              strokeWidth: 6,
                              backgroundColor: Colors.grey.shade300,
                              color: Color(0xFF06B6D4),
                            ),
                          ),
                          Text(
                            cgpaController.result.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF06B6D4),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildtextfield({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        cursorColor: Color(0xFF06B6D4),
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
