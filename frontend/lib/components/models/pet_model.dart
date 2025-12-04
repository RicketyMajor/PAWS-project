import '/components/string_extensions.dart';

class Pet {
  final String id;
  final String name;
  final String type;
  final String size;
  final String ageCategory;
  final String gender;
  final bool compatibilityWithKids;
  final bool compatibilityWithDogs;
  final bool compatibilityWithCats;
  final bool isSterilized;
  final String mainPhotoUrl;
  final String userId; 

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.size,
    required this.ageCategory,
    required this.gender,
    required this.compatibilityWithKids,
    required this.compatibilityWithDogs,
    required this.compatibilityWithCats,
    required this.isSterilized,
    required this.mainPhotoUrl,
    required this.userId, 
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    if (json['userId'] == null) {
      throw FormatException("El JSON de la mascota no contiene el campo 'userId'.");
    }

    return Pet(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Sin nombre',
      type: (json['type'] as String? ?? 'Desconocido').toCapitalized(),
      size: (json['size'] as String? ?? 'Desconocido').toCapitalized(),
      ageCategory: (json['ageCategory'] as String? ?? 'Desconocido').toCapitalized(),
      gender: (json['gender'] as String? ?? 'Desconocido').toCapitalized(),
      compatibilityWithKids: json['compatibilityWithKids'] ?? false,
      compatibilityWithDogs: json['compatibilityWithDogs'] ?? false,
      compatibilityWithCats: json['compatibilityWithCats'] ?? false,
      isSterilized: json['isSterilized'] ?? false,
      mainPhotoUrl: json['mainPhotoUrl'] ?? 'lib/images/cat1.jpg',
      userId: json['userId'], 
    );
  }
}