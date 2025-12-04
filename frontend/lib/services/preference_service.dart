import 'package:festymatch_frontend/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'auth_service.dart';

class PreferenceService {

  Future<String> createPreference(
    // Changed return type to Future<void>
    String preferredPetType,
    String preferredPetSize,
    String preferredPetAge,
    String preferredPetGender,
  ) async {
    // No longer returns a String, throws an Exception on error
    final token = await AuthService().getToken();

    if (token == null) {
      throw Exception(
          'No se encontró el token de autenticación. Por favor, inicia sesión de nuevo.');
    }

    final response = await http.post(
      Uri.parse(ApiConfig.preferencesBaseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'preferredPetType': preferredPetType,
        'preferredPetSize': preferredPetSize,
        'preferredPetAge': preferredPetAge,
        'preferredPetGender': preferredPetGender,
      }),
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

  Future<String> changePreference(
    // Changed return type to Future<void>
    String preferredPetType,
    String preferredPetSize,
    String preferredPetAge,
    String preferredPetGender,
  ) async {
    // No longer returns a String, throws an Exception on error
    final token = await AuthService().getToken();

    if (token == null) {
      throw Exception(
          'No se encontró el token de autenticación. Por favor, inicia sesión de nuevo.');
    }

    final response = await http.patch(
      Uri.parse(ApiConfig.preferencesBaseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'preferredPetType': preferredPetType,
        'preferredPetSize': preferredPetSize,
        'preferredPetAge': preferredPetAge,
        'preferredPetGender': preferredPetGender,
      }),
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

  Future<bool> verifyPreferenceCreated() async {
    bool verification = false;

    final token = await AuthService().getToken();
    if (token == null) {
      return false;
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.preferencesBaseUrl}/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      verification = true;
    }

    return verification;
  }
}
