import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Event {
  final String title;
  final String date;
  final String description;
  final IconData icon;

  Event({
    required this.title,
    required this.date,
    required this.description,
    required this.icon,
  });
}

class EventsController extends GetxController {
  var events = <Event>[].obs;

  @override
  void onInit() {
    super.onInit();
    events.addAll([
      Event(
        title: 'Tech Workshop',
        date: 'Oct 20, 2024',
        description: 'Learn about the latest technologies in AI and ML',
        icon: Icons.computer,
      ),
      Event(
        title: 'Campus Fest',
        date: 'Oct 25, 2024',
        description: 'Annual celebration with music, food, and fun activities',
        icon: Icons.celebration,
      ),
      Event(
        title: 'Seminar',
        date: 'Oct 28, 2024',
        description: 'Industry experts sharing insights on career growth',
        icon: Icons.school,
      ),
    ]);
  }
}
