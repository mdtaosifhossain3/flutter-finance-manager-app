import 'dart:io';
import 'package:finance_manager_app/models/givenTakenModel/contact_lend_model.dart';
import 'package:finance_manager_app/models/givenTakenModel/lend_transaction_model.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SimpleReceiptWidget extends StatelessWidget {
  final ContactLend contact;
  final List<LendTransaction> transactions;

  const SimpleReceiptWidget({
    super.key,
    required this.contact,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    final balance = contact.balance;
    final isPay = balance >= 0;

    return Material(
      color: Colors.white,
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const SizedBox(height: 16),
            _contactInfo(),
            const Divider(height: 32),
            _transactionTable(),
            const Divider(height: 32),
            _total(balance, isPay),
            const SizedBox(height: 20),
            _footer(),
          ],
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------

  Widget _header() {
    return Center(
      child: Column(
        children: [
          Text(
            'Hishab Rakhi',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'given_taken_report'.tr,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ---------------- CONTACT INFO WITH IMAGE ----------------

  Widget _contactInfo() {
    final hasImage =
        contact.imagePath != null &&
        contact.imagePath!.isNotEmpty &&
        File(contact.imagePath!).existsSync();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Image
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade200,
            image: hasImage
                ? DecorationImage(
                    image: FileImage(File(contact.imagePath!)),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: !hasImage
              ? Center(
                  child: Text(
                    contact.name.isNotEmpty
                        ? contact.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
        ),
        const SizedBox(width: 12),

        // Contact Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contact.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (contact.phone != null && contact.phone!.isNotEmpty)
                    Row(
                      children: [
                        const Text('📞', style: TextStyle(fontSize: 13)),
                        const SizedBox(width: 4),
                        Text(
                          contact.phone!,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),

                  if (contact.address != null && contact.address!.isNotEmpty)
                    const SizedBox(width: 12),

                  if (contact.address != null && contact.address!.isNotEmpty)
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('📍', style: TextStyle(fontSize: 13)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              contact.address!,
                              style: const TextStyle(fontSize: 13),

                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- TRANSACTIONS ----------------

  Widget _transactionTable() {
    final sorted = [...transactions]..sort((a, b) => b.date.compareTo(a.date));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   'given_taken_summary'.tr,
        //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        // ),
        // const SizedBox(height: 8),
        Row(
          children: [
            Expanded(flex: 2, child: Text('date'.tr, style: _th)),
            Expanded(flex: 2, child: Text('type'.tr, style: _th)),
            Expanded(flex: 2, child: Text('amount'.tr, style: _th)),
            Expanded(flex: 3, child: Text('note'.tr, style: _th)),
          ],
        ),
        const Divider(),

        ...sorted.map(_row),
      ],
    );
  }

  static const _th = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);

  Widget _row(LendTransaction t) {
    final isGiven = t.type == 'given';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              //   intl.DateFormat('dd/MM/yyyy').format(DateTime.parse(t.date)),
              HelperFunctions.getFormattedDate(DateTime.parse(t.date)),
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              isGiven ? 'pay'.tr : 'get'.tr,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isGiven ? Colors.red : Colors.green,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '৳${HelperFunctions.convertToBanglaDigits(t.amount.toString())}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              t.note?.isNotEmpty == true ? t.note! : '-',
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- TOTAL ----------------

  Widget _total(int balance, bool isPay) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'totalAmount'.tr,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '৳${HelperFunctions.convertToBanglaDigits(balance.abs().toString())}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isPay ? Colors.red : Colors.green,
              ),
            ),
            Text(
              isPay ? 'you_need_to_pay'.tr : 'you_will_get'.tr,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------- FOOTER ----------------

  Widget _footer() {
    return Center(
      child: Text(
        'Generated on ${HelperFunctions.getFormattedDateTime(DateTime.now())}',
        style: const TextStyle(fontSize: 11, color: Colors.grey),
      ),
    );
  }
}
