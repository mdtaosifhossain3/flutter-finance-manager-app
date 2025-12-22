import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_manager_app/views/mainView/main_view.dart';
import 'package:finance_manager_app/views/pricingView/pricing_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class ProProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Keys for storage
  static const String _keyTrialStartDate = 'trial_start_date';
  static const String _keyIsPro = 'is_pro_user';
  static const String _keySubscriptionEndDate = 'subscription_end_date';

  // State
  bool isPro = false;
  bool isTrialActive = false;
  int remainingTrialDays = 2;
  DateTime? subscriptionEndDate;

  // Constants
  static const int _trialDurationDays = 20;

  ProProvider() {
    // _initializeProStatus(); // Removed automatic init
  }

  Future<void> initializeProStatus() async {
    // 1. Check Local Storage (Offline First)
    String? proStatus = await _storage.read(key: _keyIsPro);
    String? subEndStr = await _storage.read(key: _keySubscriptionEndDate);

    if (proStatus == 'true') {
      if (subEndStr != null) {
        subscriptionEndDate = DateTime.parse(subEndStr);
        // Check if expired locally
        if (DateTime.now().isAfter(subscriptionEndDate!)) {
          await _downgradeToFree();
        } else {
          isPro = true;
        }
      } else {
        // Legacy/Lifetime fallback
        isPro = true;
      }
    }

    // 2. Sync with Firebase (if user is logged in)
    // If local says NOT pro, or we just want to verify/restore
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data();
          final bool remoteIsPro = data?['isPro'] ?? false;
          final String? remoteEndStr = data?['subscription_end'];

          if (remoteIsPro && remoteEndStr != null) {
            final remoteEndDate = DateTime.parse(remoteEndStr);

            if (DateTime.now().isAfter(remoteEndDate)) {
              // Remote says Pro, but it's expired. Update remote to false.
              await _firestore.collection('users').doc(user.uid).update({
                'isPro': false,
              });
              await _downgradeToFree();
            } else {
              // Remote is valid Pro. Update local.
              await _enableProLocally(remoteEndDate);
            }
          } else if (!remoteIsPro && isPro) {
            // Local says Pro, Remote says NOT Pro.
            // This is a conflict. Usually remote is source of truth for subscription status
            // unless we just purchased and haven't synced yet.
            // For now, let's trust remote if we are online and it explicitly says false.
            // OR, if we assume local might be ahead (just bought offline), we might keep local.
            // But the requirement says "if user uninstall... then firebase will called".
            // So Firebase is the backup.
            // Let's assume if remote is false, we should check if our local is valid.
            // If local is valid and remote is false, maybe we should push to remote?
            // For simplicity and safety against fraud: Trust Remote if it exists.
            // BUT, if we just bought offline, local is true.
            // Let's stick to the requirement: "when user come it will chk is pro or not... if user uninstall... data saved again in offline"

            // If we are here, it means local was true (maybe) but remote is false.
            // If local was false, and remote false, we are good.
            if (isPro) {
              // If local is Pro but remote is NOT, it might be an expired sub that wasn't updated locally?
              // Or a fresh install where we haven't restored yet?
              // Actually, if local is Pro, we already set isPro=true above.
              // If remote says false, we should probably downgrade unless we have a pending sync.
              // For this task, let's assume we sync FROM remote to local on init.
              await _downgradeToFree();
            }
          }
        }
      } catch (e) {
        debugPrint("Error syncing pro status: $e");
        // Fallback to local status (already set)
      }
    }

    if (isPro) {
      isTrialActive = false;
      notifyListeners();
      return;
    }

    // 3. Check Trial Status (if not Pro)
    String? trialStartStr = await _storage.read(key: _keyTrialStartDate);
    DateTime trialStartDate;

    if (trialStartStr == null) {
      // First time user, start trial
      trialStartDate = DateTime.now();
      await _storage.write(
        key: _keyTrialStartDate,
        value: trialStartDate.toIso8601String(),
      );
    } else {
      trialStartDate = DateTime.parse(trialStartStr);
    }

    _calculateTrialStatus(trialStartDate);
  }

  Future<void> _downgradeToFree() async {
    isPro = false;
    subscriptionEndDate = null;
    await _storage.write(key: _keyIsPro, value: 'false');
    await _storage.delete(key: _keySubscriptionEndDate);

    // Also update firebase if logged in
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'isPro': false,
        });
      } catch (e) {
        debugPrint("Error updating remote expiration: $e");
      }
    }
    notifyListeners();
  }

  Future<void> _enableProLocally(DateTime endDate) async {
    isPro = true;
    subscriptionEndDate = endDate;
    isTrialActive = false;
    await _storage.write(key: _keyIsPro, value: 'true');
    await _storage.write(
      key: _keySubscriptionEndDate,
      value: endDate.toIso8601String(),
    );
    notifyListeners();
  }

  void _calculateTrialStatus(DateTime startDate) {
    final now = DateTime.now();
    final difference = now.difference(startDate).inDays;

    if (difference < _trialDurationDays) {
      isTrialActive = true;
      remainingTrialDays = _trialDurationDays - difference;
    } else {
      isTrialActive = false;
      remainingTrialDays = 0;
    }
    notifyListeners();
  }

  int get remainingSubscriptionDays {
    if (subscriptionEndDate == null) return 0;
    final difference = subscriptionEndDate!.difference(DateTime.now()).inDays;
    return difference < 0 ? 0 : difference;
  }

  /// Returns true if user has access (Pro or Active Trial)
  /// If false, automatically shows the Premium Dialog
  bool checkAccess() {
    if (isPro) {
      // Double check expiration just in case
      if (subscriptionEndDate != null &&
          DateTime.now().isAfter(subscriptionEndDate!)) {
        _downgradeToFree(); // Handles local and remote update
        showPremiumDialog(isExpired: true);
        return false;
      }
      return true;
    } else if (isTrialActive) {
      return true;
    } else {
      showPremiumDialog();
      return false;
    }
  }

  void showPremiumDialog({bool isExpired = false}) {
    Get.defaultDialog(
      title: '',
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.workspace_premium,
              size: 48,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'premium_required'.tr,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            isExpired ? 'plan_expired'.tr : 'free_trial_ended'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'premium_required_message'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                Get.to(PricingView());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'buy_pro'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                Get.to(MainView());
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'later'.tr,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
      radius: 16,
    );
  }

  Future<void> enablePro(int durationDays) async {
    final endDate = DateTime.now().add(Duration(days: durationDays));

    // 1. Enable Locally
    await _enableProLocally(endDate);

    // 2. Sync to Firebase
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).set({
          'isPro': true,
          'subscription_end': endDate.toIso8601String(),
        }, SetOptions(merge: true));
      } catch (e) {
        // We still enabled it locally, so user gets what they paid for.
        // We might want to queue a sync later, but for now this is okay.
      }
    }
  }

  // For debugging/testing purposes
  Future<void> resetProStatus() async {
    await _storage.deleteAll();
    isPro = false;

    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'isPro': false,
        });
      } catch (e) {
        // We still enabled it locally, so user gets what they paid for.
        // We might want to queue a sync later, but for now this is okay.
      }
    }

    initializeProStatus();
  }
}
