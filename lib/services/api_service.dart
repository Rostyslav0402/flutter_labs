import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_project/models/movie.dart';
import 'package:my_project/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String apiUrl = 'https://your-api-url.com';  // Заміни на ваш API

  // Отримання даних користувача з API
  Future<User?> getUserData(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/user'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        // ignore: lines_longer_than_80_chars
        final Map<String, dynamic> jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        return User.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Отримання списку фільмів з API
  Future<List<Movie>> getMovies() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/movies'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        return data.map((movie) {
          return Movie.fromJson(movie as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Збереження токена користувача в SharedPreferences
  Future<void> saveUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Отримання токена користувача з SharedPreferences
  Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Видалення токена користувача з SharedPreferences
  Future<void> removeUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // Метод реєстрації користувача
  // ignore: lines_longer_than_80_chars
  Future<String> registerUser(String username, String password, String nickname) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
          'nickname': nickname,
        }),
      );

      if (response.statusCode == 200) {
        // ignore: lines_longer_than_80_chars
        final Map<String, dynamic> jsonResponse = json.decode(response.body) as Map<String, dynamic>;

        // Перевірка наявності токена в відповіді
        // ignore: lines_longer_than_80_chars
        if (jsonResponse.containsKey('token') && jsonResponse['token'] is String) {
          return jsonResponse['token'] as String;  // Повертаємо токен
        } else {
          throw Exception('Token not found or not a String in response');
        }
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Метод для валідації логіну користувача
  Future<String> validateLogin(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // ignore: lines_longer_than_80_chars
        final Map<String, dynamic> jsonResponse = json.decode(response.body) as Map<String, dynamic>;

        // Перевірка на наявність токена в відповіді
        // ignore: lines_longer_than_80_chars
        if (jsonResponse.containsKey('token') && jsonResponse['token'] is String) {
          return jsonResponse['token'] as String;  // Повертаємо токен
        } else {
          throw Exception('Token not found or invalid type in response');
        }
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
