import 'package:finance_manager_app/views/profileView/widgets/edit_profile_view.dart';
import 'package:finance_manager_app/views/profileView/widgets/security_view.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class AppColors {
  static const Color honeyDew = Color(0xffF1FFF3);
  static const Color lightGreen = Color(0xffDFF7E2);
  static const Color carbbeanGreen = Color(0xff00D09E);
  static const Color cyprus = Color(0xff0E3E3E);
  static const Color fencGreen = Color(0xff052224);
  static const Color voidB = Color(0xff031314);
  static const Color lightBlue = Color(0xff6DB6FE);
  static const Color vividBlue = Color(0xff3299FF);
  static const Color oceanBlue = Color(0xff0068FF);
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.carbbeanGreen,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Profile',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Content Container
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.honeyDew,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Profile Picture and Info
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 48,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'John Smith',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.cyprus,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '+880 1234567890',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.cyprus.withValues(alpha: 0.6),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Menu Items
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            _buildMenuItem(
                              icon: Icons.person_outline,
                              title: 'Edit Profile',
                              color: AppColors.lightBlue,
                              onTap: () {
                                Get.to(EditProfileView());
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildMenuItem(
                              icon: Icons.verified_user_outlined,
                              title: 'Security',
                              color: AppColors.vividBlue,
                              onTap: () {},
                            ),
                            const SizedBox(height: 16),
                            _buildMenuItem(
                              icon: Icons.settings_outlined,
                              title: 'Setting',
                              color: AppColors.lightBlue,
                              onTap: () {
                                Get.to(SettingsView());
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildMenuItem(
                              icon: Icons.help_outline,
                              title: 'Help',
                              color: AppColors.vividBlue,
                              onTap: () {},
                            ),
                            const SizedBox(height: 16),
                            _buildMenuItem(
                              icon: Icons.logout_outlined,
                              title: 'Logout',
                              color: AppColors.lightBlue,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bottom Navigation Placeholder
                    // Container(
                    //   height: 80,
                    //   padding: const EdgeInsets.symmetric(horizontal: 20),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //     children: [
                    //       _buildBottomNavItem(Icons.home_outlined, false),
                    //       _buildBottomNavItem(Icons.qr_code_scanner_outlined, false),
                    //       _buildBottomNavItem(Icons.swap_horiz_outlined, false),
                    //       _buildBottomNavItem(Icons.grid_view_outlined, false),
                    //       _buildBottomNavItem(Icons.person, true),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.cyprus,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: AppColors.cyprus.withValues(alpha: 0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
