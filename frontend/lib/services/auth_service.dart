import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../api_config.dart';
import '../components/models/user_role_model.dart';

class AuthService {
  // --- TU CÓDIGO ORIGINAL EMPIEZA AQUÍ ---
  final storage = const FlutterSecureStorage();

  Future<void> sendVerificationCode(String email) async {
    final response = await http.post(
      Uri.parse('https://festymatch-production.up.railway.app/auth/send-register-code'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );
    if (response.statusCode == 201) {}
  }

  Future<String?> getUserRole() async {
    final role = await storage.read(key: 'user_role');
    return role;
  }

  Future<String> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.authBaseUrl}/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    final responseBody = json.decode(response.body);
    if (response.statusCode == 201) {
      final token = responseBody['token'];
      // --- LÍNEA AÑADIDA 1 ---
      await _storeUserDataFromToken(token); // Guarda id, rol(es) y token
      return response.statusCode.toString();
    } else {
      return '${responseBody['message']}';
    }
  }

  Future<String> registerUser(String email, String password, String passwordConfirm) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.authBaseUrl}/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password, 'passwordConfirm': passwordConfirm}),
    );
    final responseBody = json.decode(response.body);
    if (response.statusCode == 201) {
      return response.statusCode.toString();
    } else {
      return '${responseBody['message']}';
    }
  }

  Future<String> verificationEmail(String email, String verificationCode) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.authBaseUrl}/verify-account'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'verificationCode': verificationCode}),
    );
    final responseBody = json.decode(response.body);
    if (response.statusCode == 201) {
      final token = responseBody['token'];
      if (token == null) {
        throw Exception('El servidor no devolvió el token.');
      }
      // --- LÍNEA AÑADIDA 2 ---
      await _storeUserDataFromToken(token); // Guarda id, rol(es) y token
      return response.statusCode.toString();
    }
    return '${responseBody['message']}';
  }

  Future<bool> checkAuthentication() async {
    final token = await storage.read(key: 'jwt_token');
    return token != null && token.isNotEmpty;
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  Future<void> logout() async {
    // MODIFICADO: Ahora borra los 3 datos
    await storage.delete(key: 'jwt_token');
    await storage.delete(key: 'user_id');
    await storage.delete(key: 'user_roles'); // Cambiado de 'user_role' a 'user_roles'
  }

  Future<String> updatePassword(String currentPassword, String newPassword, String passwordConfirm) async {
    final token = await getToken();
    if (token == null) return "No estás autenticado";
    final url = Uri.parse('${ApiConfig.authBaseUrl}/change-password');
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode({'currentPassword': currentPassword, 'newPassword': newPassword, 'passwordConfirm': passwordConfirm}),
    );
    final Map<String, dynamic> responseBody = json.decode(response.body);
    if (response.statusCode == 201) {
      return response.statusCode.toString();
    } else {
      return '${responseBody['message']}';
    }
  }

  // =============================================================
  // === MÉTODOS NUEVOS (AÑADIDOS AL FINAL DEL ARCHIVO) ===
  // =============================================================

  // --- AÑADIDO: Helper privado para guardar los datos ---
  Future<void> _storeUserDataFromToken(String token) async {
    final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    final userId = decodedToken['id'] as String?;
    
    List<dynamic> rolesList = [];
    if (decodedToken['roles'] is List) { // Si el backend envía una lista 'roles'
      rolesList = decodedToken['roles'];
    } else if (decodedToken['role'] is String) { // Si envía un solo 'role'
      rolesList.add(decodedToken['role']);
    }

    if (userId != null && rolesList.isNotEmpty) {
      final rolesString = rolesList.cast<String>().join(',');
      await storage.write(key: 'jwt_token', value: token);
      await storage.write(key: 'user_id', value: userId);
      await storage.write(key: 'user_roles', value: rolesString); // Guardamos la clave en plural
    }
  }

  // --- AÑADIDO: Nuevo método para obtener el ID del usuario actual ---
  Future<String?> getCurrentUserId() async {
    return await storage.read(key: 'user_id');
  }

  // --- AÑADIDO: Nuevo método para obtener la lista de roles del usuario actual ---
  Future<List<String>> getCurrentUserRoles() async {
    final rolesString = await storage.read(key: 'user_roles');
    if (rolesString == null || rolesString.isEmpty) return [];
    return rolesString.split(',');
  }
}