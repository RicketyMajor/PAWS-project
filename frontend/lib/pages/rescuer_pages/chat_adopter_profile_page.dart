import 'package:flutter/material.dart';
import '../../components/models/adopter_model.dart'; // Asegúrate de que este es el nombre de tu archivo/clase
import '../../components/pet_preferences.dart';             // Importa el archivo con los mapas de preferencias

class ChatAdopterProfilePage extends StatelessWidget { // He renombrado tu clase para seguir la convención
  // --- CORRECCIÓN 2: USA EL NOMBRE DE CLASE CORRECTO ---
  final AdopterModel adopter;

  const ChatAdopterProfilePage({Key? key, required this.adopter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // La lógica de aquí abajo ya estaba perfecta
    final List<Widget> preferenceChips = [];

    if (adopter.housingType != null && adopter.housingType!.isNotEmpty) {
      preferenceChips.add(_buildInfoChip('Vive en ${adopter.housingType}'));
    }
    preferenceChips.add(_buildInfoChip(adopter.hasOtherPets ? 'Tiene más mascotas' : 'No tiene más mascotas'));

    if (adopter.preferredPetType != null && adopter.preferredPetType!.isNotEmpty) {
      String label = preferencesTypesOptions[adopter.preferredPetType!] ?? adopter.preferredPetType!;
      preferenceChips.add(_buildInfoChip('Busca: $label'));
    }
    if (adopter.preferredPetSize != null && adopter.preferredPetSize!.isNotEmpty) {
      String label = preferencesPetSize[adopter.preferredPetSize!] ?? adopter.preferredPetSize!;
      preferenceChips.add(_buildInfoChip('Tamaño: $label'));
    }
    if (adopter.preferredPetAge != null && adopter.preferredPetAge!.isNotEmpty) {
      String label = preferencesAgeOptions[adopter.preferredPetAge!] ?? adopter.preferredPetAge!;
      preferenceChips.add(_buildInfoChip('Edad: $label'));
    }
    if (adopter.preferredPetGender != null && adopter.preferredPetGender!.isNotEmpty) {
      String label = preferencesGenderOptions[adopter.preferredPetGender!] ?? adopter.preferredPetGender!;
      preferenceChips.add(_buildInfoChip('Género: $label'));
    }

    return Scaffold(
      appBar: AppBar( /* ... tu appbar ... */ ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(adopter.profilePictureUrl),
              ),
              const SizedBox(height: 16),
              Text(
                adopter.name,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              if (preferenceChips.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.center,
                  children: preferenceChips,
                )
              else
                const Text(
                  'Aún no ha definido sus preferencias.',
                  style: TextStyle(color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.black54),
      ),
      backgroundColor: Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    );
  }
}