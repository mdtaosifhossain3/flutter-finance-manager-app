import 'package:finance_manager_app/config/myColors/my_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class EndSessionPopup extends StatelessWidget {
  final VoidCallback? onEndSession;
  final VoidCallback? onCancel;

  const EndSessionPopup({super.key, this.onEndSession, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: MyColors.popupBg,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: MyColors.whiteColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'End Session',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: MyColors.cyprus,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Are you sure you want to log out?',
              style: TextStyle(
                fontSize: 16,
                color: MyColors.cyprus,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Column(
              children: [
                // End Session Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        onEndSession ?? () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.carbbeanGreen,
                      foregroundColor: MyColors.whiteColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'Yes, End Session',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        onCancel ?? () => Navigator.of(context).pop(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.lightGreen,
                      foregroundColor: MyColors.cyprus,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Static method to show the dialog
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => const EndSessionPopup(),
    );
  }
}

// Example usage in your main widget
class ExampleUsage extends StatelessWidget {
  const ExampleUsage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.voidB,
      appBar: AppBar(
        title: const Text('End Session Example'),
        backgroundColor: MyColors.cyprus,
        foregroundColor: MyColors.whiteColor,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final result = await EndSessionPopup.show(context);
            if (result == true) {
              // User confirmed to end session
              if (kDebugMode) {
                print('Session ended');
              }
              // Add your logout logic here
            } else {
              // User cancelled
              if (kDebugMode) {
                print('Session continues');
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.carbbeanGreen,
            foregroundColor: MyColors.whiteColor,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text('Show End Session Dialog'),
        ),
      ),
    );
  }
}
