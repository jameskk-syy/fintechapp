import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:saccoapp/data/datasources/api_domain.dart';
import 'package:saccoapp/data/responses/login_response.dart';

class LoginRepository {
  static Future<LoginResponse> login(String username, String password) async {
    try {
      var url = Uri.parse(ApiConstants.auth);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      print(jsonDecode(response.body)); // Good for debugging

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('wrong_credentials');
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (error) {
      print("error");
      throw Exception('Login failed: $error');
    }
  }
}
