import 'adopter_model.dart';
import 'pet_model.dart';

class MatchResultModel {
  final AdopterModel adopter;
  final Pet pet;
  final double score;
  final String lastMessage;
  final DateTime timestamp;

  MatchResultModel({
    required this.adopter,
    required this.pet,
    required this.score,
    required this.lastMessage,
    required this.timestamp,
  });

  factory MatchResultModel.fromJson(Map<String, dynamic> json) {
    if (json['adopter'] == null) {
      throw FormatException("El JSON del match no contiene un objeto 'adopter'.");
    }
    if (json['pet'] == null) {
      throw FormatException("El JSON del match no contiene un objeto 'pet'.");
    }

    return MatchResultModel(
      adopter: AdopterModel.fromJson(json['adopter']),
      pet: Pet.fromJson(json['pet']),
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      lastMessage: json['lastMessage'] ?? '', // Proporciona un valor por defecto
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}