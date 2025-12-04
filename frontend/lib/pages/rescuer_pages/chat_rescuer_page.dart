import 'package:flutter/material.dart';
import '../../components/models/match_result_model.dart';
import '../../components/models/adopter_model.dart';

class ChatRescuerPage extends StatefulWidget {
  final MatchResultModel match;

  const ChatRescuerPage({Key? key, required this.match}) : super(key: key);
  @override
  State<ChatRescuerPage> createState() => _ChatRescuerPageState();
}


class _ChatRescuerPageState extends State<ChatRescuerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/adopter_profile_page', 
              arguments: widget.match.adopter, 
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.match.adopter.profilePictureUrl),
              ),
              const SizedBox(width: 12),
              Text(widget.match.adopter.name),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Tú y ${widget.match.adopter.name} hicieron match por ${widget.match.pet.name}',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            blurRadius: 2,
            color: Colors.grey.withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Escribe un mensaje...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () {
            },
          ),
        ],
      ),
    );
  }
}