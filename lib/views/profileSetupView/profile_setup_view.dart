import 'package:finance_manager_app/views/loadingView/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// Color palette
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

// Updated ViewModel
class ProfileSetupViewModel {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController moneyController = TextEditingController();
  // final TextEditingController countryController = TextEditingController();
  String selectedCountryCode = '';

  final List<Map<String, String>> countries = [
    {'name': 'Afghanistan', 'code': 'AF', 'currency': '؋'},
    {'name': 'Albania', 'code': 'AL', 'currency': 'L'},
    {'name': 'Algeria', 'code': 'DZ', 'currency': 'د.ج'},
    {'name': 'Argentina', 'code': 'AR', 'currency': '\$'},
    {'name': 'Australia', 'code': 'AU', 'currency': '\$'},
    {'name': 'Austria', 'code': 'AT', 'currency': '€'},
    {'name': 'Bangladesh', 'code': 'BD', 'currency': '৳'},
    {'name': 'Belgium', 'code': 'BE', 'currency': '€'},
    {'name': 'Brazil', 'code': 'BR', 'currency': 'R\$'},
    {'name': 'Canada', 'code': 'CA', 'currency': '\$'},
    {'name': 'China', 'code': 'CN', 'currency': '¥'},
    {'name': 'Denmark', 'code': 'DK', 'currency': 'kr'},
    {'name': 'Egypt', 'code': 'EG', 'currency': '£'},
    {'name': 'Finland', 'code': 'FI', 'currency': '€'},
    {'name': 'France', 'code': 'FR', 'currency': '€'},
    {'name': 'Germany', 'code': 'DE', 'currency': '€'},
    {'name': 'Greece', 'code': 'GR', 'currency': '€'},
    {'name': 'India', 'code': 'IN', 'currency': '₹'},
    {'name': 'Indonesia', 'code': 'ID', 'currency': 'Rp'},
    {'name': 'Iran', 'code': 'IR', 'currency': '﷼'},
    {'name': 'Iraq', 'code': 'IQ', 'currency': 'ع.د'},
    {'name': 'Ireland', 'code': 'IE', 'currency': '€'},
    {'name': 'Italy', 'code': 'IT', 'currency': '€'},
    {'name': 'Japan', 'code': 'JP', 'currency': '¥'},
    {'name': 'Malaysia', 'code': 'MY', 'currency': 'RM'},
    {'name': 'Mexico', 'code': 'MX', 'currency': '\$'},
    {'name': 'Netherlands', 'code': 'NL', 'currency': '€'},
    {'name': 'Norway', 'code': 'NO', 'currency': 'kr'},
    {'name': 'Pakistan', 'code': 'PK', 'currency': '₨'},
    {'name': 'Philippines', 'code': 'PH', 'currency': '₱'},
    {'name': 'Poland', 'code': 'PL', 'currency': 'zł'},
    {'name': 'Russia', 'code': 'RU', 'currency': '₽'},
    {'name': 'Saudi Arabia', 'code': 'SA', 'currency': '﷼'},
    {'name': 'Singapore', 'code': 'SG', 'currency': '\$'},
    {'name': 'South Africa', 'code': 'ZA', 'currency': 'R'},
    {'name': 'South Korea', 'code': 'KR', 'currency': '₩'},
    {'name': 'Spain', 'code': 'ES', 'currency': '€'},
    {'name': 'Sweden', 'code': 'SE', 'currency': 'kr'},
    {'name': 'Switzerland', 'code': 'CH', 'currency': 'CHF'},
    {'name': 'Thailand', 'code': 'TH', 'currency': '฿'},
    {'name': 'Turkey', 'code': 'TR', 'currency': '₺'},
    {'name': 'United Arab Emirates', 'code': 'AE', 'currency': 'د.إ'},
    {'name': 'United Kingdom', 'code': 'GB', 'currency': '£'},
    {'name': 'United States', 'code': 'US', 'currency': '\$'},
    {'name': 'Vietnam', 'code': 'VN', 'currency': '₫'},
  ];

  void setupProfile(BuildContext context) {
    if (_validateInputs()) {
      // Map<String, String> selectedCountry = countries.firstWhere(
      //       (country) => country['name'] == countryController.text,
      //   orElse: () => {'name': '', 'code': '', 'currency': ''},
      // );

      // Get the currency symbol
      // String currencySymbol = selectedCountry['currency'] ?? '';
      // Navigate to main view
      Get.to(LoadingView());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile setup completed!'),
          backgroundColor: AppColors.carbbeanGreen,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool _validateInputs() {
    return nameController.text.isNotEmpty && moneyController.text.isNotEmpty;
    // countryController.text.isNotEmpty;
  }

  void dispose() {
    nameController.dispose();
    moneyController.dispose();
    //  countryController.dispose();
  }
}

class ProfileSetupView extends StatefulWidget {
  const ProfileSetupView({super.key});

  @override
  State<ProfileSetupView> createState() => _ProfileSetupViewState();
}

class _ProfileSetupViewState extends State<ProfileSetupView> {
  final ProfileSetupViewModel _viewModel = ProfileSetupViewModel();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.honeyDew,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Header section
                  _buildHeader(),
                  const SizedBox(height: 40),
                  // Form fields
                  _buildNameField(),
                  const SizedBox(height: 20),
                  _buildIncomeField(),
                  // const SizedBox(height: 20),
                  // _buildCountryField(context),
                  const SizedBox(height: 40),
                  // Submit button
                  _buildSubmitButton(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo container
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.carbbeanGreen.withValues(alpha: 0.2),
                AppColors.lightGreen.withValues(alpha: 0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.carbbeanGreen.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.account_balance_wallet_rounded,
            size: 50,
            color: AppColors.carbbeanGreen,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Welcome to FinanceApp',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: AppColors.cyprus,
          ),
        ),

        const SizedBox(height: 8),
        Text(
          'Let\'s set up your profile to get started\nwith managing your finances',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: AppColors.cyprus.withValues(alpha: 0.7),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: _viewModel.nameController,
        style: const TextStyle(
          color: AppColors.cyprus,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Enter your full name',
          hintStyle: TextStyle(
            color: AppColors.cyprus.withValues(alpha: 0.5),
            fontSize: 16,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.carbbeanGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.person_outline,
              color: AppColors.carbbeanGreen,
              size: 20,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.carbbeanGreen,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your name';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildIncomeField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: _viewModel.moneyController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          color: AppColors.cyprus,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Enter your monthly income',
          hintStyle: TextStyle(
            color: AppColors.cyprus.withValues(alpha: 0.5),
            fontSize: 16,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.carbbeanGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.attach_money,
              color: AppColors.carbbeanGreen,
              size: 20,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.carbbeanGreen,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your monthly income';
          }
          return null;
        },
      ),
    );
  }

  // Widget _buildCountryField(BuildContext context) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withValues(alpha:0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, 5),
  //         ),
  //       ],
  //     ),
  //     child: TextFormField(
  //       controller: _viewModel.countryController,
  //       readOnly: true,
  //       onTap: () => _showCountryPicker(context),
  //       style: const TextStyle(
  //         color: AppColors.cyprus,
  //         fontSize: 16,
  //         fontWeight: FontWeight.w500,
  //       ),
  //       decoration: InputDecoration(
  //         hintText: 'Select your country',
  //         hintStyle: TextStyle(
  //           color: AppColors.cyprus.withValues(alpha:0.5),
  //           fontSize: 16,
  //         ),
  //         prefixIcon: Container(
  //           margin: const EdgeInsets.all(12),
  //           decoration: BoxDecoration(
  //             color: AppColors.carbbeanGreen.withValues(alpha:0.1),
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: const Icon(
  //             Icons.public,
  //             color: AppColors.carbbeanGreen,
  //             size: 20,
  //           ),
  //         ),
  //         suffixIcon: const Icon(
  //           Icons.keyboard_arrow_down,
  //           color: AppColors.carbbeanGreen,
  //         ),
  //         filled: true,
  //         fillColor: Colors.white,
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(16),
  //           borderSide: BorderSide.none,
  //         ),
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(16),
  //           borderSide: BorderSide.none,
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(16),
  //           borderSide: const BorderSide(
  //             color: AppColors.carbbeanGreen,
  //             width: 2,
  //           ),
  //         ),
  //         contentPadding: const EdgeInsets.symmetric(
  //           horizontal: 16,
  //           vertical: 16,
  //         ),
  //       ),
  //       validator: (value) {
  //         if (value == null || value.isEmpty) {
  //           return 'Please select your country';
  //         }
  //         return null;
  //       },
  //     ),
  //   );
  // }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.carbbeanGreen, AppColors.lightBlue],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.carbbeanGreen.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _viewModel.setupProfile(context);
          }
        },
        child: const Text(
          'Complete Profile Setup',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // void _showCountryPicker(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) => Container(
  //       height: MediaQuery.of(context).size.height * 0.7,
  //       decoration: const BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //       ),
  //       child: Column(
  //         children: [
  //           // Handle bar
  //           Container(
  //             margin: const EdgeInsets.only(top: 12),
  //             width: 40,
  //             height: 4,
  //             decoration: BoxDecoration(
  //               color: Colors.grey[300],
  //               borderRadius: BorderRadius.circular(2),
  //             ),
  //           ),
  //           // Header
  //           Padding(
  //             padding: const EdgeInsets.all(20),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 const Text(
  //                   'Select Country',
  //                   style: TextStyle(
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.bold,
  //                     color: AppColors.cyprus,
  //                   ),
  //                 ),
  //                 IconButton(
  //                   onPressed: () => Navigator.pop(context),
  //                   icon: const Icon(Icons.close),
  //                   color: AppColors.cyprus,
  //                 ),
  //               ],
  //             ),
  //           ),
  //           // Countries list
  //           Expanded(
  //             child: ListView.builder(
  //               itemCount: _viewModel.countries.length,
  //               itemBuilder: (context, index) {
  //                 final country = _viewModel.countries[index];
  //                 return ListTile(
  //                   leading: Container(
  //                     width: 40,
  //                     height: 40,
  //                     decoration: BoxDecoration(
  //                       color: AppColors.lightGreen,
  //                       borderRadius: BorderRadius.circular(20),
  //                     ),
  //                     child: Center(
  //                       child: Text(
  //                         country['code']!,
  //                         style: const TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                           color: AppColors.cyprus,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   title: Text(
  //                     country['name']!,
  //                     style: const TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.w500,
  //                       color: AppColors.cyprus,
  //                     ),
  //                   ),
  //                   onTap: () {
  //                     setState(() {
  //                       _viewModel.countryController.text = country['name']!;
  //                       _viewModel.selectedCountryCode = country['code']!;
  //                     });
  //                     Navigator.pop(context);
  //                   },
  //                 );
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
