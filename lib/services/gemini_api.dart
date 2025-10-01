import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class GeminiApi {
  // Replace with your active API key
  static const String _apiKey = "AIzaSyBpuSI6xMRUt_DbYyq65BRfKq2w82T7hy8";

  // Make sure this matches the exact model endpoint
  static const String _baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

  /// Sends a user message to Gemini and returns the AI's response.
  static Future<String> getResponse(String userMessage) async {
    try {
      final body = {
        "contents": [
          {
            "parts": [
              {"text": userMessage}
            ]
          }
        ]
      };

      final response = await http.post(
        Uri.parse("$_baseUrl?key=$_apiKey"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      // Debug: Print full response if needed
      // print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["candidates"] != null && data["candidates"].isNotEmpty) {
          final parts = data["candidates"][0]["content"]["parts"];
          return parts.map((p) => p["text"]).join("\n");
        } else {
          return "No response returned by API.";
        }
      } else {
        // Return status code + API message
        return "Error ${response.statusCode} | ${response.body}";
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception: $e"); // only prints in debug
      }
      return "Error: Unable to connect. Check your network.";
    }

  }
}
