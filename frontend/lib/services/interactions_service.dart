// services/matchmaking_api_service.dart
import 'dart:convert';
import 'package:festymatch_frontend/api_config.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart'; // Adjust path as needed

class InteractionsService {
 // REPLACE with your NestJS API URL

  Future<String> likePet(String petId) async {
    final token = await AuthService().getToken();
    if (token == null) throw Exception("Token no disponible");

    final response = await http.post(
      Uri.parse("${ApiConfig.petsBaseUrl}/$petId/like"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    final responseBody = json.decode(response.body);

    if (response.statusCode == 201) {
      int status = response.statusCode;
      String statusString = "$status";
      return statusString;
    } else {
      return '${responseBody['message']}';
    }
  }

  Future<String> rejectPet(String petId) async {
    final token = await AuthService().getToken();
    if (token == null) throw Exception("Token no disponible");

    final response = await http.post(
      Uri.parse("${ApiConfig.petsBaseUrl}/reject/$petId"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    final responseBody = json.decode(response.body);

    if (response.statusCode == 201) {
      int status = response.statusCode;
      String statusString = "$status";
      return statusString;
    } else {
      return '${responseBody['message']}';
    }
  }

  Future<List<Map<String, dynamic>>> getInterestedUsers(String petId) async {
    final token = await AuthService().getToken();
    if (token == null) throw Exception("Token no disponible");

    final response = await http.get(
      Uri.parse('${ApiConfig.petsBaseUrl}/$petId/interests'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Error al cargar interesados");
    }
  }

  Future<String> updateInteraction(String status, String interactionId) async {
    final token = await AuthService().getToken();
    if (token == null) throw Exception("Token no disponible");

    final response = await http.patch(
      Uri.parse("h${ApiConfig.interestsBaseUrl}/$interactionId/status"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
            body: json.encode({'status': status}),

    );
    final responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      int status = response.statusCode;
      String statusString = "$status";
      return statusString;
    } else {
      return '${responseBody['message']}';
    }
  }
}
