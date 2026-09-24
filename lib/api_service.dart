import 'dart:convert';

import 'package:http/http.dart' as http;

import 'app_config.dart';

/// Semua pemanggilan ke API Laravel dikumpulkan di sini.
class ApiService {
  ApiService._();

  static Map<String, String> _headers([String? token]) => {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  static Map<String, dynamic> _decode(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 400 || body['status'] == false) {
      throw Exception(body['message'] ?? 'Permintaan gagal diproses.');
    }
    return body;
  }

  /// GET /api/news atau /api/gallery
  static Future<List<Map<String, dynamic>>> fetchItems(String endpoint) async {
    final response = await http.get(
      Uri.parse('$apiBaseUrl/$endpoint'),
      headers: _headers(),
    );
    final body = _decode(response);
    return (body['data'] as List<dynamic>).cast<Map<String, dynamic>>();
  }

  /// POST /api/login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/login'),
      headers: _headers(),
      body: {'email': email, 'password': password},
    );
    return _decode(response);
  }

  /// POST /api/contact  (subject, name, email, message)
  static Future<void> sendMessage({
    required String subject,
    required String name,
    required String email,
    required String message,
  }) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/contact'),
      headers: _headers(),
      body: {
        'subject': subject,
        'name': name,
        'email': email,
        'message': message,
      },
    );
    _decode(response);
  }

  /// GET /api/admin/dashboard
  static Future<Map<String, dynamic>> dashboard(String? token) async {
    final response = await http.get(
      Uri.parse('$apiBaseUrl/admin/dashboard'),
      headers: _headers(token),
    );
    return _decode(response)['data'] as Map<String, dynamic>;
  }
}