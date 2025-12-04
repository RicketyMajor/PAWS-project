class ChatModel {
  final String id;
  final String adopterName;
  final String adopterPhotoUrl;
  final String petName;
  final String petPhotoUrl;
  final String lastMessage;
  final DateTime timestamp;

  ChatModel({
    required this.id,
    required this.adopterName,
    required this.adopterPhotoUrl,
    required this.petName,
    required this.petPhotoUrl,
    required this.lastMessage,
    required this.timestamp,
  });
}