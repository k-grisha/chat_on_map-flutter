import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String CONFIG_MY_UUID = "my_config";

  Future<String> getUuid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(CONFIG_MY_UUID);
  }

  Future<bool> setUuid(String uuid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(CONFIG_MY_UUID, uuid);
  }
}
