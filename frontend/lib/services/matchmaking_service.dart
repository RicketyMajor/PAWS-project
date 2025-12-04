// services/matchmaking_api_service.dart
import 'dart:convert';
import 'package:festymatch_frontend/components/models/match_result_model.dart';
import 'package:http/http.dart' as http;
import '../components/models/pet_model.dart';
import '../api_config.dart';
import 'auth_service.dart'; // Adjust path as needed

class MatchmakingService {

  Future<List<MatchResultModel>> getMyMatches({int count = 10}) async {
    final token = await AuthService().getToken();
    if (token == null) {
      return [];
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.matchmakingBaseUrl}?count=$count'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => MatchResultModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load matches');
    }
  }
}
