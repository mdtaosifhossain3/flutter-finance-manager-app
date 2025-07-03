import 'package:flutter/material.dart';

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

// Main Settings Screen
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.carbbeanGreen,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, 'Settings'),

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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            _buildSettingsItem(
                              icon: Icons.notifications_outlined,
                              title: 'Notification Settings',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const NotificationSettingsView(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildSettingsItem(
                              icon: Icons.lock_outline,
                              title: 'Password Settings',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PasswordSettingsView(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildSettingsItem(
                              icon: Icons.delete_outline,
                              title: 'Delete Account',
                              onTap: () {
                                _showDeleteAccountDialog(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildBottomNavBar(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
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
                color: AppColors.carbbeanGreen,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.cyprus,
                ),
              ),
            ),
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

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion requested')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// Notification Settings Screen
class NotificationSettingsView extends StatefulWidget {
  const NotificationSettingsView({super.key});

  @override
  State<NotificationSettingsView> createState() =>
      _NotificationSettingsViewState();
}

class _NotificationSettingsViewState extends State<NotificationSettingsView> {
  bool generalNotification = true;
  bool sound = true;
  bool soundCall = true;
  bool vibrate = true;
  bool transactionUpdate = false;
  bool expenseReminder = false;
  bool budgetNotifications = false;
  bool lowBalanceAlerts = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.carbbeanGreen,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, 'Notification Settings'),

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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            _buildNotificationToggle(
                              'General Notification',
                              generalNotification,
                              (value) {
                                setState(() => generalNotification = value);
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildNotificationToggle('Sound', sound, (value) {
                              setState(() => sound = value);
                            }),
                            const SizedBox(height: 20),
                            _buildNotificationToggle('Sound Call', soundCall, (
                              value,
                            ) {
                              setState(() => soundCall = value);
                            }),
                            const SizedBox(height: 20),
                            _buildNotificationToggle('Vibrate', vibrate, (
                              value,
                            ) {
                              setState(() => vibrate = value);
                            }),
                            const SizedBox(height: 20),
                            _buildNotificationToggle(
                              'Transaction Update',
                              transactionUpdate,
                              (value) {
                                setState(() => transactionUpdate = value);
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildNotificationToggle(
                              'Expense Reminder',
                              expenseReminder,
                              (value) {
                                setState(() => expenseReminder = value);
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildNotificationToggle(
                              'Budget Notifications',
                              budgetNotifications,
                              (value) {
                                setState(() => budgetNotifications = value);
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildNotificationToggle(
                              'Low Balance Alerts',
                              lowBalanceAlerts,
                              (value) {
                                setState(() => lowBalanceAlerts = value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildBottomNavBar(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationToggle(
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.cyprus,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.carbbeanGreen,
            activeTrackColor: AppColors.carbbeanGreen.withValues(alpha: 0.3),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}

// Password Settings Screen
class PasswordSettingsView extends StatefulWidget {
  const PasswordSettingsView({super.key});

  @override
  State<PasswordSettingsView> createState() => _PasswordSettingsViewState();
}

class _PasswordSettingsViewState extends State<PasswordSettingsView> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.carbbeanGreen,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, 'Password Settings'),

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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            _buildPasswordField(
                              'Current Password',
                              _currentPasswordController,
                              _obscureCurrentPassword,
                              () => setState(
                                () => _obscureCurrentPassword =
                                    !_obscureCurrentPassword,
                              ),
                            ),
                            const SizedBox(height: 30),
                            _buildPasswordField(
                              'New Password',
                              _newPasswordController,
                              _obscureNewPassword,
                              () => setState(
                                () =>
                                    _obscureNewPassword = !_obscureNewPassword,
                              ),
                            ),
                            const SizedBox(height: 30),
                            _buildPasswordField(
                              'Confirm New Password',
                              _confirmPasswordController,
                              _obscureConfirmPassword,
                              () => setState(
                                () => _obscureConfirmPassword =
                                    !_obscureConfirmPassword,
                              ),
                            ),
                            const SizedBox(height: 40),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_newPasswordController.text ==
                                      _confirmPasswordController.text) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Password changed successfully!',
                                        ),
                                        backgroundColor:
                                            AppColors.carbbeanGreen,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Passwords do not match!',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.carbbeanGreen,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: const Text(
                                  'Change Password',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildBottomNavBar(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool obscureText,
    VoidCallback onToggleVisibility,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.cyprus,
          ),
        ),
        const SizedBox(height: 8),
        Container(
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: List.generate(
                      8,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: obscureText
                              ? AppColors.cyprus
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: onToggleVisibility,
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.cyprus.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Common Header Widget
Widget _buildHeader(BuildContext context, String title) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert, color: Colors.white, size: 24),
        ),
      ],
    ),
  );
}

// Common Bottom Navigation Bar
Widget _buildBottomNavBar(BuildContext context) {
  return Container(
    height: 80,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildBottomNavItem(Icons.home_outlined, false),
        _buildBottomNavItem(Icons.qr_code_scanner_outlined, false),
        _buildBottomNavItem(Icons.swap_horiz_outlined, false),
        _buildBottomNavItem(Icons.grid_view_outlined, false),
        _buildBottomNavItem(Icons.person, true),
      ],
    ),
  );
}

Widget _buildBottomNavItem(IconData icon, bool isActive) {
  return Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: isActive ? AppColors.carbbeanGreen : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Icon(
      icon,
      color: isActive ? Colors.white : AppColors.cyprus.withValues(alpha: 0.5),
      size: 24,
    ),
  );
}
