import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CGPAcalculatorController extends GetxController {
  RxDouble result = 0.0.obs;
  RxDouble requiredGPA = 0.0.obs;

  void calcgpa(double add1, double add2) {
    result.value = (add1 / add2);
  }

  void calcRequiredGPA(
    double targetQualityPoints,
    double previousQualityPoints,
    double currCredits,
  ) {
    var ans = (targetQualityPoints - previousQualityPoints) / currCredits;
    if (ans > 4.0 || ans < 0.0) {
      Get.snackbar(
        'Not possible',
        'Target CGPA not achievable in one semester.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    requiredGPA.value = ans;
  }
}

class Course {
  TextEditingController gpaController = TextEditingController();
  TextEditingController creditController = TextEditingController();
}

class SemesterGPAcalculatorController extends GetxController {
  RxDouble result = 0.0.obs;
  var courses = <Course>[].obs;

  @override
  void onInit() {
    super.onInit();
    courses.add(Course());
  }

  void addCourse() {
    courses.add(Course());
  }

  void removeCourse(int index) {
    courses.removeAt(index);
  }

  void calculateGPA(double totalQualityPoints, double totalCredits) {
    result.value = totalQualityPoints / totalCredits;
  }
}

class Quiz {
  final TextEditingController controller = TextEditingController();
}

class QuizTotal {
  final TextEditingController controller = TextEditingController();
}

class Assign {
  final TextEditingController controller = TextEditingController();
}

class AssignTotal {
  final TextEditingController controller = TextEditingController();
}

class LabAssign {
  final TextEditingController controller = TextEditingController();
}

class LabAssignTotal {
  final TextEditingController controller = TextEditingController();
}

class CourseGradeCalculatorController extends GetxController {
  var quizzes = <Quiz>[Quiz(), Quiz(), Quiz()].obs;
  var quizzesTotal = <QuizTotal>[QuizTotal(), QuizTotal(), QuizTotal()].obs;

  var assignments = <Assign>[Assign(), Assign(), Assign()].obs;
  var assignmentsTotal = <AssignTotal>[
    AssignTotal(),
    AssignTotal(),
    AssignTotal(),
  ].obs;

  var labAssignments = <LabAssign>[LabAssign(), LabAssign(), LabAssign()].obs;
  var labAssignmentsTotal = <LabAssignTotal>[
    LabAssignTotal(),
    LabAssignTotal(),
    LabAssignTotal(),
  ].obs;
  var isChecked = false.obs;
  RxDouble quizResult = 0.0.obs;
  RxDouble assignmentResult = 0.0.obs;
  RxDouble labAssignmentResult = 0.0.obs;
  RxDouble totalMarks = 0.0.obs;
  RxDouble GPA = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    quizzes.add(Quiz());
    quizzesTotal.add(QuizTotal());
    assignments.add(Assign());
    assignmentsTotal.add(AssignTotal());
    labAssignments.add(LabAssign());
    labAssignmentsTotal.add(LabAssignTotal());
  }

  void addQuiz() {
    quizzes.add(Quiz());
    quizzesTotal.add(QuizTotal());
  }

  void addAssignment() {
    assignments.add(Assign());
    assignmentsTotal.add(AssignTotal());
  }

  void addLabAssignment() {
    labAssignments.add(LabAssign());
    labAssignmentsTotal.add(LabAssignTotal());
  }

  void removeQuiz(int index) {
    quizzes.removeAt(index);
    quizzesTotal.removeAt(index);
  }

  void removeAssignment(int index) {
    assignments.removeAt(index);
    assignmentsTotal.removeAt(index);
  }

  void removeLabAssignment(int index) {
    labAssignments.removeAt(index);
    labAssignmentsTotal.removeAt(index);
  }

  void calculateQuizMarks(double obtainedTotal, double totalsTotal) {
    var result = obtainedTotal / totalsTotal;
    var resultPercent = result * 100.0;
    quizResult.value = resultPercent * 0.15;
  }

  void calculateAssignmentMarks(double obtainedTotal, double totalsTotal) {
    var result = obtainedTotal / totalsTotal;
    var resultPercent = result * 100;
    assignmentResult.value = resultPercent * 0.10;
  }

  void calculateLabAssignmentMarks(double obtainedTotal, double totalsTotal) {
    var result = obtainedTotal / totalsTotal;
    var resultPercent = result * 100;
    labAssignmentResult.value = resultPercent * 0.25;
  }

  void calculateTotalMarksWithLab(theoryMarks, labMarks) {
    theoryMarks = theoryMarks * 0.75;
    labMarks = labMarks * 0.25;
    totalMarks.value = theoryMarks + labMarks;
    calculateGPA(totalMarks.value);
  }

  void calculateTotalMarks(theoryMarks) {
    totalMarks.value = theoryMarks;
    calculateGPA(totalMarks.value);
  }

  void calculateGPA(totalMarks) {
    if (totalMarks >= 85) {
      GPA.value = 4.00;
    } else if (totalMarks >= 80) {
      GPA.value = 3.66;
    } else if (totalMarks >= 75) {
      GPA.value = 3.33;
    } else if (totalMarks >= 73) {
      GPA.value = 3.00;
    } else if (totalMarks >= 70) {
      GPA.value = 2.66;
    } else if (totalMarks >= 65) {
      GPA.value = 2.33;
    } else if (totalMarks >= 60) {
      GPA.value = 2.00;
    } else if (totalMarks >= 55) {
      GPA.value = 1.66;
    } else if (totalMarks >= 50) {
      GPA.value = 1.33;
    } else {
      GPA.value = 0.00;
    }
  }
}
