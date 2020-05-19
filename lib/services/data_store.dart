import 'package:g2hv1/common_functions.dart';
import 'package:json_string/json_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> readUserPref({key}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.get(key) ?? 0;
    return value.toString();
  } catch (e) {
    showAlertDialog(
      error: e,
      errorDetails:
          'Looks like application is unable to read from device preferences store!',
    );
  }
  return '';
}

Future<void> saveUserPref({key, value}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  } catch (e) {
    showAlertDialog(
      error: e,
      errorDetails:
          'Looks like application is unable to write to device preferences store!',
    );
  }
}

Future<void> clearUserPref() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  } catch (e) {
    showAlertDialog(
      error: e,
      errorDetails:
          'Looks like application is unable to clear the device preferences store!',
    );
  }
}
