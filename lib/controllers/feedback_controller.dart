import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackController extends GetxController {
  RxInt rating = 0.obs;
  var isLoadingButton = false.obs;
  void countRatings(index) {
    rating.value = index + 1;
  }
}
