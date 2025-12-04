import 'package:flutter/material.dart';
import '../../components/models/match_result_model.dart';
import '../../components/models/pet_model.dart'; // Importante para acceder a pet.userId
import '../../services/match_result_service.dart';
import '../../services/auth_service.dart';
import '../../components/navbar.dart';
import '../../components/models/user_role_model.dart'; // Aunque no lo usemos para la lógica, es bueno tenerlo

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final MatchResultService _matchService = MatchResultService();
  final AuthService _authService = AuthService();

  Future<List<MatchResultModel>>? _matchesFuture;
  String? _currentUserId;
  List<String> _currentUserRoles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final userId = await _authService.getCurrentUserId();
    final userRoles = await _authService.getCurrentUserRoles();

    if (!mounted) return; 

    if (userId != null && userRoles.isNotEmpty) {
      setState(() {
        _currentUserId = userId;
        _currentUserRoles = userRoles;
        _matchesFuture = _matchService.fetchAllMyMatches(userId);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _matchesFuture = Future.error('No se pudo cargar la información del usuario.');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _currentUserRoles.contains('adoptant') ? NavBar(currentIndex: 2) : null,
    );//bottomNavigationBar: NavBar(currentIndex: 2),
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
      title: const Text("Mis Conversaciones", style: TextStyle(fontWeight: FontWeight.bold)),
      shape: const Border(
        bottom: BorderSide(color: Colors.grey, width: 0.5),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return FutureBuilder<List<MatchResultModel>>(
      future: _matchesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "Aún no tienes conversaciones.\n¡Haz match para empezar!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        final matches = snapshot.data!;
        
        return ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];
            if (_currentUserId == match.pet.userId) { 
              return _buildTileAsRescuer(match);
            } else {
              return _buildTileAsAdopter(match);
            }
          },
        );
      },
    );
  }

  Widget _buildTileAsRescuer(MatchResultModel match) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(match.adopter.profilePictureUrl),
      ),
      title: Text(match.adopter.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("Interesado/a en ${match.pet.name}"),
      trailing: const Chip(label: Text("Mi mascota"), backgroundColor: Color(0xFFE3F2FD)),
      onTap: () {
        Navigator.pushNamed(context, '/chat_page', arguments: match);
      },
    );
  }

  Widget _buildTileAsAdopter(MatchResultModel match) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(match.pet.mainPhotoUrl),
      ),
      title: Text(match.pet.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(match.lastMessage),
      trailing: const Chip(label: Text("Adoptando"), backgroundColor: Color(0xFFE8F5E9)),
      onTap: () {
        Navigator.pushNamed(context, '/chat_page', arguments: match);
      },
    );
  }
}