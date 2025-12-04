import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api_config.dart';
import 'auth_service.dart';

class ProfileService {
  Future<String> createProfile(
      String name,
      String lastName,
      String profilePictureUrl,
      String addressCity,
      String addressRegion,
      String aboutMe,
      bool isAdopter,
      bool isRescuer) async {
    final token = await AuthService().getToken();
    if (token == null) {
      return "Token is null";
    }
    final response = await http.post(
      Uri.parse(ApiConfig.profilesBaseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': name,
        'lastName': lastName, // Dejar lastName (camelCase)
        "profilePictureUrl": profilePictureUrl,
        "addressCity": addressCity,
        "addressRegion": addressRegion,
        "aboutMe": aboutMe,
        "isAdopter": isAdopter,
        "isRescuer": isRescuer
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

  Future<bool> verifyProfileCreated() async {
    bool verification = false;

    final token = await AuthService().getToken();
    if (token == null) {
      return false;
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.profilesBaseUrl}/me'),
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

  Future<Map<String, dynamic>?> fetchMyProfileData() async {
    final token = await AuthService().getToken();
    if (token == null) {
      return null;
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.profilesBaseUrl}/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );

// Imprimir el contenido
    if (response.statusCode == 200 || response.statusCode == 404) {
      return json.decode(response.body);
    } else {
      // Manejar errores según sea necesario
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchOtherProfileData(String userId) async {
    final token = await AuthService().getToken();
    if (token == null) {
      return null;
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.profilesBaseUrl}/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );

// Imprimir el contenido
    if (response.statusCode == 200 || response.statusCode == 404) {
      return json.decode(response.body);
    } else {
      // Manejar errores según sea necesario
      return null;
    }
  }

  Future<String> updateProfile({
    String? name,
    String? lastName,
    String? profilePictureUrl,
    String? addressCity,
    String? addressRegion,
    String? aboutMe,
    bool? isAdopter,
    bool? isRescuer,
  }) async {
    final token = await AuthService().getToken();
    if (token == null) {
      return "Token is null";
    }

    // Armar solo los campos no-nulos
    final Map<String, dynamic> body = {};

    if (name != null) body['name'] = name;
    if (lastName != null) body['lastName'] = lastName;
    if (profilePictureUrl != null)
      body['profilePictureUrl'] = profilePictureUrl;
    if (addressCity != null) body['addressCity'] = addressCity;
    if (addressRegion != null) body['addressRegion'] = addressRegion;
    if (aboutMe != null) body['aboutMe'] = aboutMe;

    if (isAdopter != null) body['isAdopter'] = isAdopter;
    if (isRescuer != null) body['isRescuer'] = isRescuer;

    final response = await http.patch(
      Uri.parse(ApiConfig.profilesBaseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      return "${response.statusCode}";
    } else {
      return '${responseBody['message']}';
    }
  }
}
