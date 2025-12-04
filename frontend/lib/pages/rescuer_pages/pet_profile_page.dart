import 'package:festymatch_frontend/components/my_appBar.dart';
import 'package:festymatch_frontend/services/pet_service.dart';
import 'package:flutter/material.dart';
import '../../components/pet_characteristics.dart';
import 'edit_pet_profile_page.dart';

class PetProfilePage extends StatefulWidget {
  final String petId;

  const PetProfilePage({super.key, required this.petId});

  @override
  State<PetProfilePage> createState() => _PetProfilePageState();
}

class _PetProfilePageState extends State<PetProfilePage> {
  String _petName = "Cargando...";
  String? _mainPhotoUrl;
  String _locationRegion = "";
  String _locationCity = "";
  String _type = "";
  String _description = "";
  String _breed = "";
  String _ageCategory = "";
  String _size = "";
  String _gender = "";

  @override
  void initState() {
    super.initState();
    _loadPetData();
  }

  Future<void> _loadPetData() async {
    print("Cargando datos para petId: ${widget.petId}");
    final petData = await PetService().fetchPetData(widget.petId);
    print("Datos recibidos: $petData");

    if (petData != null) {
      setState(() {
        _petName = petData['name'] ?? "Mascota";
        _type = petData['type'] ?? "";
        _mainPhotoUrl = petData['mainPhotoUrl'];
        _locationRegion = petData['locationRegion'] ?? "";
        _locationCity = petData['locationCity'] ?? "";
        _description = petData['description'] ?? "";
        _breed = petData['breed'] ?? "";
        _gender = petData['gender'] ?? "";
        _size = petData['size'] ?? "";
        _ageCategory = petData['ageCategory'] ?? "";
      });
    } else {
      print("No se encontró mascota con ese ID.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 0),
                    // Nombre
                    Center(
                      child: Container(
                        width: 350,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _petName,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Imagen de perfil
                    Center(
                      child: Container(
                        width: 350,
                        height: 350,
                        child: _mainPhotoUrl != null &&
                                _mainPhotoUrl!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  _mainPhotoUrl!,
                                  width: 350,
                                  height: 350,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.pets,
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
                                Icons.pets,
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
                          '$_locationRegion, $_locationCity',
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditPetProfilePage(
                                petId: widget.petId,
                              ),
                            ),
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
                        child: Text(
                          'Sobre $_petName',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Descripción
                    Center(
                      child: Container(
                        width: 350,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _description.isNotEmpty
                              ? _description
                              : 'Sin descripción personal.',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    // Si es perro, mostrar características en dos columnas
                    if (_type.toLowerCase() == 'perro') ...[
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildInfoBox(dogBreeds[_breed] ?? 'No especificado'),
                          const SizedBox(width: 20),
                          _buildInfoBox(
                              petGender[_gender] ?? 'No especificado'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildInfoBox(
                              "Tamaño ${petSize[_size] ?? 'No especificado'}"),
                          const SizedBox(width: 20),
                          _buildInfoBox(
                              petAge[_ageCategory] ?? 'No especificado'),
                        ],
                      ),
                    ],
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

  Widget _buildInfoBox(String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
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
      ),
    );
  }
}
