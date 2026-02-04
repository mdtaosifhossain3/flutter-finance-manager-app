import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_manager_app/views/mainView/main_view.dart';
import 'package:finance_manager_app/views/pricingView/premium_feature_view.dart';
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
  static const String _keyCredits = 'ai_credits';

  // State
  bool isPro = false;
  bool isTrialActive = false;
  int remainingTrialDays = 2;
  int credits = 0;
  DateTime? subscriptionEndDate;

  // Constants
  static const int _trialDurationDays = 0;

  ProProvider() {
    // _initializeProStatus(); // Removed automatic init
  }

  Future<void> initializeProStatus() async {
    debugPrint("ProProvider: initializeProStatus called");

    final user = _auth.currentUser;
    bool syncedFromRemote = false;

    // 1. Try Remote Sync First (if logged in)
    if (user != null) {
      debugPrint("ProProvider: Syncing with Firebase for user ${user.uid}");
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data();
          final bool remoteIsPro = data?['isPro'] ?? false;
          final String? remoteEndStr = data?['subscription_end'];
          final int remoteCredits = data?['credits'] ?? 0;
          final Timestamp? createdAtTimestamp = data?['created_at'];
          final String? remoteTrialStartStr = data?['trial_start'];

          // --- Sync Credits ---
          credits = remoteCredits;
          await _storage.write(key: _keyCredits, value: credits.toString());
          debugPrint("ProProvider: Synced credits: $credits");

          // --- Sync Pro Status ---
          if (remoteIsPro && remoteEndStr != null) {
            final remoteEndDate = DateTime.parse(remoteEndStr);
            if (DateTime.now().isAfter(remoteEndDate)) {
              // Remote says Pro, but it's expired.
              isPro = false;
              subscriptionEndDate = null;
              await _storage.write(key: _keyIsPro, value: 'false');
              await _storage.delete(key: _keySubscriptionEndDate);
              // Optionally update remote to false here, but let's focus on local state first
            } else {
              // Remote is valid Pro
              isPro = true;
              subscriptionEndDate = remoteEndDate;
              await _storage.write(key: _keyIsPro, value: 'true');
              await _storage.write(
                key: _keySubscriptionEndDate,
                value: remoteEndStr,
              );
            }
          } else {
            // Remote says NOT Pro
            isPro = false;
            subscriptionEndDate = null;
            await _storage.write(key: _keyIsPro, value: 'false');
            await _storage.delete(key: _keySubscriptionEndDate);
          }

          // --- Sync Trial Start Date ---
          // Prioritize created_at as the true start of the user's journey
          if (createdAtTimestamp != null) {
            final createdAt = createdAtTimestamp.toDate();
            await _storage.write(
              key: _keyTrialStartDate,
              value: createdAt.toIso8601String(),
            );
            // If we have created_at, that IS the trial start.
          } else if (remoteTrialStartStr != null) {
            // Fallback to trial_start if created_at is missing
            await _storage.write(
              key: _keyTrialStartDate,
              value: remoteTrialStartStr,
            );
          }

          syncedFromRemote = true;
        }
      } catch (e) {
        debugPrint("Error syncing pro status: $e");
      }
    }

    // 2. If Remote Sync didn't happen (Offline/Not Logged In/Error), Check Local
    if (!syncedFromRemote) {
      String? proStatus = await _storage.read(key: _keyIsPro);
      String? subEndStr = await _storage.read(key: _keySubscriptionEndDate);
      String? creditsStr = await _storage.read(key: _keyCredits);

      if (creditsStr != null) {
        credits = int.tryParse(creditsStr) ?? 0;
      }

      if (proStatus == 'true') {
        if (subEndStr != null) {
          subscriptionEndDate = DateTime.parse(subEndStr);
          if (DateTime.now().isAfter(subscriptionEndDate!)) {
            await _downgradeToFree();
          } else {
            isPro = true;
          }
        } else {
          isPro = true;
        }
      }
    }

    if (isPro) {
      isTrialActive = false;
      notifyListeners();
      return;
    }

    // 3. Check Trial Status (if not Pro)
    // We read from storage again because it might have been updated by remote sync
    String? trialStartStr = await _storage.read(key: _keyTrialStartDate);
    DateTime trialStartDate;

    bool isNewTrial = trialStartStr == null;

    if (isNewTrial) {
      // First time user (or lost data), start trial
      trialStartDate = DateTime.now();
      await _storage.write(
        key: _keyTrialStartDate,
        value: trialStartDate.toIso8601String(),
      );

      // Sync new trial start to Firebase if logged in
      if (user != null) {
        try {
          await _firestore.collection('users').doc(user.uid).set({
            'trial_start': trialStartDate.toIso8601String(),
          }, SetOptions(merge: true));
        } catch (e) {
          debugPrint("Error syncing trial start: $e");
        }
      }
    } else {
      trialStartDate = DateTime.parse(trialStartStr);
    }

    _calculateTrialStatus(trialStartDate);

    // Grant trial credits if applicable (New trial or existing trial with no credit history)
    // Only grant if we have 0 credits currently (and didn't just sync positive credits)
    // If syncedFromRemote is true, we trust 'credits' (which came from remote).
    // If syncedFromRemote is false, we trust 'credits' (which came from local).
    // If credits is 0, we might give trial credits.
    // BUT, if we synced from remote and remote said 0, maybe they used them all?
    // We should only grant trial credits if we effectively "just started" the trial or never got them.
    // The previous check `creditsStr == null` was good for local.
    // If we synced from remote, `credits` is set.
    // Let's stick to: If trial active AND credits == 0.
    // But wait, if I used all my credits, I have 0. I shouldn't get 20 again just because I restarted app.
    // We need a flag "trial_credits_given".
    // For now, let's rely on the fact that if we synced, we have the correct credits.
    // If we created a NEW trial (trialStartStr == null), we give credits.

    if (isTrialActive && isNewTrial) {
      credits = 20;
      await _storage.write(key: _keyCredits, value: '20');
      notifyListeners();
      debugPrint("ProProvider: Granted trial credits: 20 (New Trial)");

      // Sync the 20 credits to remote immediately
      if (user != null) {
        try {
          await _firestore.collection('users').doc(user.uid).update({
            'credits': 20,
          });
        } catch (e) {
          debugPrint("Error syncing trial credits: $e");
        }
      }
    } else if (isTrialActive && credits == 0 && !syncedFromRemote) {
      // Fallback: If we are offline, and have 0 credits, and trial is active...
      // Maybe we shouldn't give them?
      // Let's stick to the "New Trial" trigger for now to avoid infinite credits.
      // User said "When user in Free trial he will get 20 Free trial".
      // If I clear storage -> login -> syncs trial start (old) -> isNewTrial = false.
      // So I won't get credits again. This is correct behavior (don't exploit).
      // Unless I never got them?
      // If remote credits is 0, and I am in trial... well, I probably used them.
    }
  }

  Future<void> unsubscribe() async {
    await _downgradeToFree();
  }

  Future<void> _downgradeToFree() async {
    isPro = false;
    subscriptionEndDate = null;
    // We don't clear credits on downgrade, user might still have them?
    // Or maybe we do? For now let's keep them.
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

  Future<bool> consumeCredit() async {
    if (credits > 0) {
      credits--;
      await _storage.write(key: _keyCredits, value: credits.toString());
      notifyListeners();

      // Sync to Firebase
      final user = _auth.currentUser;
      if (user != null) {
        try {
          await _firestore.collection('users').doc(user.uid).update({
            'credits': credits,
          });
        } catch (e) {
          debugPrint("Error updating credits: $e");
        }
      }
      return true;
    }
    return false;
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
          isExpired ? const SizedBox(height: 12) : const SizedBox(height: 0),
          Text(
            isExpired ? 'plan_expired'.tr : '',
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
                Get.to(PremiumFeatureView());
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

  Future<void> enablePro(int durationDays, int credits) async {
    final endDate = DateTime.now().add(Duration(days: durationDays));

    // 1. Enable Locally
    this.credits = credits; // Update local credits
    await _storage.write(key: _keyCredits, value: credits.toString());
    await _enableProLocally(endDate);

    // 2. Sync to Firebase
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).set({
          'isPro': true,
          'subscription_end': endDate.toIso8601String(),
          'credits': credits,
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
    credits = 0;

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

  /// Set credits to fixed amount (500)
  Future<void> setCredits500() async {
    const int fixedCredits = 60;

    // Skip if already 500
    if (credits == fixedCredits) return;

    credits = fixedCredits;

    // Save locally
    await _storage.write(key: _keyCredits, value: fixedCredits.toString());

    notifyListeners();

    // Sync to Firebase if logged in
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'credits': fixedCredits,
        });
      } catch (e) {
        debugPrint("Error setting fixed credits: $e");
      }
    }
  }
}
