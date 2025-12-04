import 'package:flutter/material.dart';
import '../../components/models/match_result_model.dart'; 
import '../../components/navbar.dart';

class ChatAdoptantPage extends StatefulWidget {
  final MatchResultModel match;
  const ChatAdoptantPage({
    super.key,
    required this.match, 
  });

  @override
  State<ChatAdoptantPage> createState() => _ChatAdoptantPageState();
}

class _ChatAdoptantPageState extends State<ChatAdoptantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/chat_pet_profile_page',
              arguments: widget.match.pet, 
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.match.pet.mainPhotoUrl),
              ),
              const SizedBox(width: 12),
              Text(widget.match.pet.name),
            ],
          ),
        ),
      ),
      body: Center(
        child: Text('¡Tú y ${widget.match.pet.name} hicieron match!'),
      ),      bottomNavigationBar: NavBar(currentIndex: 1)
    );
  }
}