import 'package:demo_chatbot/api_conn/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'splash_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/chat_controller.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController chatController = Get.put(ChatController());
  final QueryFeedbackController queryFeedbackController = Get.put(
    QueryFeedbackController(),
  );
  final TextEditingController messageController = TextEditingController();
  final TextEditingController queryFeedbackMessageController =
      TextEditingController();
  var query = '';
  late ScrollController _scrollController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && SplashScreenState.keyboardOPEN) {
        _focusNode.requestFocus();
        SplashScreenState.keyboardOPEN = false;
      }
    });

    chatController.messages.listen((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    messageController.dispose();
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

  // Save chat
  Future<int?> saveChat(String query, String response) async {
    final res = await APIClient.dio.post(
      '/student/saved-chats',
      data: {"query": query, "response": response},
    );
    if (res.statusCode == 200) {
      return res.data['saved_id'];
    }
    return null;
  }

  Future<void> unsaveChat(int savedId) async {
    await APIClient.dio.delete('/student/saved-chats/$savedId');
  }

  Future<void> sendQueryFeedback(
    String query,
    String llmresponse,
    String reason,
    String feedbackMessage,
  ) async {
    try {
      final response = await APIClient.dio.post(
        '/student/query-feedback',
        data: {
          'query': query,
          'llmresponse': llmresponse,
          'reason': reason,
          'detail': feedbackMessage,
        },
      );
      if (response.data['message'] == 'success') {
        Get.snackbar(
          'Success',
          'Thanks for your feedback',
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.greenAccent.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Please try again later',
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      final error = e.response?.data['detail'];
      Get.snackbar(
        'Error',
        error,
        duration: Duration(seconds: 2),
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
      body: SafeArea(child: _buildChatBody(context)),
    );
  }

  Column _buildChatBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: chatController.messages.length,
              itemBuilder: (context, index) {
                final message = chatController.messages[index];
                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: message.isUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (!message.isLoading)
                        Container(
                          margin: message.isUser
                              ? const EdgeInsets.only(
                                  left: 20,
                                  top: 8,
                                  bottom: 8,
                                )
                              : const EdgeInsets.only(right: 20, top: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: message.isUser
                                ? const Color(0xFF06B6D4)
                                : const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(12),
                            border: message.isUser
                                ? null
                                : Border.all(color: const Color(0xFF334155)),
                          ),
                          child: Linkify(
                            text: message.text,
                            style: TextStyle(
                              color: Colors
                                  .white, // match your existing text color
                              fontSize: 14,
                              fontFamily: 'p-m-font',
                            ),
                            linkStyle: TextStyle(
                              color: Color(
                                0xFF06B6D4,
                              ), // cyan — matches your app theme
                              fontSize: 14,
                              fontFamily: 'p-m-font',
                              decoration: TextDecoration.underline,
                              decorationColor: Color(
                                0xFF06B6D4,
                              ), // ← same cyan or any color you want
                              decorationThickness: 1.5,
                            ),
                            onOpen: (link) async {
                              final uri = Uri.parse(link.url);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                          ),
                        ),

                      // Show Lottie OUTSIDE container when loading
                      if (message.isLoading && !message.isUser && index != 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Lottie.asset(
                              'assets/animation/loader3.json',
                              width: 120,
                              height: 90,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const SizedBox(
                                  width: 100,
                                  height: 70,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFF06B6D4),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      !message.isUser && index != 0 && !message.isLoading
                          ? Row(
                              children: [
                                Obx(
                                  () => IconButton(
                                    onPressed: () {
                                      message.isDisliked.value = true;
                                      message.isLiked.value = false;
                                    },
                                    icon: Icon(
                                      Icons.thumb_up,
                                      size: 18,
                                      color: message.isDisliked.value
                                          ? Color(0xFFFFD700)
                                          : Color(0xFF334155),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Obx(
                                  () => IconButton(
                                    onPressed: () {
                                      message.isLiked.value = true;
                                      message.isDisliked.value = false;
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true, // important
                                        builder: (context) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              top: 8,
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom, // moves with keyboard
                                            ),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize
                                                    .min, // important
                                                children: [
                                                  SizedBox(height: 20),

                                                  DropdownMenu<String>(
                                                    width: double.infinity,
                                                    hintText: "Select reason",
                                                    initialSelection:
                                                        queryFeedbackController
                                                            .selectedReason
                                                            .value
                                                            .isEmpty
                                                        ? null
                                                        : queryFeedbackController
                                                              .selectedReason
                                                              .value,
                                                    dropdownMenuEntries:
                                                        queryFeedbackController
                                                            .reasons
                                                            .map(
                                                              (item) =>
                                                                  DropdownMenuEntry(
                                                                    value: item,
                                                                    label: item,
                                                                  ),
                                                            )
                                                            .toList(),
                                                    onSelected: (value) {
                                                      queryFeedbackController
                                                          .selectedReason
                                                          .value = value
                                                          .toString();
                                                    },
                                                  ),

                                                  SizedBox(height: 20),

                                                  TextField(
                                                    controller:
                                                        queryFeedbackMessageController,
                                                    cursorColor: Color(
                                                      0xFF06B6D4,
                                                    ),
                                                    maxLines: 5,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Share details (optional)',
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                    ),
                                                  ),

                                                  SizedBox(height: 5),

                                                  Text(
                                                    'Your conservation will be included with your feedback to help improve our services.',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                    ),
                                                  ),

                                                  SizedBox(height: 20),

                                                  Obx(
                                                    () => ElevatedButton(
                                                      onPressed:
                                                          queryFeedbackController
                                                                  .selectedReason
                                                                  .value !=
                                                              ''
                                                          ? () {
                                                              sendQueryFeedback(
                                                                query,
                                                                chatController
                                                                    .llmresponse,
                                                                queryFeedbackController
                                                                    .selectedReason
                                                                    .value,
                                                                queryFeedbackMessageController
                                                                    .text,
                                                              );
                                                              queryFeedbackMessageController
                                                                  .clear();
                                                              queryFeedbackController
                                                                      .selectedReason
                                                                      .value =
                                                                  '';
                                                              Get.back();
                                                            }
                                                          : null,
                                                      style:
                                                          ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Color(
                                                                  0xFF06B6D4,
                                                                ),
                                                          ),
                                                      child: Text('Submit'),
                                                    ),
                                                  ),

                                                  SizedBox(height: 20),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ).whenComplete(() {
                                        queryFeedbackController
                                                .selectedReason
                                                .value =
                                            '';
                                      });
                                    },
                                    icon: Icon(
                                      Icons.thumb_down,
                                      size: 18,
                                      color: message.isLiked.value
                                          ? Color(0xFFFFD700)
                                          : Color(0xFF334155),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Obx(
                                  () => IconButton(
                                    onPressed: () async {
                                      if (message.isSaved.value) {
                                        await unsaveChat(message.savedId!);
                                        message.isSaved.value = false;
                                        message.savedId = null;
                                      } else {
                                        // Save
                                        final savedId = await saveChat(
                                          message.query,
                                          message.response,
                                        );
                                        if (savedId != null) {
                                          message.isSaved.value = true;
                                          message.savedId = savedId;
                                        }
                                      }

                                      Fluttertoast.showToast(
                                        msg: message.isSaved.value
                                            ? "Chat saved successfully"
                                            : "Chat unsaved successfully",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.TOP_LEFT,
                                        backgroundColor: Color(0xFF06B6D4),
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                        webBgColor: "#06B6D4",
                                      );
                                    },
                                    icon: Icon(
                                      Icons.bookmark_sharp,
                                      size: 18,
                                      color: message.isSaved.value
                                          ? Colors.white
                                          : Color(0xFF334155),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(),
                    ],
                  ),
                );
              },
            );
          }),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              16 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    focusNode: _focusNode,
                    cursorColor: const Color(0xFF06B6D4),
                    style: const TextStyle(color: Colors.white),
                    textInputAction: TextInputAction.send,
                    decoration: const InputDecoration(
                      hintText: 'Ask me anything...',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (text) {
                      if (text.trim().isNotEmpty) {
                        chatController.sendMessage(text.trim());
                        messageController.clear();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: const Color(0xFF06B6D4),
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      chatController.sendMessage(messageController.text);
                      query = messageController.text;
                      print(
                        '-------------------------DEBUG: ${query}----------------------------------',
                      );
                      messageController.clear();
                      _scrollToBottom();
                    }
                  },
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
