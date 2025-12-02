import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController feedbackCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("feedback".tr)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("feedbackTitle".tr, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            TextField(
              controller: feedbackCtrl,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: "feedbackLabel".tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (feedbackCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("feedbackHint".tr)));
                  return;
                }

                // TODO: Send feedback to Firestore / API / Email

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("feedbackSuccess".tr)));

                feedbackCtrl.clear();
              },
              child: Text("feedbackSubmit".tr),
            ),
          ],
        ),
      ),
    );
  }
}
