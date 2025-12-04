import 'package:flutter/material.dart';
import '../../components/navbar.dart';
import '../../components/models/pet_model.dart';
import '../../services/match_result_service.dart'; 

class ChatPetProfilePage extends StatefulWidget {
  final Pet pet; 

  const ChatPetProfilePage({Key? key, required this.pet}) : super(key: key);
  
  @override
  _ChatPetProfilePageState createState() => _ChatPetProfilePageState();
}


class _ChatPetProfilePageState extends State<ChatPetProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedStatus; 
  final TextEditingController _reasonController = TextEditingController();
  final MatchResultService _adoptionService = MatchResultService(); 
  void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: const Text(
            "Actualizar Estado de Adopción",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  decoration: const InputDecoration(
                    labelText: "ADOPCIÓN",
                    border: OutlineInputBorder(),
                  ),
                  hint: const Text("Seleccionar..."),
                  items: ['Exitoso', 'Fallido'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedStatus = newValue;
                    });
                  },
                  validator: (value) => value == null ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _reasonController,
                  decoration: const InputDecoration(
                    labelText: "MOTIVO",
                    hintText: "Descripción...",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4, // Permite escribir varias líneas
                  maxLength: 280, // Límite de caracteres opcional
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              onPressed: _submitAdoptionStatus,
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  void _submitAdoptionStatus() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await _adoptionService.updateAdoptionStatus(
          petId: widget.pet.id,
          status: _selectedStatus!,
          reason: _reasonController.text,
        );
        if (mounted) {
          Navigator.of(context).pop(); 
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Estado actualizado con éxito!'),
              backgroundColor: Colors.green,
            ),
          );
        }

      } catch (e) {
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al actualizar: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet.name),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(widget.pet.mainPhotoUrl),
              ),
              const SizedBox(height: 20),

              Text(
                widget.pet.name,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold), 
              ),
              const SizedBox(height: 20),

              Wrap(
                spacing: 8.0, 
                runSpacing: 4.0, 
                alignment: WrapAlignment.center,
                children: [
                  Chip(label: Text(widget.pet.ageCategory)),
                  Chip(label: Text(widget.pet.size)),
                  Chip(label: Text(widget.pet.gender)),
                ],
              ),
              const SizedBox(height: 50),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )
                ),
                onPressed: () => _showUpdateDialog(context),
                child: const Text("Actualizar Estado de Adopción", style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),      bottomNavigationBar: NavBar(currentIndex: 1),
    );
  }
}