import 'package:shared_preferences/shared_preferences.dart';

class HeaderInterceptor {
  static Future<Map<String, String>> getHeaders({String contentType = 'text/xml; charset=utf-8'}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final username = prefs.getString('username') ?? '';
    final entityId = prefs.getString('entityId') ?? '';

    return {
      'Content-Type': contentType,
      'Authorization': 'Bearer $token',
      'username': username,
      'entityId': entityId,
    };
  }
}
