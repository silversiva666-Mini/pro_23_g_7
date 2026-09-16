import 'package:shared_preferences/shared_preferences.dart';

class StorageService {

  Future<void> saveString(String key, String value) async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    return prefs.getString(key);
  }


  Future<void> saveInt(String key, int value) async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    return prefs.getInt(key);
  }


  Future<void> saveBool(String key, bool value) async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    return prefs.getBool(key);
  }


  Future<void> remove(String key) async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.remove(key);
  }


  Future<void> saveToken(String token) async {
    await saveString('token', token);
  }

  Future<String?> getToken() async {
    return await getString('token');
  }

  Future<void> removeToken() async {
    await remove('token');
  }


  Future<void> logout() async {
    await removeToken();
  }


  Future<void> clear() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.clear();
  }
}