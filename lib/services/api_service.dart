import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ApiService {
  // For Android Emulator use 'http://10.0.2.2:3000'
  // For iOS Simulator use 'http://localhost:3000'
  // For Real Device use your PC's IP 'http://192.168.x.x:3000'
  static const String baseUrl = 'http://10.0.2.2:3000'; 

  /// Call the AI PDF Summarization Endpoint
  Future<String> summarizePdf(File pdfFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/api/summarize'));
      
      // Add the file
      request.files.add(await http.MultipartFile.fromPath('pdf', pdfFile.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['summary'] ?? "No summary returned.";
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("API Error: $e");
      // Fallback for demo purposes if server isn't running
      await Future.delayed(const Duration(seconds: 2));
      return "⚠️ Server not connected.\n\nSimulated Summary: This document appears to be a financial report detailing Q3 growth. It highlights a 20% increase in user acquisition.";
    }
  }

  /// Call the AI Translation Endpoint
  Future<String> translateText(String text, String targetLanguage) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/translate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'text': text,
          'targetLanguage': targetLanguage,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['translatedText'] ?? "Translation failed.";
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("API Error: $e");
      await Future.delayed(const Duration(seconds: 1));
      return "⚠️ Server not connected.\n\nSimulated Translation ($targetLanguage): $text";
    }
  }
}