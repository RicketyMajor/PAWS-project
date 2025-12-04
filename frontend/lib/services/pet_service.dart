import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:festymatch_frontend/services/auth_service.dart';

import '../api_config.dart';

class PetService {

  Future<String> createPetProfile(
      String name,
      String mainPhotoUrl,
      String type,
      String? breed,
      String ageCategory,
      String size,
      String gender,
      String locationCity,
      String locationRegion,
       String description) async {
    final token = await AuthService().getToken();
    if (token == null) {
      return "Token is null";
    }

    final response = await http.post(
      Uri.parse(ApiConfig.petsBaseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': name,
        'mainPhotoUrl': mainPhotoUrl,
        'type': type,
        'breed': breed,
        'ageCategory': ageCategory,
        'size': size,
        'gender': gender,
        'locationCity': locationCity,
        'locationRegion': locationRegion,
        'description':description
      }),
    );

    final Map<String, dynamic> responseBody = json.decode(response.body);

    if (response.statusCode == 201) {
      return response.statusCode.toString();
    } else {
      return '${responseBody['message']}';
    }
  }

  Future<bool> verifyPetCreated() async {
    bool verification = false;

    final token = await AuthService().getToken();
    if (token == null) {
      print('Token is null');
      return false;
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.petsBaseUrl}/publications'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );

    print(json.decode(response.body));

    if (response.statusCode == 200) {
      verification = true;
    }

    return verification;
  }

  Future<List<Map<String, dynamic>>> fetchPetsByRescuer() async {
    final token = await AuthService().getToken();
    if (token == null) {
      throw Exception("Token no disponible");
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.petsBaseUrl}/publications'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('No se pudieron cargar las mascotas del rescatista');
    }
  }

  Future<Map<String, dynamic>?> fetchPetData(String petId) async {
    final token = await AuthService().getToken();
    if (token == null) {
      return null;
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.petsBaseUrl}/$petId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );

// Imprimir el contenido
    if (response.statusCode == 200 || response.statusCode == 404) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      // Manejar errores según sea necesario
      return null;
    }
  }

  Future<String> updatePetProfile({
  required String petId,
  String? name,
  String? mainPhotoUrl,
  String? type,
  String? breed,
  String? ageCategory,
  String? size,
  String? gender,
  String? locationCity,
  String? locationRegion,
  String? description,
}) async {
  final token = await AuthService().getToken();
  if (token == null) {
    return "Token is null";
  }

  // Armar solo los campos no-nulos
  final Map<String, dynamic> body = {};

  if (name != null) body['name'] = name;
  if (mainPhotoUrl != null) body['mainPhotoUrl'] = mainPhotoUrl;
  if (type != null) body['type'] = type;
  if (breed != null) body['breed'] = breed;
  if (ageCategory != null) body['ageCategory'] = ageCategory;
  if (size != null) body['size'] = size;
  if (gender != null) body['gender'] = gender;
  if (locationCity != null) body['locationCity'] = locationCity;
  if (locationRegion != null) body['locationRegion'] = locationRegion;
  if (description != null) body['description'] = description;

  final response = await http.patch(
    Uri.parse('${ApiConfig.petsBaseUrl}/$petId'), // Agregamos el petId a la URL
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
