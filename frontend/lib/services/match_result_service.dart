import 'dart:convert';
import 'package:http/http.dart' as http;
import '../components/models/match_result_model.dart';
import 'auth_service.dart'; 

class MatchResultService {
  final String _baseUrl = "http://192.168.1.17:3000";

  Future<List<MatchResultModel>> fetchMatches(String userId) async {
    final url = Uri.parse('$_baseUrl/matchmaking/find-matches?userId=$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => MatchResultModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener los matches: ${response.statusCode}');
    }
  }

  Future<void> updateAdoptionStatus({
    required String petId,
    required String status,
    String? reason,
  }) async {
    final url = Uri.parse('$_baseUrl/pets/$petId/adoption');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'status': status.toLowerCase(),
        'reason': reason ?? '',
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Fallo al actualizar el estado de la adopción: ${response.statusCode}');
    }
  }

  Future<List<MatchResultModel>> fetchAllMyMatches(String userId) async {

    final url = Uri.parse('$_baseUrl/matchmaking/my-all-matches?userId=$userId');
    
    final token = await AuthService().getToken();
    if (token == null) {
      throw Exception('Usuario no autenticado');
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<MatchResultModel> matches = data
            .map((json) => MatchResultModel.fromJson(json))
            .toList();
        
        matches.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        return matches;
      } else {
        print('Error al cargar todos los matches: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Excepción al cargar todos los matches: $e');
      return [];
    }
  }
}