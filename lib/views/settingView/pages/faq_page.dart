import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqList = [
      {"q": "q1".tr, "a": "a1".tr},
      {"q": "q2".tr, "a": "a2".tr},
      {"q": "q3".tr, "a": "a3".tr},
      {"q": "q5".tr, "a": "a5".tr},
      {"q": "q6".tr, "a": "a6".tr},
      {"q": "q7".tr, "a": "a7".tr},
      {"q": "q8".tr, "a": "a8".tr},
      {"q": "q9".tr, "a": "a9".tr},
    ];

    return Scaffold(
      appBar: AppBar(title: Text("faq".tr)),
      body: ListView(
        children: faqList.map((item) {
          return ExpansionTile(
            title: Text(item["q"]!),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(item["a"]!),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
