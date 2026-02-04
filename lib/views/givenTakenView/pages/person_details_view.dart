import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/config/routes/routes_name.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/models/givenTakenModel/contact_lend_model.dart';
import 'package:finance_manager_app/models/givenTakenModel/lend_transaction_model.dart';
import 'package:finance_manager_app/providers/givenTakenProvider/given_taken_provider.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:finance_manager_app/services/given_taken_report_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:finance_manager_app/utils/custom_loader.dart';

class PersonDetailsView extends StatefulWidget {
  final ContactLend contact;

  const PersonDetailsView({super.key, required this.contact});

  @override
  State<PersonDetailsView> createState() => _PersonDetailsViewState();
}

class _PersonDetailsViewState extends State<PersonDetailsView> {
  List<LendTransaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    try {
      final provider = context.read<GivenTakenProvider>();
      _transactions = await provider.getTransactionsByContact(
        widget.contact.id!,
      );
    } catch (e) {
      Get.snackbar('error'.tr, '${'failed_to_load_transactions'.tr}: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GivenTakenProvider>(
      builder: (context, provider, child) {
        final contact = provider.contacts.firstWhere(
          (c) => c.id == widget.contact.id,
          orElse: () => widget.contact,
        );

        return Scaffold(
          appBar: customAppBar(
            title: contact.name,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
            actions: [
              IconButton(
                onPressed: () => GivenTakenReportService.generateAndHandleImage(
                  contact: contact,
                  transactions: _transactions,
                  isShare: false,
                ),
                icon: const Icon(Icons.download_outlined),
                tooltip: 'download'.tr,
              ),
              IconButton(
                onPressed: () => GivenTakenReportService.generateAndHandleImage(
                  contact: contact,
                  transactions: _transactions,
                  isShare: true,
                ),
                icon: const Icon(Icons.share_outlined),
                tooltip: 'share'.tr,
              ),
              IconButton(
                onPressed: () => _confirmDelete(contact),
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildSummaryCard(contact),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'transactions_history'.tr,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${_transactions.length} ${'records'.tr}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _isLoading
                      ? const Center(child: CustomLoader())
                      : _transactions.isEmpty
                      ? _buildEmptyState()
                      : _buildTransactionsList(),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Get.toNamed(
                RoutesName.addEditTransactionView,
                arguments: {'contactId': contact.id, 'transaction': null},
              )?.then((_) => _loadTransactions());
            },
            label: Text(
              'add_record'.tr,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(ContactLend contact) {
    final balance = contact.balance;
    final isPositive = balance >= 0;
    final statusColor = isPositive ? AppColors.success : AppColors.error;

    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Section: Contact Info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withValues(alpha: 0.1),
                  backgroundImage: contact.imagePath != null
                      ? FileImage(File(contact.imagePath!))
                      : null,
                  child: contact.imagePath == null
                      ? Text(
                          contact.name.isNotEmpty
                              ? contact.name[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (contact.phone != null &&
                              contact.phone!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.phone_outlined,
                                    size: 16,
                                    color: AppColors.textSecondary.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                                  Text(
                                    HelperFunctions.convertToBanglaDigits(
                                      contact.phone!,
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(width: 5),
                          if (contact.address != null &&
                              contact.address!.isNotEmpty) ...[
                            // const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 16,
                                    color: AppColors.textSecondary.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                                  Text(
                                    contact.address!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Middle Section: Balance
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              children: [
                Text(
                  'net_balance'.tr,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '৳${HelperFunctions.convertToBanglaDigits(contact.balance.abs().toString())}',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isPositive ? 'you_will_get'.tr : 'you_need_to_pay'.tr,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Section: Totals & Action
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildSummaryItem(
                      label: 'get'.tr,
                      amount: contact.totalGiven,
                      icon: Icons.arrow_upward_rounded,
                      color: AppColors.success,
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                    _buildSummaryItem(
                      label: 'pay'.tr,
                      amount: contact.totalTaken,
                      icon: Icons.arrow_downward_rounded,
                      color: AppColors.error,
                    ),
                  ],
                ),
                if (balance != 0) ...[
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _settleUp(contact),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'settle_up'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required int amount,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '৳${HelperFunctions.convertToBanglaDigits(amount.toString())}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final tx = _transactions[index];
        return _buildTransactionTile(tx);
      },
    );
  }

  Widget _buildTransactionTile(LendTransaction tx) {
    final isGiven = tx.type == 'given';
    final color = isGiven ? AppColors.success : AppColors.error;

    return InkWell(
      onTap: () {
        Get.toNamed(
          RoutesName.addEditTransactionView,
          arguments: {'contactId': widget.contact.id, 'transaction': tx},
        )?.then((_) => _loadTransactions());
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isGiven ? Icons.arrow_upward : Icons.arrow_downward,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isGiven ? 'get'.tr : 'pay'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    HelperFunctions.getFormattedDate(DateTime.parse(tx.date)),
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '৳${HelperFunctions.convertToBanglaDigits(tx.amount.toString())}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'no_transactions_yet'.tr,
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  void _settleUp(ContactLend contact) async {
    final balance = contact.balance;
    if (balance == 0) return;

    Get.dialog(
      AlertDialog(
        title: Text('settle_up'.tr),
        content: Text('confirm_settle_up'.tr),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          TextButton(
            onPressed: () async {
              Get.back(); // Close dialog
              final type = balance > 0 ? 'taken' : 'given';
              final amount = balance.abs();

              try {
                await context.read<GivenTakenProvider>().addTransaction(
                  contactId: contact.id!,
                  type: type,
                  amount: amount,
                  date: DateTime.now().toIso8601String(),
                  note: 'settle_up'.tr,
                );
                _loadTransactions();
                Get.snackbar('success'.tr, 'settled_successfully'.tr);
              } catch (e) {
                Get.snackbar('error'.tr, '${'failed_to_settle_up'.tr}: $e');
              }
            },
            child: Text(
              'settle_up'.tr,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(ContactLend contact) {
    Get.dialog(
      AlertDialog(
        title: Text('delete_person'.tr),
        content: Text('confirm_delete_person'.tr),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          TextButton(
            onPressed: () async {
              await context.read<GivenTakenProvider>().deleteContact(
                contact.id!,
              );
              Get.back(); // Close dialog
              Get.back(); // Go back to list
              Get.snackbar('success'.tr, 'person_deleted'.tr);
            },
            child: Text(
              'delete'.tr,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
