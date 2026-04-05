import 'package:demo_chatbot/controllers/comsats_plus_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseGradeCalculator extends StatefulWidget {
  @override
  State<CourseGradeCalculator> createState() => _CourseGradeCalculatorState();
}

class _CourseGradeCalculatorState extends State<CourseGradeCalculator> {
  final CourseGradeCalculatorController controller = Get.put(
    CourseGradeCalculatorController(),
  );
  final TextEditingController midController = TextEditingController();
  final TextEditingController midTotalController = TextEditingController();
  final TextEditingController finalController = TextEditingController();
  final TextEditingController finalTotalController = TextEditingController();
  final TextEditingController labMidController = TextEditingController();
  final TextEditingController labMidTotalController = TextEditingController();
  final TextEditingController labFinalController = TextEditingController();
  final TextEditingController labFinalTotalController = TextEditingController();

  bool MarksChecker(obtained, total) {
    if (obtained > total) {
      Get.snackbar(
        'Wrong Information',
        'Obtained marks cannot be greater than total marks',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
      return false;
    }
    if (obtained < 0 || total < 0) {
      Get.snackbar(
        'Wrong Information',
        'Marks cannot be negative',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  void calculateGrade(
    List<Quiz> quizzes,
    List<QuizTotal> quizzesTotal,
    List<Assign> assignments,
    List<AssignTotal> assignmentsTotal,
    List<LabAssign> labAssignments,
    List<LabAssignTotal> labAssignmentsTotal,
  ) {
    try {
      double labMarks;
      double theoryMarks;

      //Quiz total marks
      var quizObtainedTotal = 0.0;
      var quizTotalsTotal = 0.0;
      for (int i = 0; i < quizzes.length; i++) {
        if (quizzes[i].controller.text.trim().isEmpty ||
            quizzesTotal[i].controller.text.trim().isEmpty) {
          Get.snackbar(
            'Missing Information',
            'Please fill all quiz fields',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.8),
            colorText: Colors.white,
          );
          return;
        }
        double quizObtained = double.parse(quizzes[i].controller.text.trim());
        double quizTotal = double.parse(quizzesTotal[i].controller.text.trim());
        if (!MarksChecker(quizObtained, quizTotal)) return;
        quizObtainedTotal += quizObtained;
        quizTotalsTotal += quizTotal;
      }
      controller.calculateQuizMarks(quizObtainedTotal, quizTotalsTotal);

      //Assign total marks
      var assignObtainedTotal = 0.0;
      var assignTotalsTotal = 0.0;
      for (int i = 0; i < assignments.length; i++) {
        if (assignments[i].controller.text.isEmpty ||
            assignmentsTotal[i].controller.text.isEmpty) {
          Get.snackbar(
            'Missing Information',
            'Please fill all assignment fields',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.8),
            colorText: Colors.white,
          );
          return;
        }
        double assignObtained = double.parse(
          assignments[i].controller.text.trim(),
        );
        double assignTotal = double.parse(
          assignmentsTotal[i].controller.text.trim(),
        );
        if (!MarksChecker(assignObtained, assignTotal)) return;
        assignObtainedTotal += assignObtained;
        assignTotalsTotal += assignTotal;
      }
      controller.calculateAssignmentMarks(
        assignObtainedTotal,
        assignTotalsTotal,
      );

      //calculation of theory marks
      double midterm = double.parse(midController.text.trim());
      double midtermTotal = double.parse(midTotalController.text.trim());
      if (!MarksChecker(midterm, midtermTotal)) return;
      double finalterm = double.parse(finalController.text.trim());
      double finaltermTotal = double.parse(finalTotalController.text.trim());
      if (!MarksChecker(finalterm, finaltermTotal)) return;

      midterm = (midterm / midtermTotal) * 0.25 * 100;
      finalterm = (finalterm / finaltermTotal) * 0.50 * 100;

      theoryMarks =
          midterm +
          finalterm +
          controller.quizResult.value +
          controller.assignmentResult.value;

      //Lab Assign total marks
      if (controller.isChecked.value) {
        var labAssignObtainedTotal = 0.0;
        var labAssignTotalsTotal = 0.0;
        for (int i = 0; i < labAssignments.length; i++) {
          if (labAssignments[i].controller.text.isEmpty ||
              labAssignmentsTotal[i].controller.text.isEmpty) {
            Get.snackbar(
              'Missing Information',
              'Please fill all lab assignment fields',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent.withOpacity(0.8),
              colorText: Colors.white,
            );
            return;
          }
          double labAssignObtained = double.parse(
            labAssignments[i].controller.text.trim(),
          );
          double labAssignTotal = double.parse(
            labAssignmentsTotal[i].controller.text.trim(),
          );
          if (!MarksChecker(labAssignObtained, labAssignTotal)) return;
          labAssignObtainedTotal += labAssignObtained;
          labAssignTotalsTotal += labAssignTotal;
        }
        controller.calculateLabAssignmentMarks(
          labAssignObtainedTotal,
          labAssignTotalsTotal,
        );

        double labMid = double.parse(labMidController.text.trim());
        double labMidTotal = double.parse(labMidTotalController.text.trim());
        if (!MarksChecker(labMid, labMidTotal)) return;

        double labFinal = double.parse(labFinalController.text.trim());
        double labFinalTotal = double.parse(
          labFinalTotalController.text.trim(),
        );
        if (!MarksChecker(labFinal, labFinalTotal)) return;

        labMid = (labMid / labMidTotal) * 0.25 * 100;
        labFinal = (labFinal / labFinalTotal) * 0.50 * 100;

        labMarks = labMid + labFinal + controller.labAssignmentResult.value;
        controller.calculateTotalMarksWithLab(theoryMarks, labMarks);
        FocusScope.of(context).unfocus();
        return;
      }
      controller.calculateTotalMarks(theoryMarks);
      FocusScope.of(context).unfocus();
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

  bool validatefields() {
    final text1 = midController.text.trim();
    final text2 = finalController.text.trim();
    final text3 = labMidController.text.trim();
    final text4 = labFinalController.text.trim();

    if (text1.isEmpty || text2.isEmpty) {
      Get.snackbar(
        'Missing Information',
        'Please fill all the fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
      return false;
    }

    if (controller.isChecked.value) {
      if (text3.isEmpty || text4.isEmpty) {
        Get.snackbar(
          'Missing Information',
          'Please fill all the fields',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white,
        );
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Grade Calculator'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(
            () => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.all(12),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Theory",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    elevation: 4,
                    child: ExpansionTile(
                      shape: Border(),
                      collapsedShape: Border(),
                      title: Text('Quiz'),
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: controller.quizzes.length,
                                itemBuilder: (_, index) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: _buildtextfield(
                                          label: 'Obtained',
                                          controller: controller
                                              .quizzes[index]
                                              .controller,
                                        ),
                                      ),
                                      SizedBox(width: 3),
                                      Expanded(
                                        child: _buildtextfield(
                                          label: 'Total',
                                          controller: controller
                                              .quizzesTotal[index]
                                              .controller,
                                        ),
                                      ),
                                      controller.quizzes.length == 1
                                          ? SizedBox()
                                          : SizedBox(width: 3),
                                      controller.quizzes.length == 1
                                          ? SizedBox()
                                          : IconButton(
                                              onPressed: () {
                                                controller.removeQuiz(index);
                                              },
                                              icon: Icon(Icons.delete),
                                            ),
                                      SizedBox(width: 3),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            controller.addQuiz();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF06B6D4),
                          ),
                          child: Text("Add Quiz"),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                  Card(
                    elevation: 4,
                    child: ExpansionTile(
                      shape: Border(),
                      collapsedShape: Border(),
                      title: Text('Assignment'),
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: controller.assignments.length,
                                itemBuilder: (_, index) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: _buildtextfield(
                                          label: 'Obtained',
                                          controller: controller
                                              .assignments[index]
                                              .controller,
                                        ),
                                      ),
                                      SizedBox(width: 3),
                                      Expanded(
                                        child: _buildtextfield(
                                          label: 'Total',
                                          controller: controller
                                              .assignmentsTotal[index]
                                              .controller,
                                        ),
                                      ),
                                      controller.assignments.length == 1
                                          ? SizedBox()
                                          : SizedBox(width: 3),
                                      controller.assignments.length == 1
                                          ? SizedBox()
                                          : IconButton(
                                              onPressed: () {
                                                controller.removeAssignment(
                                                  index,
                                                );
                                              },
                                              icon: Icon(Icons.delete),
                                            ),
                                      SizedBox(width: 3),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            controller.addAssignment();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF06B6D4),
                          ),
                          child: Text("Add Assignment"),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                  Card(
                    elevation: 4,
                    child: ExpansionTile(
                      shape: Border(),
                      collapsedShape: Border(),
                      title: Text('Midterm'),
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildtextfield(
                                label: 'Obtained',
                                controller: midController,
                              ),
                            ),
                            SizedBox(width: 3),
                            Expanded(
                              child: _buildtextfield(
                                label: 'Total',
                                controller: midTotalController,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Card(
                    elevation: 4,
                    child: ExpansionTile(
                      shape: Border(),
                      collapsedShape: Border(),
                      title: Text('Final'),
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildtextfield(
                                label: 'Obtained',
                                controller: finalController,
                              ),
                            ),
                            SizedBox(width: 3),
                            Expanded(
                              child: _buildtextfield(
                                label: 'Total',
                                controller: finalTotalController,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: controller.isChecked.value,
                        activeColor: Color(0xFF06B6D4),
                        onChanged: (newBool) {
                          controller.isChecked.value = newBool!;
                        },
                      ),
                      Text('Has Lab'),
                    ],
                  ),
                  controller.isChecked.value
                      ? Obx(
                          () => Column(
                            children: [
                              Card(
                                elevation: 4,
                                margin: EdgeInsets.all(12),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    "Lab",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Card(
                                elevation: 4,
                                child: ExpansionTile(
                                  shape: Border(),
                                  collapsedShape: Border(),
                                  title: Text('Assignment'),
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: controller
                                                .labAssignments
                                                .length,
                                            itemBuilder: (_, index) {
                                              return Row(
                                                children: [
                                                  Expanded(
                                                    child: _buildtextfield(
                                                      label: 'Obtained',
                                                      controller: controller
                                                          .labAssignments[index]
                                                          .controller,
                                                    ),
                                                  ),
                                                  SizedBox(width: 3),
                                                  Expanded(
                                                    child: _buildtextfield(
                                                      label: 'Total',
                                                      controller: controller
                                                          .labAssignmentsTotal[index]
                                                          .controller,
                                                    ),
                                                  ),
                                                  controller
                                                              .labAssignments
                                                              .length ==
                                                          1
                                                      ? SizedBox()
                                                      : SizedBox(width: 3),
                                                  controller
                                                              .labAssignments
                                                              .length ==
                                                          1
                                                      ? SizedBox()
                                                      : IconButton(
                                                          onPressed: () {
                                                            controller
                                                                .removeLabAssignment(
                                                                  index,
                                                                );
                                                          },
                                                          icon: Icon(
                                                            Icons.delete,
                                                          ),
                                                        ),
                                                  SizedBox(width: 3),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        controller.addLabAssignment();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF06B6D4),
                                      ),
                                      child: Text("Add Assignment"),
                                    ),
                                    SizedBox(height: 15),
                                  ],
                                ),
                              ),
                              Card(
                                elevation: 4,
                                child: ExpansionTile(
                                  shape: Border(),
                                  collapsedShape: Border(),
                                  title: Text('Midterm'),
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildtextfield(
                                            label: 'Obtained',
                                            controller: labMidController,
                                          ),
                                        ),
                                        SizedBox(width: 3),
                                        Expanded(
                                          child: _buildtextfield(
                                            label: 'Total',
                                            controller: labMidTotalController,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Card(
                                elevation: 4,
                                child: ExpansionTile(
                                  shape: Border(),
                                  collapsedShape: Border(),
                                  title: Text('Final'),
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildtextfield(
                                            label: 'Final',
                                            controller: labFinalController,
                                          ),
                                        ),
                                        SizedBox(width: 3),
                                        Expanded(
                                          child: _buildtextfield(
                                            label: 'Total',
                                            controller: labFinalTotalController,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Obx(
                        () => CircularWidget(
                          number: controller.GPA.value,
                          text: 'GPA',
                          total: 4.00,
                        ),
                      ),
                      Obx(
                        () => CircularWidget(
                          number: controller.totalMarks.value,
                          text: 'Marks',
                          total: 100.00,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      if (validatefields()) {
                        print(
                          "controller.totalMarks.value: ${controller.totalMarks.value}",
                        );
                        print("controller.GPA.value: ${controller.GPA.value}");
                        calculateGrade(
                          controller.quizzes,
                          controller.quizzesTotal,
                          controller.assignments,
                          controller.assignmentsTotal,
                          controller.labAssignments,
                          controller.labAssignmentsTotal,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF06B6D4),
                    ),
                    child: Text('Calculate'),
                  ),
                  SizedBox(height: 15),
                ],
              ),
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

class CircularWidget extends StatelessWidget {
  const CircularWidget({
    super.key,
    required this.number,
    required this.text,
    required this.total,
  });

  final double number;
  final String text;
  final dynamic total;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: number / total),
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
            Column(
              children: [
                Text(
                  number.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF06B6D4),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  text,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
