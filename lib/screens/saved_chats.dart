import 'package:demo_chatbot/api_conn/dio.dart';
import 'package:demo_chatbot/widgets/starry_background.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedChats extends StatefulWidget {
  const SavedChats({super.key});

  @override
  State<SavedChats> createState() => _SavedChatsState();
}

class _SavedChatsState extends State<SavedChats> {
  List<Map<String, dynamic>> savedChats = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSavedChats();
  }

  Future<void> fetchSavedChats() async {
    try {
      final response = await APIClient.dio.get('/student/saved-chats');
      setState(() {
        savedChats = List<Map<String, dynamic>>.from(response.data);
        isLoading = false;
      });
    } on DioException {
      setState(() => isLoading = false);
      Get.snackbar(
        'Error',
        'Failed to load saved chats',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteChat(int savedId, int index) async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete Chat', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to delete this saved chat?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await APIClient.dio.delete('/student/saved-chats/$savedId');
      setState(() => savedChats.removeAt(index));
      Get.snackbar(
        'Deleted',
        'Chat removed from saved',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } on DioException {
      Get.snackbar(
        'Error',
        'Failed to delete. Try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: StarryBackground(
          child: Column(
            children: [
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF06B6D4),
                        ),
                      )
                    : savedChats.isEmpty
                    ? const Center(
                        child: Text(
                          'No saved chats yet.',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                            fontFamily: 'p-m-font',
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: savedChats.length,
                        itemBuilder: (context, index) {
                          final chat = savedChats[index];
                          final savedId = chat['id'];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    left: 40,
                                    top: 8,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF06B6D4),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF334155),
                                    ),
                                  ),
                                  child: Text(
                                    chat['query'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'p-m-font',
                                    ),
                                  ),
                                ),
                              ),

                              // Response — right side
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    right: 40,
                                    top: 8,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E293B),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    chat['response'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'p-m-font',
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 5),
                              Align(
                                alignment: Alignment.center,
                                child: TextButton.icon(
                                  onPressed: () => deleteChat(savedId, index),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                    size: 16,
                                  ),
                                  label: const Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),

                              // Divider between chats
                              const Divider(color: Color(0xFF334155)),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
