import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:finance_manager_app/config/db/local/category_db/add_transaction_db_helper.dart';
import 'package:finance_manager_app/config/db/local/receipt_db/receipt_db_helper.dart';
import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/data/category/category_item_data.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/models/categoryModel/category_item_model.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/models/receiptModel/receipt_model.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:finance_manager_app/providers/reportProvider/report_provider.dart';
import 'package:finance_manager_app/services/receipt/receipt_ocr_service.dart';
import 'package:finance_manager_app/services/receipt/receipt_parser.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:finance_manager_app/views/receiptView/receipt_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

String _taka(int v) => '৳${HelperFunctions.convertToBanglaDigits('$v')}';

const _paymentMethods = [
  'cash',
  'bkash',
  'nagad',
  'rocket',
  'upay',
  'debitCard',
  'creditCard',
  'bankTransfer',
  'mobileWallet',
  'check',
];

/// Photo of a receipt → OCR → the user checks the values → the expense and
/// the photo are saved together.
class ReceiptScanView extends StatefulWidget {
  /// Opens the camera or gallery straight away.
  final ImageSource? source;

  const ReceiptScanView({super.key, this.source});

  @override
  State<ReceiptScanView> createState() => _ReceiptScanViewState();
}

class _ReceiptScanViewState extends State<ReceiptScanView> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _amount = TextEditingController();
  final _note = TextEditingController();

  File? _image;
  String? _hash;
  ParsedReceipt? _result;
  bool _reading = false;
  bool _saving = false;

  DateTime _date = DateTime.now();
  String _categoryKey = 'miscellaneous_expense';
  String _payment = 'cash';

  List<DuplicateCandidate> _existing = [];
  DuplicateMatch? _duplicate;

  @override
  void initState() {
    super.initState();
    _amount.addListener(_checkDuplicate);
    _loadExisting();
    if (widget.source != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _pick(widget.source!),
      );
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  /// Saved receipts and expenses, for the duplicate warning.
  Future<void> _loadExisting() async {
    final list = <DuplicateCandidate>[];
    try {
      for (final r in await ReceiptDbHelper.getInstance.getAll()) {
        list.add(
          DuplicateCandidate(
            transactionId: r.transactionId,
            imageHash: r.imageHash,
            title: r.merchant ?? '',
            amount: r.amount,
            date: r.date,
          ),
        );
      }
      for (final row
          in await AddTransactionDbHelper.getInstance.getAllNotes()) {
        final tx = TransactionModel.fromMap(row);
        if (tx.type != TransactionType.expense) continue;
        list.add(
          DuplicateCandidate(
            transactionId: tx.id,
            title: tx.title,
            amount: tx.amount,
            date: tx.date,
          ),
        );
      }
    } catch (_) {
      // No duplicate warning is better than blocking the scan.
    }
    if (!mounted) return;
    _existing = list;
    _checkDuplicate();
  }

  void _checkDuplicate() {
    if (_image == null) return;
    final match = ReceiptDuplicateChecker.find(
      imageHash: _hash,
      amount: int.tryParse(_amount.text.trim()),
      date: _date,
      merchant: _title.text.trim().isEmpty ? null : _title.text.trim(),
      existing: _existing,
    );
    if (match?.transactionId != _duplicate?.transactionId ||
        match?.samePhoto != _duplicate?.samePhoto) {
      setState(() => _duplicate = match);
    }
  }

  Future<void> _pick(ImageSource source) async {
    final XFile? picked;
    try {
      picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 2000,
        maxHeight: 2000,
      );
    } catch (_) {
      Get.snackbar('error'.tr, 'receipt_pick_failed'.tr);
      return;
    }
    if (picked == null || !mounted) return;

    final file = File(picked.path);
    final bytes = await file.readAsBytes();
    setState(() {
      _image = file;
      _hash = sha256.convert(bytes).toString();
      _result = null;
      _reading = true;
    });

    final result = await ReceiptOcrService.readOnDevice(file);
    if (!mounted) return;
    _apply(result);
    setState(() => _reading = false);
  }

  /// Fills the form with what was read. The user can change everything.
  void _apply(ParsedReceipt r) {
    _result = r;
    _title.text = r.merchant ?? '';
    _amount.text = r.total?.toString() ?? '';
    final d = r.date;
    if (d != null) {
      final now = DateTime.now();
      // The parser uses 12:00 when no time is printed; use the time now.
      _date = (d.hour == 12 && d.minute == 0)
          ? DateTime(d.year, d.month, d.day, now.hour, now.minute)
          : d;
    } else {
      _date = DateTime.now();
    }
    _categoryKey = r.categoryKey;
    _checkDuplicate();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    setState(
      () => _date = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _date.hour,
        _date.minute,
      ),
    );
    _checkDuplicate();
  }

  CategoryItemModel get _category => categoryItems.firstWhere(
    (c) => c.key == _categoryKey,
    orElse: () => categoryItems.last,
  );

  Future<void> _save() async {
    final image = _image;
    if (image == null || _saving) return;
    if (!_formKey.currentState!.validate()) return;

    final dup = _duplicate;
    if (dup != null) {
      final ok = await Get.dialog<bool>(
        AlertDialog(
          title: Text('receipt_duplicate_title'.tr),
          content: Text(_duplicateText(dup)),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text('receipt_cancel'.tr),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: Text('receipt_save_anyway'.tr),
            ),
          ],
        ),
      );
      if (ok != true || !mounted) return;
    }

    setState(() => _saving = true);
    final txProvider = context.read<AddExpenseProvider>();
    final reportProvider = context.read<ReportProvider>();
    final txDb = AddTransactionDbHelper.getInstance;
    final receiptDb = ReceiptDbHelper.getInstance;
    final cat = _category;
    final amount = int.parse(_amount.text.trim());
    final title = _title.text.trim().isEmpty ? cat.key.tr : _title.text.trim();

    int? txId;
    File? copy;
    try {
      txId = await txDb.insertItem(
        TransactionModel(
          type: TransactionType.expense,
          date: _date,
          title: title,
          amount: amount,
          notes: _note.text.trim(),
          paymentMethod: _payment,
          icon: cat.icon,
          iconBgColor: cat.color.toARGB32(),
          categoryKey: cat.key,
        ),
      );
      final dir = await receiptDb.imageDir();
      copy = await image.copy(
        p.join(
          dir.path,
          '${txId}_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      );
      await receiptDb.insert(
        ReceiptModel(
          transactionId: txId,
          imagePath: copy.path,
          imageHash: _hash!,
          merchant: _title.text.trim().isEmpty ? null : _title.text.trim(),
          amount: amount,
          date: _date,
          rawText: _result?.rawText ?? '',
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      // Keep the two together: no expense without its receipt.
      if (txId != null) await txDb.deleteItem(txId);
      if (copy != null && await copy.exists()) await copy.delete();
      if (mounted) setState(() => _saving = false);
      Get.snackbar('error'.tr, 'something_went_wrong'.tr);
      return;
    }

    await txProvider.getTransactionsForMonth(txProvider.currentMonth);
    reportProvider.warningshow();
    if (!mounted) return;
    Navigator.of(context).pop();
    Get.snackbar('receipt_scan'.tr, 'receipt_saved'.tr);
  }

  String _duplicateText(DuplicateMatch d) =>
      (d.samePhoto
              ? 'receipt_duplicate_same_photo'
              : 'receipt_duplicate_similar')
          .trParams({
            'title': d.title.isEmpty ? '—' : d.title,
            'amount': _taka(d.amount),
            'date': HelperFunctions.getFormattedDate(d.date),
          });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'receipt_scan'.tr,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      bottomNavigationBar: _image == null || _reading
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check),
                    label: Text('receipt_save'.tr),
                  ),
                ),
              ),
            ),
      body: _image == null ? _pickerBody() : _reviewBody(),
    );
  }

  Widget _pickerBody() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 24),
        const Icon(
          Icons.receipt_long_rounded,
          size: 72,
          color: AppColors.primaryBlue,
        ),
        const SizedBox(height: 16),
        Text(
          'receipt_intro'.tr,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => _pick(ImageSource.camera),
            icon: const Icon(Icons.photo_camera_outlined),
            label: Text('receipt_take_photo'.tr),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 52,
          child: OutlinedButton.icon(
            onPressed: () => _pick(ImageSource.gallery),
            icon: const Icon(Icons.photo_library_outlined),
            label: Text('receipt_from_gallery'.tr),
          ),
        ),
      ],
    );
  }

  Widget _reviewBody() {
    final result = _result;
    final textTheme = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _imagePreview(),
          const SizedBox(height: 16),
          if (_reading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 12),
                  Text('receipt_reading'.tr),
                ],
              ),
            )
          else ...[
            if (_duplicate case final d?) ...[
              _banner(
                icon: Icons.copy_all_rounded,
                color: AppColors.error,
                text: _duplicateText(d),
              ),
              const SizedBox(height: 12),
            ],
            if (result != null && result.weak)
              _banner(
                icon: Icons.warning_amber_rounded,
                color: AppColors.warning,
                text: 'receipt_weak'.tr,
              )
            else
              _banner(
                icon: Icons.fact_check_outlined,
                color: AppColors.primaryBlue,
                text: 'receipt_check_values'.tr,
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _title,
              textCapitalization: TextCapitalization.words,
              onChanged: (_) => _checkDuplicate(),
              decoration: _decoration(
                'receipt_shop'.tr,
                Icons.storefront_outlined,
                missing: result?.merchant == null,
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _amount,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: _decoration(
                'receipt_amount'.tr,
                Icons.payments_outlined,
                missing: result?.total == null,
              ),
              validator: (v) {
                final n = int.tryParse(v?.trim() ?? '');
                return n == null || n <= 0 ? 'enterAmount'.tr : null;
              },
            ),
            const SizedBox(height: 14),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(12),
              child: InputDecorator(
                decoration: _decoration(
                  'receipt_date'.tr,
                  Icons.calendar_today_outlined,
                  missing: result?.date == null,
                ),
                child: Text(HelperFunctions.getFormattedDate(_date)),
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              // Rebuilt when a new read suggests another category.
              key: ValueKey(_categoryKey),
              initialValue: _categoryKey,
              isExpanded: true,
              decoration: _decoration(
                'receipt_suggested_category'.tr,
                Icons.category_outlined,
              ),
              items: [
                for (final c in categoryItems)
                  DropdownMenuItem(value: c.key, child: Text(c.key.tr)),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _categoryKey = v);
              },
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: _payment,
              isExpanded: true,
              decoration: _decoration(
                'receipt_payment'.tr,
                Icons.account_balance_wallet_outlined,
              ),
              items: [
                for (final m in _paymentMethods)
                  DropdownMenuItem(value: m, child: Text(m.tr)),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _payment = v);
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _note,
              maxLines: 2,
              decoration: _decoration('note'.tr, Icons.notes_outlined),
            ),
            if (result != null && result.rawText.isNotEmpty) ...[
              const SizedBox(height: 8),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text('receipt_raw_text'.tr, style: textTheme.bodyMedium),
                children: [
                  SelectableText(result.rawText, style: textTheme.bodySmall),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _imagePreview() {
    final image = _image!;
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Get.to(() => ReceiptImageView(path: image.path)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              image,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: 8,
          bottom: 8,
          child: Row(
            children: [
              _chipButton(
                Icons.photo_camera_outlined,
                'receipt_retake'.tr,
                () => _pick(ImageSource.camera),
              ),
              const SizedBox(width: 8),
              _chipButton(
                Icons.photo_library_outlined,
                'receipt_gallery'.tr,
                () => _pick(ImageSource.gallery),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chipButton(IconData icon, String label, VoidCallback onTap) {
    return Material(
      color: Colors.black.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: _reading || _saving ? null : onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _banner({
    required IconData icon,
    required Color color,
    required String text,
    Widget? action,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(text, style: const TextStyle(fontSize: 13)),
                ),
              ),
            ],
          ),
          if (action != null)
            Align(alignment: Alignment.centerRight, child: action),
        ],
      ),
    );
  }

  InputDecoration _decoration(
    String label,
    IconData icon, {
    bool missing = false,
  }) {
    final show = missing && _result != null;
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      helperText: show ? 'receipt_not_found'.tr : null,
      helperStyle: const TextStyle(color: AppColors.warning),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: show
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.warning),
            )
          : null,
    );
  }
}
