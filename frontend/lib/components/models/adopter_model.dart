class AdopterModel {
  final String id;
  final String name;
  final String profilePictureUrl;
  final String housingType;
  final bool hasOtherPets;

  final String? preferredPetType;
  final String? preferredPetSize;
  final String? preferredPetAge;
  final String? preferredPetGender;

  AdopterModel({
    required this.id,
    required this.name,
    required this.profilePictureUrl,
    required this.housingType,
    required this.hasOtherPets,
    
    this.preferredPetType,
    this.preferredPetSize,
    this.preferredPetAge,
    this.preferredPetGender,
  });

  factory AdopterModel.fromJson(Map<String, dynamic> json) {
    return AdopterModel(
      id: json['id'],
      name: json['name'],
      profilePictureUrl: json['profilePictureUrl'],
      housingType: json['housingType'] ?? 'No especificado',
      hasOtherPets: json['hasOtherPets'] ?? false,
      
      preferredPetType: json['preferredPetType'],
      preferredPetSize: json['preferredPetSize'],
      preferredPetAge: json['preferredPetAge'],
      preferredPetGender: json['preferredPetGender'],
    );
  }
}