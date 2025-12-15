import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/reminderProvider/reminder_provider.dart';
import 'package:finance_manager_app/services/permission_handler_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddReminderForm extends StatefulWidget {
  final int? reminderID;
  const AddReminderForm({super.key, this.reminderID});

  @override
  State<AddReminderForm> createState() => _AddReminderFormState();
}

class _AddReminderFormState extends State<AddReminderForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();

  DateTime _reminderTime = DateTime.now();
  bool _isRepeating = false;

  @override
  void initState() {
    super.initState();
    if (widget.reminderID != null) {
      fetchReminder();
    }
  }

  void fetchReminder() {
    try {
      final data = context.read<ReminderProvider>().getReminderById(
        widget.reminderID!,
      );
      if (data != null) {
        title.text = data["title"];
        desc.text = data['body'];
        _reminderTime = DateTime.parse(data['remindersTime']);
        title.text = data["title"];
        desc.text = data['body'];
        _reminderTime = DateTime.parse(data['remindersTime']);
        _isRepeating = data['isRepeating'] == 1;
        setState(() {});
      }
    } catch (e) {
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: widget.reminderID != null
            ? "edit_reminder".tr
            : "add_reminder".tr,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Input
                _buildSectionLabel('title'.tr, Icons.title),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).dividerColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: title,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'reminder_title'.tr,
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                ),

                SizedBox(height: 24),

                // Description Input
                _buildSectionLabel('description'.tr, Icons.notes),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).dividerColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: desc,
                    maxLines: 4,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'optional_details'.tr,
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      contentPadding: EdgeInsets.all(20),
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Date & Time Section
                _buildSectionLabel('schedule'.tr, Icons.schedule),
                SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: _buildDateTimePicker(
                        'date'.tr,
                        Icons.calendar_today_outlined,
                        _localizedDate(_reminderTime),
                        () => _selectDate(),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildDateTimePicker(
                        'time'.tr,
                        Icons.access_time_outlined,
                        _localizedTime(_reminderTime),
                        () => _selectTime(),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                // Repeat Toggle
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).dividerColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SwitchListTile(
                    value: _isRepeating,
                    onChanged: (val) {
                      setState(() {
                        _isRepeating = val;
                      });
                    },
                    title: Text(
                      'Repeat Daily',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    secondary: Icon(
                      Icons.repeat,
                      color: Theme.of(context).primaryColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saveReminder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      shadowColor: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          widget.reminderID != null
                              ? Icons.check_circle_outline
                              : Icons.add_circle_outline,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          widget.reminderID != null
                              ? 'update_reminder'.tr
                              : 'save_reminder'.tr,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20),
        SizedBox(width: 8),
        Text(label, style: Theme.of(context).textTheme.labelLarge),
      ],
    );
  }

  Widget _buildDateTimePicker(
    String label,
    IconData icon,
    String displayValue,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 18, color: Colors.grey[600]),
                    SizedBox(width: 6),
                    Text(label, style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  displayValue,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: _reminderTime.isAfter(DateTime.now())
          ? _reminderTime
          : DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _reminderTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _reminderTime.hour,
          _reminderTime.minute,
        );
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: _reminderTime.hour,
        minute: _reminderTime.minute,
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _reminderTime = DateTime(
          _reminderTime.year,
          _reminderTime.month,
          _reminderTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _saveReminder() async {
    final provider = context.read<ReminderProvider>();
    await requestNotiPermission();
    if (!mounted) return;
    if (_formKey.currentState!.validate()) {
      try {
        if (widget.reminderID == null) {
          //  final reminderId = await ReminderDbHelper.addReminder(newReminder);

          provider.addReminder(
            title: title.text,
            body: desc.text,

            reminderTime: _reminderTime,
            isRepeating: _isRepeating,
          );
        } else {
          provider.updateReminder(
            widget.reminderID!,
            title: title.text,
            body: desc.text,
            reminderTime: _reminderTime,
            isActive: true,
            isRepeating: _isRepeating,
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.reminderID != null
                  ? 'update_success'.tr
                  : 'create_success'.tr,
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );

        Get.back(result: true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('save_failed'.tr),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Localized display helpers for date and time (supports Bangla)
  String _localizedDate(DateTime dt) {
    try {
      final isBangla = Get.locale?.languageCode == 'bn';

      // Step 1: Format in English pattern
      String formatted = DateFormat('MMM dd, yyyy').format(dt);

      if (!isBangla) return DateFormat('MMM dd, yyyy').format(dt);

      // Step 2: English → Bangla month names
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
    } catch (e) {
      return DateFormat('MMM dd, yyyy').format(dt);
    }
  }

  String _localizedTime(DateTime dt) {
    try {
      final isBangla = Get.locale?.languageCode == 'bn';

      // Format in a stable (English) pattern then convert if needed.
      final formattedEn = DateFormat('h:mm a').format(dt); // e.g. "7:21 PM"

      if (!isBangla) return formattedEn;

      // Convert AM/PM to Bangla
      String formatted = formattedEn;

      // Convert digits to Bangla digits
      const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
      const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

      for (int i = 0; i < en.length; i++) {
        formatted = formatted.replaceAll(en[i], bn[i]);
      }

      return formatted;
    } catch (e) {
      // fallback: return english formatted string to avoid crashes
      return DateFormat('h:mm a').format(dt);
    }
  }
}
