import 'package:my_project/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', user.username);
    prefs.setString('email', user.email);
    prefs.setString('nickname', user.nickname);
    prefs.setString('token', user.token);
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username');
    final String? email = prefs.getString('email');
    final String? nickname = prefs.getString('nickname');
    final String? token = prefs.getString('token');

    if (username != null && email != null && nickname != null && token != null){
      // ignore: lines_longer_than_80_chars
      return User(username: username, email: email, nickname: nickname, token: token);
    }
    return null;
  }
}
