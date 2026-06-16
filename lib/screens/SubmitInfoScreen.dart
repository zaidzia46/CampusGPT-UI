import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_chatbot/api_conn/dio.dart';

import '../conn_check/conn_check.dart';
import '../controllers/submissions_controller.dart';

class SubmitInfoScreen extends StatefulWidget {
  const SubmitInfoScreen({Key? key}) : super(key: key);
  @override
  State<SubmitInfoScreen> createState() => _SubmitInfoScreenState();
}

class _SubmitInfoScreenState extends State<SubmitInfoScreen> {
  final _topic = TextEditingController();
  final _detail = TextEditingController();
  final _tags = TextEditingController();
  final _fileUrl = TextEditingController();
  bool _loading = false;

  final SubmissionsController submissionsController = Get.put(
    SubmissionsController(),
  );

  @override
  void initState() {
    super.initState();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    bool hasInternet = await checkInternetConnection();
    if (!hasInternet) return;
    try {
      await APIClient.dio.post(
        '/student/faculty/submit',
        data: {
          'topic': _topic.text.trim(),
          'detail': _detail.text.trim(),
          'tags': _tags.text.trim(),
          'file_url': _fileUrl.text.trim(),
        },
      );

      Get.snackbar(
        'Submitted!',
        'Your information has been sent to admin for review.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      _topic.clear();
      _detail.clear();
      _tags.clear();
      _fileUrl.clear();
      submissionsController.loadMySubmissions();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Submission failed. Please try again.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // topic
              _label('Topic'),
              _input(_topic, 'e.g. Lab Schedule, Course Outline, Office Hours'),
              const SizedBox(height: 16),

              // detail
              _label('Detail'),
              _input(_detail, 'Provide full information here...', maxLines: 5),
              const SizedBox(height: 16),

              // tags
              _label('Tags  (comma separated)'),
              _input(_tags, 'e.g. BSCS, lab, schedule, semester 6'),
              const SizedBox(height: 16),

              _label('Google Drive Link  (optional)'),
              _input(_fileUrl, 'Paste Google Drive link here'),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF06B6D4),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Submit to Admin',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 32),

              // My Submissions header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Submissions',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'p-m-font',
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      checkInternetConnection();
                      submissionsController.loadMySubmissions();
                    },
                    child: const Icon(
                      Icons.refresh,
                      color: Color(0xFF06B6D4),
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Submissions list
              Obx(
                () => submissionsController.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF06B6D4),
                          strokeWidth: 2,
                        ),
                      )
                    : submissionsController.mySubmissions.isEmpty
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: Text(
                          'No submissions yet.',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'p-m-font',
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Column(
                        children: submissionsController.mySubmissions
                            .map<Widget>((s) {
                              final status = s['status'] as String;
                              final Color statusColor = status == 'Approved'
                                  ? Colors.green
                                  : status == 'Rejected'
                                  ? Colors.redAccent
                                  : const Color(0xFFF59E0B);
                              final IconData statusIcon = status == 'Approved'
                                  ? Icons.check_circle_outline
                                  : status == 'Rejected'
                                  ? Icons.cancel_outlined
                                  : Icons.hourglass_empty;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E293B),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: statusColor.withOpacity(0.3),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // topic + status badge
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            s['topic'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'p-m-font',
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: statusColor.withOpacity(
                                              0.15,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                statusIcon,
                                                color: statusColor,
                                                size: 12,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                status,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontFamily: 'p-m-font',
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 6),

                                    // submitted date
                                    Text(
                                      DateTime.parse(
                                        s['submitted_at'],
                                      ).toLocal().toString().substring(0, 16),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontFamily: 'p-m-font',
                                        color: Colors.white,
                                      ),
                                    ),

                                    // admin notes — only if present
                                    if ((s['admin_notes'] as String)
                                        .isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0F172A),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.info_outline,
                                              color: Color(0xFF06B6D4),
                                              size: 13,
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                s['admin_notes'],
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'p-m-font',
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            })
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontFamily: 'p-m-font',
      ),
    ),
  );

  Widget _input(TextEditingController ctrl, String hint, {int maxLines = 1}) =>
      TextField(
        controller: ctrl,
        maxLines: maxLines,
        cursorColor: const Color(0xFF06B6D4),
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
          filled: true,
          fillColor: const Color(0xFF1E293B),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF334155)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF334155)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF06B6D4)),
          ),
          contentPadding: const EdgeInsets.all(14),
        ),
      );

  BoxDecoration _boxDec({bool dashed = false}) => BoxDecoration(
    color: const Color(0xFF1E293B),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: const Color(0xFF334155)),
  );
}
