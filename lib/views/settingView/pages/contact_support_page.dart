import 'package:flutter/material.dart';

class ContactSupportPage extends StatelessWidget {
  const ContactSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contact Support")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Need help? We're here for you!",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 25),

            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text("Email Support"),
              onTap: () {},
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.message_outlined),
              title: const Text("Messenger Support"),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
