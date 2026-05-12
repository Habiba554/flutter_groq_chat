import 'dart:convert';
import 'package:http/http.dart' as http;

class SendMessageRequest {
  final String apiKey = "Your_API_Key_Here";

  Future<String> send(List<Map<String, String>> messages) async {
    final response = await http.post(
      Uri.parse("https://api.groq.com/openai/v1/chat/completions"),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "llama-3.1-8b-instant",
        "messages": [
          {
            "role": "system",
            "content": "You are a helpful assistant."
          },
          ...messages
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["choices"][0]["message"]["content"] ?? "No response";
    } else {
      throw Exception("Error: ${response.body}");
    }
  }
}