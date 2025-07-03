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

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final TextEditingController _usernameController = TextEditingController(
    text: 'john smith',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '+44 555 6555 50',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'johnsmith@support@gmail.com',
  );

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Edit My Profile',
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Profile Picture
                      Stack(
                        children: [
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
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.carbbeanGreen,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
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
                        'ID: 26012024',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.cyprus.withValues(alpha: 0.6),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Account Settings Section
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Account Settings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.cyprus,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Username Field
                      _buildInputField(
                        label: 'Username',
                        controller: _usernameController,
                      ),

                      const SizedBox(height: 20),

                      // Phone Field
                      _buildInputField(
                        label: 'Phone',
                        controller: _phoneController,
                      ),

                      const SizedBox(height: 20),

                      // Email Field
                      _buildInputField(
                        label: 'Email Address',
                        controller: _emailController,
                      ),

                      const SizedBox(height: 40),

                      // Update Profile Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle update profile
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile updated successfully!'),
                                backgroundColor: AppColors.carbbeanGreen,
                              ),
                            );
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
                            'Update Profile',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.cyprus,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightGreen,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.transparent, width: 1),
          ),
          child: TextFormField(
            controller: controller,
            style: TextStyle(fontSize: 16, color: AppColors.cyprus),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: AppColors.cyprus.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
