import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../providers/aiProvider/ai_provider.dart';
import '../widgets/preview_card_button.dart';
import '../widgets/preview_card_widget.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AiProvider>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: 24,
      ),
      child: provider.isLoading
          ? Center(
              child: SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            )
          : Column(
              children: [
                PreviewCardWidget(parsedDataEx: provider.parsedDataEx),
                const SizedBox(height: 24),
                PreviewCardButton(
                  editTransactionButton: () {
                    HapticFeedback.selectionClick();
                    provider.editTransaction();
                  },
                  deleteTransactionButton: () {
                    HapticFeedback.lightImpact();
                    provider.deleteTransaction();
                  },
                  saveTransactionButton: () {
                    HapticFeedback.mediumImpact();
                    provider.saveTransaction(context);
                  },
                ),
              ],
            ),
    );
  }
}
