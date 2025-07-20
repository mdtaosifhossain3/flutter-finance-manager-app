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

class EndSessionPopup extends StatelessWidget {
  final VoidCallback? onEndSession;
  final VoidCallback? onCancel;

  const EndSessionPopup({Key? key, this.onEndSession, this.onCancel})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
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
                color: AppColors.cyprus,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Are you sure you want to log out?',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.cyprus,
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
                      backgroundColor: AppColors.carbbeanGreen,
                      foregroundColor: Colors.white,
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
                      backgroundColor: AppColors.lightGreen,
                      foregroundColor: AppColors.cyprus,
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidB,
      appBar: AppBar(
        title: const Text('End Session Example'),
        backgroundColor: AppColors.cyprus,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final result = await EndSessionPopup.show(context);
            if (result == true) {
              // User confirmed to end session
              print('Session ended');
              // Add your logout logic here
            } else {
              // User cancelled
              print('Session continues');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.carbbeanGreen,
            foregroundColor: Colors.white,
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
