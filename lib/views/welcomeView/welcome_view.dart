import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/views/mainView/main_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // Cache device size calculations
  late bool _isSmallDevice;
  late bool _isMediumDevice;
  late double _screenWidth;
  late double _screenHeight;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cache size calculations once
    final size = MediaQuery.of(context).size;
    _screenWidth = size.width;
    _screenHeight = size.height;
    _isSmallDevice = _screenHeight < 700;
    _isMediumDevice = _screenHeight >= 700 && _screenHeight < 800;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
            colors: [
              AppColors.darkMainBackground,
              AppColors.darkSecondaryBackground,
              AppColors.darkCardBackground,
            ],
            stops: const [0.0, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: constraints.maxHeight < 650
                    ? const AlwaysScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        SizedBox(
                          height: _isSmallDevice
                              ? 16
                              : _isMediumDevice
                              ? 24
                              : 32,
                        ),
                        Flexible(
                          flex: _isSmallDevice ? 4 : 5,
                          child: _buildIllustrationSection(),
                        ),
                        SizedBox(
                          height: _isSmallDevice
                              ? 20
                              : _isMediumDevice
                              ? 32
                              : 40,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _screenWidth * 0.06,
                          ),
                          child: _buildContentSection(),
                        ),
                        SizedBox(
                          height: _isSmallDevice
                              ? 24
                              : _isMediumDevice
                              ? 32
                              : 48,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            _screenWidth * 0.06,
                            0,
                            _screenWidth * 0.06,
                            _isSmallDevice
                                ? 24
                                : _isMediumDevice
                                ? 32
                                : 40,
                          ),
                          child: _buildButtonSection(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildIllustrationSection() {
    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: _buildFinanceIllustration(),
      ),
    );
  }

  Widget _buildFinanceIllustration() {
    final illustrationSize = _isSmallDevice
        ? _screenWidth * 0.75
        : _isMediumDevice
        ? _screenWidth * 0.8
        : _screenWidth * 0.85;

    final cardWidth = _isSmallDevice
        ? 240.0
        : _isMediumDevice
        ? 260.0
        : 280.0;
    final cardHeight = _isSmallDevice
        ? 150.0
        : _isMediumDevice
        ? 165.0
        : 180.0;
    final glowSize = _isSmallDevice
        ? 220.0
        : _isMediumDevice
        ? 250.0
        : 280.0;

    return SizedBox(
      width: illustrationSize,
      height: illustrationSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background glow - simplified
          Container(
            width: glowSize,
            height: glowSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryBlue.withValues(alpha: 0.25),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Main card
          Transform.rotate(
            angle: -0.05,
            child: Container(
              width: cardWidth,
              height: cardHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_isSmallDevice ? 20 : 24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryBlue,
                    AppColors.primaryBlue.withValues(alpha: 0.8),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withValues(alpha: 0.35),
                    blurRadius: _isSmallDevice ? 18 : 25,
                    offset: Offset(0, _isSmallDevice ? 8 : 10),
                  ),
                ],
              ),
              child: _buildCardContent(),
            ),
          ),

          // Floating coins - simplified with fade only
          ..._buildFloatingCoins(),

          // Stats card
          _buildStatsCard(),
        ],
      ),
    );
  }

  Widget _buildCardContent() {
    return Stack(
      children: [
        // Card chip
        Positioned(
          left: _isSmallDevice ? 20 : 24,
          top: _isSmallDevice ? 20 : 24,
          child: Container(
            width: _isSmallDevice ? 45 : 50,
            height: _isSmallDevice ? 36 : 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
        ),

        // Card number dots - simplified
        Positioned(
          left: _isSmallDevice ? 20 : 24,
          bottom: _isSmallDevice ? 52 : 60,
          child: _buildCardDots(),
        ),

        // Card holder
        Positioned(
          left: _isSmallDevice ? 20 : 24,
          bottom: _isSmallDevice ? 20 : 24,
          child: Text(
            'Your Finance',
            style: TextStyle(
              color: Colors.white,
              fontSize: _isSmallDevice ? 14 : 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ),

        // Logo
        Positioned(
          right: _isSmallDevice ? 20 : 24,
          bottom: _isSmallDevice ? 20 : 24,
          child: Icon(
            Icons.account_balance_wallet_outlined,
            color: Colors.white.withValues(alpha: 0.9),
            size: _isSmallDevice ? 28 : 32,
          ),
        ),
      ],
    );
  }

  Widget _buildCardDots() {
    return Row(
      children: List.generate(
        4,
        (index) => Padding(
          padding: EdgeInsets.only(right: _isSmallDevice ? 10 : 12),
          child: Row(
            children: List.generate(
              4,
              (i) => Container(
                width: _isSmallDevice ? 5 : 6,
                height: _isSmallDevice ? 5 : 6,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFloatingCoins() {
    final coin1Size = _isSmallDevice
        ? 50.0
        : _isMediumDevice
        ? 55.0
        : 60.0;
    final coin2Size = _isSmallDevice
        ? 42.0
        : _isMediumDevice
        ? 46.0
        : 50.0;
    final coin3Size = _isSmallDevice
        ? 46.0
        : _isMediumDevice
        ? 50.0
        : 55.0;

    return [
      Positioned(
        top: _isSmallDevice
            ? 30
            : _isMediumDevice
            ? 35
            : 40,
        right: _isSmallDevice
            ? 20
            : _isMediumDevice
            ? 25
            : 30,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _buildCoin(coin1Size, Icons.trending_up, 0.1),
        ),
      ),
      Positioned(
        top: _isSmallDevice
            ? 100
            : _isMediumDevice
            ? 110
            : 120,
        left: _isSmallDevice
            ? 15
            : _isMediumDevice
            ? 18
            : 20,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _buildCoin(coin2Size, Icons.analytics_outlined, -0.15),
        ),
      ),
      Positioned(
        bottom: _isSmallDevice
            ? 65
            : _isMediumDevice
            ? 75
            : 80,
        right: _isSmallDevice
            ? 30
            : _isMediumDevice
            ? 35
            : 40,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _buildCoin(coin3Size, Icons.savings_outlined, 0.08),
        ),
      ),
    ];
  }

  Widget _buildCoin(double size, IconData icon, double rotation) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryBlue.withValues(alpha: 0.9),
              AppColors.primaryBlue.withValues(alpha: 0.6),
            ],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: _isSmallDevice ? 1.5 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withValues(alpha: 0.25),
              blurRadius: _isSmallDevice ? 10 : 12,
              offset: Offset(0, _isSmallDevice ? 4 : 5),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.45),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Positioned(
      bottom: _isSmallDevice
          ? 15
          : _isMediumDevice
          ? 18
          : 20,
      left: _isSmallDevice
          ? 20
          : _isMediumDevice
          ? 25
          : 30,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _isSmallDevice ? 12 : 16,
            vertical: _isSmallDevice ? 10 : 12,
          ),
          decoration: BoxDecoration(
            color: AppColors.darkCardBackground,
            borderRadius: BorderRadius.circular(_isSmallDevice ? 14 : 16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_upward,
                color: Colors.greenAccent,
                size: _isSmallDevice ? 18 : 20,
              ),
              SizedBox(width: _isSmallDevice ? 6 : 8),
              Text(
                '+24.5%',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: _isSmallDevice ? 14 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'welcomeViewTitle'.tr,
              style: TextStyle(
                fontSize: _isSmallDevice
                    ? 30
                    : _isMediumDevice
                    ? 33
                    : 36,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
            SizedBox(
              height: _isSmallDevice
                  ? 8
                  : _isMediumDevice
                  ? 10
                  : 12,
            ),
            Text(
              'welcomeViewSubtitle'.tr,
              style: TextStyle(
                fontSize: _isSmallDevice
                    ? 14
                    : _isMediumDevice
                    ? 15
                    : 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonSection() {
    final buttonHeight = _isSmallDevice
        ? 52.0
        : _isMediumDevice
        ? 54.0
        : 56.0;
    final fontSize = _isSmallDevice
        ? 16.0
        : _isMediumDevice
        ? 17.0
        : 18.0;
    final iconSize = _isSmallDevice ? 20.0 : 22.0;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: () => Get.offAll(() => const MainView()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.textPrimary,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'welcomeViewButtonOne'.tr,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: _isSmallDevice ? 30 : 32,
                      height: _isSmallDevice ? 30 : 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        size: _isSmallDevice ? 16 : 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: _isSmallDevice ? 12 : 16),
            SizedBox(
              width: double.infinity,
              height: buttonHeight,
              child: OutlinedButton(
                onPressed: () => Get.offAll(() => const MainView()),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white.withValues(alpha: 0.8),
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_circle_outline, size: iconSize),
                    const SizedBox(width: 10),
                    Text(
                      'welcomeViewButtonTwo'.tr,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
