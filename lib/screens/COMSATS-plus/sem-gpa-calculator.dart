import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/comsats_plus_controller.dart';

class SemesterGPAcalculator extends StatefulWidget {
  @override
  State<SemesterGPAcalculator> createState() => _SemesterGPAcalculatorState();
}

class _SemesterGPAcalculatorState extends State<SemesterGPAcalculator> {
  final SemesterGPAcalculatorController controller = Get.put(
    SemesterGPAcalculatorController(),
  );
  late ScrollController _scrollController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });

    controller.courses.listen((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && mounted) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void calculateSGPA(List<Course> courses) {
    try {
      double totalQualityPoints = 0;
      double totalCredits = 0;
      for (var course in courses) {
        double gpa = double.parse(course.gpaController.text.trim());
        double credit = double.parse(course.creditController.text.trim());
        if (gpa > 4) {
          Get.snackbar(
            'Wrong Information',
            'GPA should be less than 4',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.8),
            colorText: Colors.white,
          );
          return;
        }
        if (gpa < 0) {
          Get.snackbar(
            'Wrong Information',
            'GPA cannot be negative.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.8),
            colorText: Colors.white,
          );
          return;
        }
        if (credit < 1) {
          Get.snackbar(
            'Wrong Information',
            'Credit hours cannot be less than 1',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.8),
            colorText: Colors.white,
          );
          return;
        }
        totalQualityPoints += gpa * credit;
        totalCredits += credit;
      }
      controller.calculateGPA(totalQualityPoints, totalCredits);
    } catch (e) {
      Get.snackbar(
        'Wrong Information',
        'Please fill all the fields correctly',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semester GPA Calculator'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  controller: _scrollController,
                  itemCount: controller.courses.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Course ${index + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                cursorColor: Color(0xFF06B6D4),
                                controller:
                                    controller.courses[index].gpaController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "GPA",
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                cursorColor: Color(0xFF06B6D4),
                                controller:
                                    controller.courses[index].creditController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Credit Hours",
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            controller.courses.length > 1
                                ? Center(
                                    child: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () =>
                                          controller.removeCourse(index),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Obx(
              () => TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: controller.result / 4),
                duration: Duration(milliseconds: 700),
                builder: (context, value, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: CircularProgressIndicator(
                          value: value,
                          strokeWidth: 6,
                          backgroundColor: Colors.grey.shade300,
                          color: Color(0xFF06B6D4),
                        ),
                      ),
                      Text(
                        controller.result.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF06B6D4),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    controller.addCourse();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF06B6D4),
                  ),
                  child: Text("Add Course"),
                ),
                ElevatedButton(
                  onPressed: () {
                    calculateSGPA(controller.courses);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF06B6D4),
                  ),
                  child: Text("Calculate"),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
