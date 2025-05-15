import 'package:shared_preferences/shared_preferences.dart';

class UserData{
  static Future<Map<String, String>> getUserData() async {
  final prefs = await SharedPreferences.getInstance();
  return {
    'token': prefs.getString('token') ?? '',
    'username': prefs.getString('username') ?? '',
    'email': prefs.getString('email') ?? '',
    'name': prefs.getString('name') ?? '',
    'nationalId': prefs.getString('nationalId') ?? 'N/A',
    'phoneNumber': prefs.getString('phoneNumber') ?? 'N/A',
    'entityId': prefs.getString('entityId') ?? '',
  };
}

}