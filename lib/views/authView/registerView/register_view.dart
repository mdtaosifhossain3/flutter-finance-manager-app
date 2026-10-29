import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/services/bkash/bkash_subscription_service.dart';
import 'package:finance_manager_app/views/authView/phnVerificationView/phone_verification_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Simplified Registration View — bKash only.
/// User enters their bKash number, we launch the direct PGW authorization URL.
class RegisterView extends StatefulWidget {
  final String? initialMsisdn;
  const RegisterView({super.key, this.initialMsisdn});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  bool _isLoading = false;
  final TextEditingController _msisdnController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialMsisdn != null && widget.initialMsisdn!.isNotEmpty) {
      _msisdnController.text = BkashSubscriptionService.normalizeMsisdn(
        widget.initialMsisdn!,
      );
    }

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 650),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
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
    _msisdnController.dispose();
    super.dispose();
  }

  bool _isValidBdMsisdn(String value) {
    final clean = BkashSubscriptionService.normalizeMsisdn(value);
    return RegExp(r'^01[0-9]{9}$').hasMatch(clean);
  }

  Future<void> _handleRegister() async {
    HapticFeedback.mediumImpact();

    final msisdn = BkashSubscriptionService.normalizeMsisdn(
      _msisdnController.text.trim(),
    );
    if (!_isValidBdMsisdn(msisdn)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            '01 দিয়ে শুরু ১১ সংখ্যার সঠিক মোবাইল নম্বর দিন।',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // msisdn + paymentOption=bKash (hardcoded) → direct bKash PGW screen
    final launched = await BkashSubscriptionService.launchSubscription(
      msisdn: msisdn,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Could not open bKash payment. Please try again.',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else {
      _showWaitingBottomSheet(context);
    }
  }

  void _showWaitingBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.90,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkCardBackground
              : AppColors.lightMainBackground,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isDark ? AppColors.border : AppColors.lightBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 30,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryBlue.withValues(alpha: 0.2),
                      AppColors.primaryPurple.withValues(alpha: 0.2),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.open_in_browser_rounded,
                  color: AppColors.primaryBlue,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'bkash_modal_title'.tr,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'bkash_modal_desc'.tr,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkMainBackground.withValues(alpha: 0.6)
                    : AppColors.lightSecondaryBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildStepItem(
                    icon: Icons.touch_app_rounded,
                    title: 'step_1_title'.tr,
                    desc: 'step_1_desc'.tr,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildStepItem(
                    icon: Icons.check_circle_outline_rounded,
                    title: 'step_2_title'.tr,
                    desc: 'step_2_desc'.tr,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildStepItem(
                    icon: Icons.login_rounded,
                    title: 'step_3_title'.tr,
                    desc: 'step_3_desc'.tr,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(
                        color: isDark
                            ? AppColors.border
                            : AppColors.lightBorder,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Got it',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        Get.off(() => const PhoneVerificationView());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'open_login_screen'.tr,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem({
    required IconData icon,
    required String title,
    required String desc,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primaryBlue),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final topPadding = MediaQuery.of(context).padding.top;
    final canPop = Navigator.of(context).canPop();

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
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // Soft background glows (same as login screen)
              Positioned(
                top: -80,
                right: -60,
                child: _glow(220, AppColors.primaryBlue, isDark ? 0.18 : 0.14),
              ),
              Positioned(
                top: 60,
                left: -90,
                child: _glow(
                  200,
                  AppColors.primaryPurple,
                  isDark ? 0.14 : 0.10,
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(20, topPadding + 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Back button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: canPop
                          ? IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                              ),
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                              iconSize: 18,
                              style: IconButton.styleFrom(
                                backgroundColor: isDark
                                    ? AppColors.darkCardBackground
                                    : Colors.white,
                                padding: const EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: isDark
                                        ? AppColors.border
                                        : AppColors.lightHover,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(height: 48),
                    ),

                    const SizedBox(height: 8),

                    // Header
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.85, end: 1.0),
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeOutBack,
                            builder: (context, scale, child) {
                              return Transform.scale(
                                scale: scale,
                                child: child,
                              );
                            },
                            child: Image.asset(
                              'assets/images/new_logo.PNG',
                              height: 64,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 28),
                          Text(
                            'register_title'.tr,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'register_subtitle'.tr,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isDark
                                    ? AppColors.textSecondary
                                    : AppColors.lightTextMuted,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildProMembershipCard(theme, isDark),
                            const SizedBox(height: 16),
                            _buildBkashCard(theme, isDark),
                            const SizedBox(height: 24),
                            _buildRegisterButton(theme),
                            const SizedBox(height: 22),
                            _buildLoginLink(theme, isDark),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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

  Widget _buildProMembershipCard(ThemeData theme, bool isDark) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCardBackground
            : AppColors.lightMainBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? AppColors.primaryBlue.withValues(alpha: 0.3)
              : AppColors.primaryBlue.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(
              alpha: isDark ? 0.08 : 0.05,
            ),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryBlue.withValues(alpha: 0.08),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF5B7FFF), Color(0xFF8B5CF6)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'register_hero_title'.tr.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '৳89',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          TextSpan(
                            text: ' / month',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Divider(
                  color: isDark
                      ? AppColors.border.withValues(alpha: 0.6)
                      : AppColors.lightBorder.withValues(alpha: 0.6),
                  height: 1,
                ),
                const SizedBox(height: 18),
                _buildFeatureRow(
                  icon: Icons.check_circle_rounded,
                  text: 'feature_full_access'.tr,
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                _buildFeatureRow(
                  icon: Icons.auto_awesome_rounded,
                  text: 'feature_ai_insights'.tr,
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                _buildFeatureRow(
                  icon: Icons.pie_chart_rounded,
                  text: 'feature_reports_export'.tr,
                  isDark: isDark,
                ),

                const SizedBox(height: 12),
                _buildFeatureRow(
                  icon: Icons.verified_user_rounded,
                  text: 'feature_ad_free'.tr,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow({
    required IconData icon,
    required String text,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 14,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ),
      ],
    );
  }

  /// Single, fixed payment card — bKash only. No selector needed anymore.
  Widget _buildBkashCard(ThemeData theme, bool isDark) {
    const bkashPink = Color(0xFFE2136E);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bkashPink.withValues(alpha: isDark ? 0.10 : 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: bkashPink.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/bkash.png',
                height: 24,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Text(
                  'bKash',
                  style: TextStyle(
                    color: bkashPink,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: bkashPink.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '⚡ Direct bKash PGW',
                  style: TextStyle(
                    color: bkashPink,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'আপনার bKash নম্বর দিন',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'নম্বর দিলে সরাসরি বিকাশ পেমেন্ট গেটওয়ে (PGW) স্ক্রিনে চলে যাবে',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _msisdnController,
            keyboardType: TextInputType.phone,
            maxLength: 11,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
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
                      color: bkashPink,
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
                      color: isDark ? AppColors.border : AppColors.lightBorder,
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
              filled: true,
              fillColor: isDark
                  ? AppColors.darkMainBackground.withValues(alpha: 0.6)
                  : Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: isDark
                      ? AppColors.border
                      : bkashPink.withValues(alpha: 0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: bkashPink, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(ThemeData theme) {
    return AnimatedScale(
      scale: _isLoading ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: AnimatedOpacity(
        opacity: _isLoading ? 0.7 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryBlue, AppColors.primaryPurple],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: _isLoading
                ? []
                : [
                    BoxShadow(
                      color: AppColors.primaryBlue.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: _isLoading ? null : _handleRegister,
              child: SizedBox(
                height: 54,
                child: Center(
                  child: _isLoading
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
                              'register_button'.tr,
                              style: theme.textTheme.bodyLarge?.copyWith(
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
  }

  Widget _buildLoginLink(ThemeData theme, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'already_have_account'.tr,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Get.off(() => const PhoneVerificationView());
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Text(
              'login_here'.tr,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
