import 'package:json_string/json_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> readUserPref({key}) async {
  final prefs = await SharedPreferences.getInstance();
  final value = prefs.get(key) ?? 0;
  return value.toString();
}

Future<void> saveUserPref({key, value}) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}
