import 'package:festymatch_frontend/components/my_appBar.dart';
import 'package:festymatch_frontend/services/interactions_service.dart';
import 'package:festymatch_frontend/services/profile_service.dart';
// Importa el servicio que contiene updateInteraction
// import 'package:festymatch_frontend/services/interaction_service.dart';
import 'package:flutter/material.dart';
import '../user_settings_pages/settings_page.dart';
import '../../components/navbar.dart';

class OtherProfilePage extends StatefulWidget {
  final String userId;
  final String interactionId;
  final String interactionStatus;

  const OtherProfilePage(
      {super.key, required this.userId, required this.interactionId,required this.interactionStatus });

  @override
  State<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  String _profileName = "Cargando...";
  String? _profilePictureUrl;
  String _addressRegion = "";
  String _addressCity = "";
  String _profileLastName = "";
  String _aboutMe = "";
  String _currentInteractionStatus = ""; // Variable para manejar el estado actual

  @override
  void initState() {
    super.initState();
    _currentInteractionStatus = widget.interactionStatus; // Inicializar con el estado pasado
    loadUserData();
    loadInteractionStatus();
  }

  Future<void> loadUserData() async {
    final _userData =
        await ProfileService().fetchOtherProfileData(widget.userId);
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

  Future<void> loadInteractionStatus() async {
    // Aquí deberías cargar el estado actual de la interacción
    // Por ahora lo dejo como "pending" por defecto
    // Puedes implementar un método en InteractionsService para obtener el estado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            // Top bar

            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
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

                    // Título "Sobre mí"

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
                    const SizedBox(height: 10),

                    Center(
                      child: Container(
                        width: 350,
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Sobre mí hogar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildInfoBox("Vive en una casa" ?? 'No especificado'),
                        const SizedBox(width: 10), // Espacio horizontal

                        _buildInfoBox("No tiene patio" ?? 'No especificado'),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Center(
                      child: Container(
                        width: 350,
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Tiene mas mascotas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10), // Espacio horizontal

                        _buildInfoBox(
                            "Descripcion mascota" ?? 'No especificado'),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Botones condicionales - Usando la variable de estado local
                    if (_currentInteractionStatus == 'accepted')
                    
                      // Solo mostrar botón de chat si está aceptado
                      _buildActionButton(
                        icon: Icons.chat,
                        color: const Color.fromARGB(255, 53, 53, 53),
                        onPressed: () {
                          // Aquí puedes navegar a la página de chat
                          // Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPage(...)));
                          print('Navegar al chat con $_profileName');
                        },
                      )
                    else
                      // Mostrar botones de aceptar/rechazar si no está aceptado
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            icon: Icons.close,
                            color: Colors.red,
                            onPressed: () async {
                              // Enviar status 'rejected' a updateInteraction
                              final response = await InteractionsService()
                                  .updateInteraction(
                                      'rejected', widget.interactionId);
                              print(response);
                              Navigator.pop(context); // Regresar a la página anterior
                            },
                          ),
                          _buildActionButton(
                            icon: Icons.favorite,
                            color: Colors.green,
                            onPressed: () async {
                              // Enviar status 'accepted' a updateInteraction
                              final response = await InteractionsService()
                                  .updateInteraction(
                                      'accepted', widget.interactionId);
                              
                              // Actualizar el estado local para mostrar el botón de chat
                              setState(() {
                                _currentInteractionStatus = 'accepted';
                              });
                            },
                          ),
                        ],
                      ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 40),
      ),
    );
  }

  Widget _buildInfoBox(String value) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 350, // Ancho máximo disponible
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
        softWrap: true,
        overflow: TextOverflow.visible,
      ),
    );
  }
}