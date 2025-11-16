import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/reminderProvider/reminder_provider.dart';
import 'package:finance_manager_app/views/reminderView/add_reminder_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReminderPreviewScreen extends StatefulWidget {
  final Map<String, dynamic> reminder;

  const ReminderPreviewScreen({super.key, required this.reminder});

  @override
  State<ReminderPreviewScreen> createState() => _ReminderPreviewScreenState();
}

class _ReminderPreviewScreenState extends State<ReminderPreviewScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _formatDate(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final tomorrow = today.add(const Duration(days: 1));
      final reminderDate = DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
      );

      final isBangla = Get.locale?.languageCode == 'bn';

      // Step 1: Format in English pattern
      String formatted = DateFormat('MMM dd, yyyy').format(dateTime);

      if (!isBangla) return DateFormat('MMM dd, yyyy').format(dateTime);

      if (reminderDate == today) {
        return 'আজ';
      } else if (reminderDate == yesterday) {
        return 'গতকাল';
      } else if (reminderDate == tomorrow) {
        return 'আগামীকাল';
      } else {
        const monthMap = {
          'Jan': 'জানুয়ারি',
          'Feb': 'ফেব্রুয়ারি',
          'Mar': 'মার্চ',
          'Apr': 'এপ্রিল',
          'May': 'মে',
          'Jun': 'জুন',
          'Jul': 'জুলাই',
          'Aug': 'আগস্ট',
          'Sep': 'সেপ্টেম্বর',
          'Oct': 'অক্টোবর',
          'Nov': 'নভেম্বর',
          'Dec': 'ডিসেম্বর',
        };

        monthMap.forEach((en, bn) {
          formatted = formatted.replaceAll(en, bn);
        });

        // Step 3: English → Bangla digits
        const enDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
        const bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

        for (int i = 0; i < enDigits.length; i++) {
          formatted = formatted.replaceAll(enDigits[i], bnDigits[i]);
        }

        return formatted;
      }
    } catch (e) {
      return DateFormat('MMM dd, yyyy').format(DateTime.parse(dateTimeStr));
    }
  }

  String _formatTime(String dateTimeStr) {
    try {
      final isBangla = Get.locale?.languageCode == 'bn';
      final dateTime = DateTime.parse(dateTimeStr);

      final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = dateTime.hour >= 12 ? 'PM' : 'AM';

      final formatted = '${hour == 0 ? 12 : hour}:$minute $period';

      if (isBangla) {
        // Convert English digits to Bangla digits
        const enDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
        const bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

        String banglaTime = formatted;
        for (int i = 0; i < 10; i++) {
          banglaTime = banglaTime.replaceAll(enDigits[i], bnDigits[i]);
        }

        return banglaTime;
      }

      return formatted;
    } catch (e) {
      return DateFormat('MMM dd, yyyy').format(DateTime.parse(dateTimeStr));
    }
  }

  Future<void> _showDeleteBottomSheet(BuildContext context) async {
    final reminderProvider = context.read<ReminderProvider>();

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_outline,
                color: Colors.red[400],
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'delete_reminder'.tr,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'confirmation_message'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'cancel'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'delete'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      await reminderProvider.deleteReminder(widget.reminder['id']);
      Get.back(result: true);

      Get.snackbar(
        '',
        'delete_success'.tr,
        titleText: const SizedBox.shrink(),
        messageText: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'delete_success'.tr,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green[600],
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final reminderProvider = context.watch<ReminderProvider>();

    final hasDescription =
        widget.reminder['body'] != null &&
        widget.reminder['body'].toString().trim().isNotEmpty;
    final isActive = widget.reminder['isActive'] == 1;

    return Scaffold(
      appBar: customAppBar(
        title: "reminder_details".tr,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.edit_outlined, size: 20),
            ),
            onPressed: () async {
              final result = await Get.to(
                () => AddReminderForm(reminderID: widget.reminder['id']),
              );
              if (result == true && mounted) {
                await reminderProvider.loadReminders();
                Get.back(result: true);
              }
            },
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.delete_outline, size: 20),
            ),
            onPressed: () => _showDeleteBottomSheet(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    // Title Card
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.reminder['title'],
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? Colors.green[50]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? Colors.green[600]
                                            : Colors.grey[500],
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      isActive ? 'active'.tr : 'inactive'.tr,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isActive
                                            ? Colors.green[700]
                                            : Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Date & Time Card
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'scheduled_time'.tr,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTimeInfoTile(
                                  context,
                                  icon: Icons.calendar_today,
                                  label: 'date'.tr,
                                  value:
                                      widget.reminder['remindersTime'] != null
                                      ? _formatDate(
                                          widget.reminder['remindersTime'],
                                        )
                                      : 'Not set',
                                  color: Colors.blue,
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 50,
                                color: Theme.of(context).primaryColor,
                              ),
                              Expanded(
                                child: _buildTimeInfoTile(
                                  context,
                                  icon: Icons.access_time,
                                  label: 'time'.tr,
                                  value:
                                      widget.reminder['remindersTime'] != null
                                      ? _formatTime(
                                          widget.reminder['remindersTime'],
                                        )
                                      : 'not_set'.tr,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Description Card
                    if (hasDescription)
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.purple[50],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.description_outlined,
                                    color: Colors.purple[700],
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'description'.tr,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              widget.reminder['body'],
                              style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.onPrimary,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Action Buttons
                    // Padding(
                    //   padding: const EdgeInsets.all(20),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         flex: 2,
                    //         child: ElevatedButton(
                    //           onPressed: () async {
                    //             final result = await Get.to(
                    //               () => AddReminderForm(
                    //                 reminderID: widget.reminder['id'],
                    //               ),
                    //             );
                    //             if (result == true && mounted) {
                    //               await reminderProvider.loadReminders();
                    //               Get.back(result: true);
                    //             }
                    //           },
                    //           style: ElevatedButton.styleFrom(
                    //             backgroundColor: categoryColor,
                    //             foregroundColor: Colors.white,
                    //             padding: const EdgeInsets.symmetric(
                    //               vertical: 18,
                    //             ),
                    //             elevation: 0,
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(16),
                    //             ),
                    //           ),
                    //           child: const Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Icon(Icons.edit, size: 20),
                    //               SizedBox(width: 8),
                    //               Text(
                    //                 'Edit Reminder',
                    //                 style: TextStyle(
                    //                   fontSize: 16,
                    //                   fontWeight: FontWeight.w600,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       const SizedBox(width: 12),
                    //       Container(
                    //         decoration: BoxDecoration(
                    //           color: Colors.red[50],
                    //           borderRadius: BorderRadius.circular(16),
                    //         ),
                    //         child: IconButton(
                    //           onPressed: () => _showDeleteBottomSheet(context),
                    //           icon: Icon(
                    //             Icons.delete_outline,
                    //             color: Colors.red[600],
                    //           ),
                    //           iconSize: 24,
                    //           padding: const EdgeInsets.all(16),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfoTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required MaterialColor color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Icon(icon, color: color[700], size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
