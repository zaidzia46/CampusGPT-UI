import 'package:demo_chatbot/api_conn/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatefulWidget {
  final VoidCallback? onAllRead;
  const NotificationsScreen({Key? key, this.onAllRead}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic> _notifications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await APIClient.getNotifications();
      setState(() => _notifications = data);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load notifications',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _markAllRead() async {
    await APIClient.markAllRead();
    widget.onAllRead?.call();
    await _load();
  }

  // type → color mapping matching your TypeBadge in React
  Color _typeColor(String type) {
    return const Color(0xFF3B82F6);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // Mark all read button
            if (_notifications.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _markAllRead,
                    child: Text(
                      'Mark all as read',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF06B6D4),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),

            // List
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF06B6D4),
                      ),
                    )
                  : _notifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.notifications_off_outlined,
                            color: Colors.white30,
                            size: 56,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No notifications yet',
                            style: GoogleFonts.inter(
                              color: Colors.white38,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      color: const Color(0xFF06B6D4),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _notifications.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final n = _notifications[i];
                          final ann = n['announcement'];
                          final isRead = n['is_read'] as bool;
                          final type = ann['type'] as String? ?? 'General';

                          return GestureDetector(
                            onTap: () async {
                              if (!isRead) {
                                await APIClient.markAsRead(n['id']);
                                setState(() {
                                  _notifications[i]['is_read'] = true;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isRead
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFF1E3A5F),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isRead
                                      ? const Color(0xFF334155)
                                      : const Color(
                                          0xFF06B6D4,
                                        ).withOpacity(0.4),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // type dot
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 4,
                                      right: 12,
                                    ),
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: _typeColor(type),
                                      shape: BoxShape.circle,
                                    ),
                                  ),

                                  // content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                ann['title'] ?? '',
                                                style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontWeight: isRead
                                                      ? FontWeight.w400
                                                      : FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            // type badge
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: _typeColor(
                                                  type,
                                                ).withOpacity(0.15),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                type,
                                                style: GoogleFonts.inter(
                                                  color: _typeColor(type),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          ann['description'] ?? '',
                                          style: GoogleFonts.inter(
                                            color: Colors.white60,
                                            fontSize: 13,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (!isRead) ...[
                                          const SizedBox(height: 8),
                                          Text(
                                            'Tap to mark as read',
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF06B6D4),
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
