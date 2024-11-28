import 'package:my_project/services/user_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUserStorage implements UserStorage {
  @override
  Future<bool> saveUserData(String username, String password, String nickname) 
  async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('nickname', nickname);
    prefs.setString('username', username);
    prefs.setString('password', password);
    return true;
  }

  @override
  Future<Map<String, String>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? nickname = prefs.getString('nickname');
    final String? username = prefs.getString('username');
    final String? password = prefs.getString('password');
    
    // Перевірка на наявність значень
    if (username != null && password != null && nickname != null) {
      return {'username': username, 'password': password, 'nickname': nickname};
    }
    return null;
  }

  @override
  Future<bool> validateLogin(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    // ignore: unused_local_variable
    final String? storedNickname = prefs.getString('nickname');
    final String? storedUsername = prefs.getString('username');
    final String? storedPassword = prefs.getString('password');
    
    return storedUsername == username && storedPassword == password;
  }
}
