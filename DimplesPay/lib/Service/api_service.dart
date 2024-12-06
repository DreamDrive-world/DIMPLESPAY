import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';


class ApiService {
  static const String baseUrl = 'http://localhost:3000';
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'success': false, 'message': 'Invalid credentials'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

}





