import 'package:festymatch_frontend/services/profile_service.dart';
import 'package:flutter/material.dart';
import '../user_settings_pages/settings_page.dart';
import '../../components/navbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _profileName = "Cargando...";
  String? _profilePictureUrl;
  String _addressRegion = "";
  String _addressCity = "";
  String _profileLastName = "";
  String _aboutMe = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final _userData = await ProfileService().fetchMyProfileData();
    if (_userData != null) {
      setState(() {
        _profileName = _userData['name'] ?? "Usuario";
        _profileLastName = _userData['lastName'] ?? "";
        _profilePictureUrl = _userData['profilePictureUrl'];
        _addressRegion = _userData['addressRegion'] ?? "";
        _addressCity = _userData['addressCity'] ?? "";
        _aboutMe = _userData['aboutMe'] ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 48),
                  const Text(
                    'Mi Perfil',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // Nombre
                    Center(
                      child: Container(
                        width: 350,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "$_profileName $_profileLastName",
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Imagen de perfil centrada
                    Center(
                      child: Container(
                        width: 350,
                        height: 350,
                        child: _profilePictureUrl != null &&
                                _profilePictureUrl!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  _profilePictureUrl!,
                                  width: 350,
                                  height: 350,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.person,
                                      size: 180,
                                      color: Colors.grey[600],
                                    );
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 180,
                                color: Colors.grey[600],
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Región y ciudad
                    Center(
                      child: Container(
                        width: 350,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '$_addressRegion, $_addressCity',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Botón editar perfil
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/edit_profile_page',
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Editar perfil',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          minimumSize: const Size(350, 50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Título "Sobre mí"
                    Center(
                      child: Container(
                        width: 350,
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Sobre mí',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Descripción personal en RawChip de ancho completo
                    Center(
                      child: Container(
                        width: 350,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _aboutMe.isNotEmpty
                              ? _aboutMe
                              : 'Sin descripción personal.',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(currentIndex: 3),
    );
  }
}
