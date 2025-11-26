import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  static Future<List<dynamic>> getCategories() async {
    final res = await http.get(Uri.parse('$baseUrl/categories.php'));
    return jsonDecode(res.body)['categories'];
  }

  static Future<List<dynamic>> getMealsByCategory(String category) async {
    final res = await http.get(Uri.parse('$baseUrl/filter.php?c=$category'));
    return jsonDecode(res.body)['meals'];
  }

  static Future<List<dynamic>> searchMeals(String query) async {
    final res = await http.get(Uri.parse('$baseUrl/search.php?s=$query'));
    return jsonDecode(res.body)['meals'] ?? [];
  }

  static Future<Map<String, dynamic>> getMealDetails(String id) async {
    final res = await http.get(Uri.parse('$baseUrl/lookup.php?i=$id'));
    return jsonDecode(res.body)['meals'][0];
  }

  static Future<Map<String, dynamic>> getRandomMeal() async {
    final res = await http.get(Uri.parse('$baseUrl/random.php'));
    return jsonDecode(res.body)['meals'][0];
  }
}
