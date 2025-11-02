import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  final String apiKey = 'YOUR_OPENAI_API_KEY'; // or Gemini key
  final String endpoint = 'https://api.openai.com/v1/chat/completions';

  Future<Map<String, dynamic>?> analyzeTransaction(String text) async {
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        "model": "gpt-4o-mini", // lightweight + cheap
        "messages": [
          {
            "role": "system",
            "content":
            "You are a finance assistant. Extract transaction details from user text and respond in JSON format with fields: title, type (income/expense), amount, category, paymentMethod, date, and notes."
          },
          {
            "role": "user",
            "content": text,
          }
        ],
        "temperature": 0.3,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final message = data['choices'][0]['message']['content'];
      try {
        return jsonDecode(message); // message should be JSON
      } catch (e) {
        return null;
      }
    } else {
      print('AI Error: ${response.body}');
      return null;
    }
  }
}
