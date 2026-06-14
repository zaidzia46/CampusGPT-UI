import 'package:get/get.dart';

class MainScreenController extends GetxController {
  final selectedIndex = 0.obs;

  void setIndex(int index) {
    selectedIndex.value = index;
  }
}