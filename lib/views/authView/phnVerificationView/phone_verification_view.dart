import 'dart:async';
import 'dart:math' as math;
import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/providers/phone_auth_provider.dart';
import 'package:finance_manager_app/services/analytics/analytics_service.dart';
import 'package:finance_manager_app/views/authView/registerView/register_view.dart';
import 'package:finance_manager_app/views/mainView/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

/// Modern authentication page — checks BDApps subscription status.
/// If subscribed (S1000) → login → MainView.
/// If not subscribed → RegisterView (bKash payment).
class PhoneVerificationView extends StatelessWidget {
  const PhoneVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PhoneAuthProvider(),
      child: const _AuthPageContent(),
    );
  }
}

class _AuthPageContent extends StatefulWidget {
  const _AuthPageContent();

  @override
  State<_AuthPageContent> createState() => _AuthPageContentState();
}

class _AuthPageContentState extends State<_AuthPageContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [AppColors.darkMainBackground, AppColors.darkCardBackground]
                  : [
                      AppColors.lightMainBackground,
                      AppColors.lightCardBackground,
                    ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  // Header Section
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        // Animated Icon Badge
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.95, end: 1.0),
                          duration: const Duration(milliseconds: 1500),
                          curve: Curves.easeInOut,
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue.withValues(
                                    alpha: 0.1,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.lock_person_rounded,
                                  size: 54,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        // Title
                        Text(
                          'login_title'.tr,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Subtitle
                        Text(
                          'login_subtitle'.tr,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Mobile Number Input Section with slide animation
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Input Card Container
                          Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkCardBackground
                                  : AppColors.lightCardBackground,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Input Label
                                Text(
                                  'enter_registered_phone'.tr,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.textPrimary
                                        : AppColors.lightTextPrimary,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Mobile Number TextField
                                Consumer<PhoneAuthProvider>(
                                  builder: (context, authProvider, child) {
                                    return TextField(
                                      controller: authProvider.mobileController,
                                      keyboardType: TextInputType.phone,
                                      maxLength: 11,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                          ),
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.phone_outlined,
                                          color: AppColors.primaryBlue,
                                        ),
                                        hintText: '01XXXXXXXXX',
                                        counterText: '',
                                        errorText:
                                            authProvider.errorMessage.isNotEmpty
                                            ? authProvider.errorMessage
                                            : null,
                                        filled: true,
                                        fillColor: isDark
                                            ? AppColors.darkMainBackground
                                                  .withValues(alpha: 0.5)
                                            : AppColors.lightMainBackground,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: const BorderSide(
                                            color: AppColors.primaryBlue,
                                            width: 2,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: const BorderSide(
                                            color: AppColors.error,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 24),

                                // Login Action Button with scale animation
                                Consumer<PhoneAuthProvider>(
                                  builder: (context, authProvider, child) {
                                    final isLoading = authProvider.isLoading;

                                    return AnimatedScale(
                                      scale: isLoading ? 0.95 : 1.0,
                                      duration: const Duration(
                                        milliseconds: 100,
                                      ),
                                      child: ElevatedButton(
                                        onPressed: isLoading
                                            ? null
                                            : () {
                                                HapticFeedback.mediumImpact();
                                                _handleSubmit(
                                                  context,
                                                  authProvider,
                                                );
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.primaryBlue,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          elevation: isLoading ? 0 : 2,
                                          disabledBackgroundColor: AppColors
                                              .primaryBlue
                                              .withValues(alpha: 0.5),
                                        ),
                                        child: isLoading
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Colors.white),
                                                ),
                                              )
                                            : Text(
                                                'login_button'.tr,
                                                style: theme.textTheme.bodyLarge
                                                    ?.copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                              ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 28),

                          // Switch to Register Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'dont_have_account'.tr,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isDark
                                      ? AppColors.textSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  final provider = context
                                      .read<PhoneAuthProvider>();

                                  Get.to(
                                    () => RegisterView(
                                      initialMsisdn: provider
                                          .mobileController
                                          .text
                                          .trim(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    'register_here'.tr,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.primaryBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Handles form submission: checks BDApps subscription status.
  Future<void> _handleSubmit(
    BuildContext context,
    PhoneAuthProvider provider,
  ) async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    // Call BDApps status API
    final result = await provider.checkBdAppsStatus();

    if (!context.mounted) return;

    if (result == 1) {
      // S1000 → subscribed → navigate to main app
      await AnalyticsService.instance.logLogin(method: 'Mobile');
      Get.offAll(() => const MainView());
    } else if (result == 0) {
      // Not subscribed → navigate to RegisterView for bKash payment
      Get.to(
        () =>
            RegisterView(initialMsisdn: provider.mobileController.text.trim()),
      );
    }
    // result == -1 → error already set in provider state, displayed on TextField
  }
}
