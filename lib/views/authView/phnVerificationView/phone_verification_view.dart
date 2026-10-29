import 'dart:async';
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
        backgroundColor: isDark
            ? AppColors.darkMainBackground
            : AppColors.lightCardBackground,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Section
              _buildHeader(context, theme, isDark),

              // Input card section
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildInputCard(context, theme, isDark),
                        const SizedBox(height: 20),

                        // Secure note
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.verified_user_rounded,
                              size: 16,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'login_secure_note'.tr,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isDark
                                      ? AppColors.textSecondary
                                      : AppColors.lightTextMuted,
                                ),
                              ),
                            ),
                          ],
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Clean header: brand logo on the page background with soft blue glows.
  Widget _buildHeader(BuildContext context, ThemeData theme, bool isDark) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // Soft background glows
        Positioned(
          top: -80,
          right: -60,
          child: _glow(220, AppColors.primaryBlue, isDark ? 0.18 : 0.14),
        ),
        Positioned(
          top: 60,
          left: -90,
          child: _glow(200, AppColors.primaryPurple, isDark ? 0.14 : 0.10),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(24, topPadding + 48, 24, 32),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Brand logo
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.85, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutBack,
                  builder: (context, scale, child) {
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: Image.asset(
                    'assets/images/new_logo.PNG',
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 36),

                // Title
                Text(
                  'welcome_back'.tr,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textPrimary
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
                        : AppColors.lightTextMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Blurred circular glow used as a background decoration.
  Widget _glow(double size, Color color, double alpha) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: alpha),
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }

  /// Card holding the phone number field and the login button.
  Widget _buildInputCard(BuildContext context, ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCardBackground
            : AppColors.lightMainBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? AppColors.border.withValues(alpha: 0.6)
              : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(
              alpha: isDark ? 0.08 : 0.12,
            ),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card title
          Text(
            'login_title'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 18),

          // Input Label
          Text(
            'enter_registered_phone'.tr,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 10),

          // Mobile Number TextField
          Consumer<PhoneAuthProvider>(
            builder: (context, authProvider, child) {
              return TextField(
                controller: authProvider.mobileController,
                keyboardType: TextInputType.phone,
                maxLength: 11,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 14, right: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.phone_iphone_rounded,
                          size: 20,
                          color: AppColors.primaryBlue,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '+88',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 1,
                          height: 22,
                          color: isDark
                              ? AppColors.border
                              : AppColors.lightBorder,
                        ),
                      ],
                    ),
                  ),
                  hintText: '01XXXXXXXXX',
                  hintStyle: TextStyle(
                    letterSpacing: 1.2,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted.withValues(alpha: 0.7),
                  ),
                  counterText: '',
                  errorText: authProvider.errorMessage.isNotEmpty
                      ? authProvider.errorMessage
                      : null,
                  filled: true,
                  fillColor: isDark
                      ? AppColors.darkMainBackground.withValues(alpha: 0.6)
                      : AppColors.lightCardBackground,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.border : AppColors.lightHover,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: AppColors.primaryBlue,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: AppColors.error,
                      width: 1.5,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
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

          // Gradient Login Button
          Consumer<PhoneAuthProvider>(
            builder: (context, authProvider, child) {
              final isLoading = authProvider.isLoading;

              return AnimatedScale(
                scale: isLoading ? 0.97 : 1.0,
                duration: const Duration(milliseconds: 100),
                child: AnimatedOpacity(
                  opacity: isLoading ? 0.7 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primaryBlue,
                          AppColors.primaryPurple,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: isLoading
                          ? []
                          : [
                              BoxShadow(
                                color: AppColors.primaryBlue.withValues(
                                  alpha: 0.35,
                                ),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: isLoading
                            ? null
                            : () {
                                HapticFeedback.mediumImpact();
                                _handleSubmit(context, authProvider);
                              },
                        child: SizedBox(
                          height: 54,
                          child: Center(
                            child: isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'login_button'.tr,
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
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
