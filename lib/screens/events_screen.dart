import 'package:demo_chatbot/widgets/starry_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/events_controller.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final EventsController eventsController = Get.put(EventsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: SafeArea(child: StarryBackground(child: events_body())),
    );
  }

  Obx events_body() {
    return Obx(() {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: eventsController.events.length,
        itemBuilder: (context, index) {
          final event = eventsController.events[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF7C3AED),
                              const Color(0xFF06B6D4),
                            ],
                          ),
                        ),
                        child: Icon(event.icon, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              event.date,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFFCBD5E1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    event.description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFFCBD5E1),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
