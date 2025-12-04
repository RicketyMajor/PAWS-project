class ApiConfig {
  // URL base del servidor
  static const String _baseUrl = 'http://192.168.1.17:3000';

  
  // URLs específicas para cada servicio
  static const String authBaseUrl = '$_baseUrl/auth';
  static const String profilesBaseUrl = '$_baseUrl/profiles';
  static const String petsBaseUrl = '$_baseUrl/pets';
  static const String preferencesBaseUrl = '$_baseUrl/preferences';
  static const String matchmakingBaseUrl = '$_baseUrl/matchmaking';
  static const String interestsBaseUrl = '$_baseUrl/interests';
  
  // URLs específicas (las que están hardcodeadas en diferentes lugares)
// Usamos _baseUrl para que se adapte si cambias a localhost o Android
static String get registerCodeUrl => '$_baseUrl/auth/send-register-code';
  
  // Método para cambiar fácilmente entre entornos
  static String get baseUrl => _baseUrl;
  
  // Método para construcción dinámica de URLs
  static String buildUrl(String endpoint) => '$_baseUrl$endpoint';
}