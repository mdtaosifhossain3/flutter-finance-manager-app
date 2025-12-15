import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:finance_manager_app/models/userProfileModel/user_profile_model.dart';
import 'package:finance_manager_app/views/authView/auth/login_view.dart';
import 'package:finance_manager_app/views/mainView/main_view.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finance_manager_app/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  bool isLoading = false;

  Future<void> checkAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uid = prefs.getString('user_uid');

    if (uid != null && uid.isNotEmpty) {
      Get.offAll(MainView());
    } else {
      // Fallback to Firebase Auth check if needed, or just go to Welcome/Login
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await prefs.setString('user_uid', user.uid);
        Get.offAll(MainView());
      } else {
        Get.offAll(const LoginView());
      }
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final user = await _service.loginWithEmail(email, password);
      if (user != null) {
        final profile = await getUserProfile(user.uid);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_uid', user.uid);
        await prefs.setString('userName', profile!.name);
        await prefs.setString('email', email);
        Get.offAll(MainView());
        Get.snackbar(
          "successTitle".tr,
          "logged_in_success".tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final user = await _service.registerWithEmail(
        name: name,
        email: email,
        password: password,
      );

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_uid', user.uid);
        await prefs.setString('userName', name);
        await prefs.setString('email', email);

        Get.offAll(MainView());
        Get.snackbar(
          "successTitle".tr,
          "registered_success".tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _service.resetPassword(email);
      Get.defaultDialog(
        title: "reset_password".tr,
        middleText: "password_reset_sent".tr,
        textConfirm: "Close",
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back(); // Close dialog
          Get.back(); // Go back to Login View
        },
      );
    } catch (e) {
      _handleAuthError(e);
    }
  }

  Future<void> googleLogin() async {
    try {
      isLoading = true;
      notifyListeners();

      final user = await _service.signInWithGoogle();
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_uid', user.uid);
        final profile = await getUserProfile(user.uid);
        if (profile != null) {
          await prefs.setString('userName', profile.name);
          await prefs.setString('email', profile.email);
        } else {
          // Handle case where profile might not exist yet if it's a new user via Google
          // Though auth_service creates it.
          await prefs.setString('userName', user.displayName ?? "");
          await prefs.setString('email', user.email ?? "");
        }

        Get.offAll(MainView());
        Get.snackbar(
          "successTitle".tr,
          "google_login_success".tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_uid');
    await FirebaseAuth.instance.signOut();
    // await GoogleSignIn().signOut(); // If you want to sign out from Google as well
    Get.offAll(const LoginView());
    Get.snackbar(
      "successTitle".tr,
      "logged_out_success".tr,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> deleteAccount() async {
    try {
      isLoading = true;
      notifyListeners();

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // 1. Delete Firestore Data
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .delete();

        // 2. Delete Auth Account
        await user.delete();

        // 3. Clear Local Data
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear(); // Clears all shared prefs including user_uid

        Get.offAll(const LoginView());
        Get.snackbar(
          "account_deleted_title".tr,
          "account_deleted_msg".tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      _handleAuthError(e);
      // If requires-recent-login error, prompt user to re-login
      if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
        Get.snackbar(
          "security_check_title".tr,
          "relogin_delete_msg".tr,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        logout();
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _handleAuthError(Object e) {
    String message = "An unknown error occurred";

    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          message = "user_not_found".tr;
          break;
        case 'wrong-password':
          message = "wrong_password".tr;
          break;
        case 'email-already-in-use':
          message = "email_in_use".tr;
          break;
        case 'invalid-email':
          message = "invalid_credential".tr;
          break;
        case 'weak-password':
          message = "weak_password".tr;
          break;
        case 'operation-not-allowed':
          message = "operation_not_allowed".tr;
          break;
        case 'network-request-failed':
          message = "network_error".tr;
          break;
        case 'too-many-requests':
          message = "too_many_requests".tr;
          break;
        case 'invalid-credential':
          message = "invalid_credential".tr;
          break;
        default:
          if (e.message != null &&
              e.message!.contains(
                "The supplied auth credential is incorrect",
              )) {
            message = "invalid_credential_session".tr;
          } else {
            message = e.message ?? "auth_failed".tr;
          }
      }
    } else if (e is SocketException) {
      message = "no_internet_connection".tr;
    } else if (e is TimeoutException) {
      message = "connection_timeout".tr;
    } else if (e is GoogleSignInException) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        // User cancelled, do nothing or show a simple message
        return;
      } else {
        message = "google_sign_in_failed".tr;
      }
    } else {
      message = e.toString();
    }

    Get.snackbar(
      "error_title".tr,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    // 🔹 If profile does NOT exist
    if (!doc.exists) {
      return null;
    }

    return UserProfile.fromMap(doc.id, doc.data()!);
  }
}
