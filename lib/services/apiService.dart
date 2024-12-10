import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://localhost:3000'; // URL сервера-обхідника

  // Загальний метод для отримання даних через GET запит
  Future<Map<String, dynamic>> _getData(String endpoint) async {
    final response = await http.get(
      Uri.parse(baseUrl + endpoint),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Метод для отримання новин про техніку
  Future<List<Map<String, dynamic>>> fetchTechNews() async {
    final data = await _getData("/api/technews");

    if (data['status'] != 'ok' || !data.containsKey('articles')) {
      throw Exception('Invalid data structure from API');
    }
    return (data['articles'] as List)
        .map((article) => article as Map<String, dynamic>)
        .toList();
  }
}