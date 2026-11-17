import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = 'https://www.freetogame.com/api';

  static Future<List<dynamic>> getGames() async {
    final response = await http.get(Uri.parse('$baseUrl/games'));
    if (response.statusCode != 200) {
      throw Exception('Gagal memuat data game');
    }
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getGameDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/game?id=$id'));
    if (response.statusCode != 200) {
      throw Exception('Gagal memuat detail game');
    }
    return jsonDecode(response.body);
  }
}