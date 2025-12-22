import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/models/givenTakenModel/contact_lend_model.dart';
import 'package:finance_manager_app/providers/givenTakenProvider/given_taken_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class AddEditPersonView extends StatefulWidget {
  final ContactLend? contact;

  const AddEditPersonView({super.key, this.contact});

  @override
  State<AddEditPersonView> createState() => _AddEditPersonViewState();
}

class _AddEditPersonViewState extends State<AddEditPersonView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _amountController = TextEditingController();

  String _selectedType = 'given'; // 'given' or 'taken'
  bool _isEdit = false;
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _isEdit = true;
      _nameController.text = widget.contact!.name;
      _phoneController.text = widget.contact!.phone ?? '';
      _addressController.text = widget.contact!.address ?? '';
      _imagePath = widget.contact!.imagePath;
      // Initial amount is only for new contacts in this simplified UI
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imagePath = image.path;
        });
      }
    } catch (e) {
      Get.snackbar('error'.tr, 'Failed to pick image: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: _isEdit ? 'edit_person'.tr : 'add_person'.tr,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.1),
                          backgroundImage: _imagePath != null
                              ? FileImage(File(_imagePath!))
                              : null,
                          child: _imagePath == null
                              ? Icon(
                                  Icons.person_add_alt_1_rounded,
                                  size: 40,
                                  color: Theme.of(context).primaryColor,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField(
                  label: 'person_name'.tr,
                  controller: _nameController,
                  hint: 'enter_name'.tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'name_required'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'phone_number'.tr,
                  controller: _phoneController,
                  hint: 'enter_phone_number'.tr,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'address'.tr,
                  controller: _addressController,
                  hint: 'enter_address'.tr,
                  maxLines: 2,
                ),
                if (!_isEdit) ...[
                  const SizedBox(height: 20),
                  Text(
                    'initial_amount'.tr,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTypeButton(
                          label: 'given'.tr,
                          type: 'given',
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTypeButton(
                          label: 'taken'.tr,
                          type: 'taken',
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: '0',
                      prefixText: '৳ ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ],
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _savePerson,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _isEdit ? 'update'.tr : 'save'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.5)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeButton({
    required String label,
    required String type,
    required Color color,
  }) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _savePerson() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<GivenTakenProvider>();
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();
    final initialAmount = int.tryParse(_amountController.text) ?? 0;

    try {
      if (_isEdit) {
        await provider.updateContact(
          id: widget.contact!.id!,
          name: name,
          phone: phone,
          address: address,
          imagePath: _imagePath,
        );
      } else {
        await provider.createContact(
          name: name,
          phone: phone,
          address: address,
          imagePath: _imagePath,
          initialAmount: initialAmount,
          type: _selectedType,
        );
      }
      Get.back();
      Get.snackbar(
        'success'.tr,
        _isEdit ? 'person_updated'.tr : 'person_added'.tr,
      );
    } catch (e) {
      Get.snackbar('error'.tr, '${'failed_to_save_contact'.tr}: $e');
    }
  }
}
