import 'package:finance_manager_app/config/db/local/reminder_db/reminder_db_helper.dart';
import 'package:finance_manager_app/services/reminder_helper.dart';
import 'package:flutter/material.dart';

class ReminderProvider with ChangeNotifier {
  List<Map<String, dynamic>> _reminders = [];
  bool _isInitialized = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Map<String, dynamic>> get reminders => _reminders;
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Initialize reminder database and notifications (only once)
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await ReminderDbHelper.initDB();
      await ReminderHelper.initializeReminderNoti();
      _isInitialized = true;
      await loadReminders();
    } catch (e) {
      _errorMessage = 'Error initializing reminders: $e';
      _isLoading = false;
      // print(_errorMessage);
      notifyListeners();
    }
  }

  /// Load all reminders from database
  Future<void> loadReminders() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final reminders = await ReminderDbHelper.getReminders();
      // Convert to mutable list to avoid "read-only" errors
      _reminders = List<Map<String, dynamic>>.from(reminders);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error loading reminders: $e';
      _isLoading = false;
      //  print(_errorMessage);
      notifyListeners();
    }
  }

  /// Toggle reminder active status and schedule/cancel notification
  Future<void> toggleReminder(int id, bool isActive) async {
    try {
      _errorMessage = null;

      // Update in database
      await ReminderDbHelper.toggleReminder(id, isActive);

      // Find reminder safely
      final reminder = _reminders.firstWhere(
        (elm) => elm['id'] == id,
        orElse: () => {}, // return empty map if not found
      );

      if (reminder.isNotEmpty) {
        // Schedule or cancel notification
        if (isActive) {
          final scheduledTime = _parseReminderTime(reminder['remindersTime']);
          final isRepeating = reminder['isRepeating'] == 1;
          ReminderHelper.scheduleNoti(
            id,
            "Reminder",
            reminder["title"],
            scheduledTime,
            isRepeating: isRepeating,
          );
        } else {
          ReminderHelper.chanceledRemidnerNoti(id);
        }

        // Update local state
        final index = _reminders.indexWhere((elm) => elm['id'] == id);
        if (index != -1) {
          final updatedReminder = Map<String, dynamic>.from(_reminders[index]);
          updatedReminder['isActive'] = isActive ? 1 : 0;

          _reminders = [
            ..._reminders.sublist(0, index),
            updatedReminder,
            ..._reminders.sublist(index + 1),
          ];
          notifyListeners();
        }
      } else {
        _errorMessage = 'Reminder with ID $id not found';
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Error toggling reminder: $e';
      notifyListeners();
    }
  }

  /// Delete a reminder
  Future<void> deleteReminder(int id) async {
    try {
      _errorMessage = null;

      await ReminderDbHelper.deleteReminder(id);
      ReminderHelper.chanceledRemidnerNoti(id);

      // Remove from local list by creating a new list
      _reminders = _reminders
          .where((reminder) => reminder['id'] != id)
          .toList();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error deleting reminder: $e';
      // print(_errorMessage);
      notifyListeners();
    }
  }

  /// Add a new reminder
  Future<int?> addReminder({
    required String title,
    required String body,
    required DateTime reminderTime,
    bool isRepeating = false,
  }) async {
    try {
      _errorMessage = null;

      final newReminder = {
        'title': title,
        'body': body,
        'isActive': 1,
        'remindersTime': reminderTime.toIso8601String(),
        'isRepeating': isRepeating ? 1 : 0,
      };

      final reminderId = await ReminderDbHelper.addReminder(newReminder);

      ReminderHelper.scheduleNoti(
        reminderId,
        "Reminder",
        title,
        reminderTime,
        isRepeating: isRepeating,
      );

      // Reload reminders to get the new one with ID
      await loadReminders();
      return reminderId;
    } catch (e) {
      _errorMessage = 'Error adding reminder: $e';
      //  print(_errorMessage);
      notifyListeners();
      return null;
    }
  }

  /// Update existing reminder
  Future<bool> updateReminder(
    int id, {
    required String title,
    required String body,
    required DateTime reminderTime,
    required bool isActive,
    bool isRepeating = false,
  }) async {
    try {
      _errorMessage = null;

      final updatedReminder = {
        'title': title,
        'body': body,
        'isActive': isActive ? 1 : 0,
        'remindersTime': reminderTime.toIso8601String(),
        'isRepeating': isRepeating ? 1 : 0,
      };

      await ReminderDbHelper.updateReminder(id, updatedReminder);

      // Cancel old notification and schedule new one if active
      ReminderHelper.chanceledRemidnerNoti(id);
      if (isActive) {
        ReminderHelper.scheduleNoti(
          id,
          "Reminder",
          title,
          reminderTime,
          isRepeating: isRepeating,
        );
      }

      // Reload reminders
      await loadReminders();
      return true;
    } catch (e) {
      _errorMessage = 'Error updating reminder: $e';
      //  print(_errorMessage);
      notifyListeners();
      return false;
    }
  }

  /// Get reminder by ID
  Map<String, dynamic>? getReminderById(int id) {
    try {
      return _reminders.firstWhere((reminder) => reminder['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Parse reminder time from various formats
  DateTime _parseReminderTime(dynamic time) {
    if (time is DateTime) {
      return time;
    } else if (time is String) {
      return DateTime.parse(time);
    } else {
      return DateTime.parse(time.toString());
    }
  }

  /// Delete all reminders
  Future<void> deleteFullReminders() async {
    try {
      _errorMessage = null;
      await ReminderDbHelper.deleteFull();
      _reminders.clear();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error deleting all reminders: $e';
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
