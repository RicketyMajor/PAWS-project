import 'package:flutter/material.dart';
import '../../components/my_button.dart';
import '../../components/my_text_field.dart';
import '../../components/show_snackbar.dart';
import '../../gates/home_rescuer_gate.dart';
import '../../services/pet_service.dart';

class SetPetPicturePage extends StatefulWidget {
  const SetPetPicturePage({super.key});

  @override
  State<SetPetPicturePage> createState() => _SetPetPicturePageState();
}

class _SetPetPicturePageState extends State<SetPetPicturePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _photoUrlController = TextEditingController();
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    // Get the arguments (name and location)
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final String type = args?['petType'];
    final String gender = args?['petGender'];
    final String size = args?['dogSize'];
    final String? breed = args?['dogBreed'];
    final String locationRegion = args?['region'];
    final String locationCity = args?['comuna'];
    final String name = args?['petName']; // Receive petName
    final String ageCategory = args?['age'];
        final String description = args?['description']; // Receive age
 // Receive age

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Set background to white
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Colors.black), // Set icon color to black
          onPressed: () {
            Navigator.pop(
                context); // This will pop the current route off the stack
          },
        ),
        title: const Text(''), // Remove the title text
        centerTitle:
            true, // Keep it centered if you decide to add content later
      ),
      body: Column(
        children: [
          // Logo con espacio superior
          Padding(
            padding: const EdgeInsets.only(top: 80.0, bottom: 30.0),
            child: Center(
              child: Image.asset(
                'lib/images/paws_logo.png',
                width: 200,
                height: 200,
              ),
            ),
          ),
          // Título de la página
          const Padding(
            padding: EdgeInsets.only(bottom: 30.0),
            child: Text(
              'Sube una foto de la mascota',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Form(
                  key: _formKey,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Mensaje de error
                        SizedBox(
                          height: 20,
                          child: _errorMessage.isNotEmpty
                              ? Text(
                                  _errorMessage,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.left,
                                )
                              : null,
                        ),
                        // Campo de texto para la URL de la foto
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0),
                          child: MyTextField(
                            controller: _photoUrlController,
                            hintText: 'Ingresa la URL de la foto',
                            obscureText: false,
                            validatorFunction: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa la URL de la foto';
                              }
                              // You might want to add a more robust URL validation here
                              // For a basic check, you could see if it starts with 'http' or 'https'
                              if (!value.startsWith('http://') &&
                                  !value.startsWith('https://')) {
                                return 'Por favor, ingresa una URL válida (http:// o https://)';
                              }
                              return null;
                            },
                          ),
                        ),
                        // Botón para continuar
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: MyButton(
                            
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                String mainPhotoUrl = _photoUrlController.text;

                                // Intenta crear el perfil de la mascota
                                String response =
                                    await PetService().createPetProfile(
                                  name,
                                  mainPhotoUrl,
                                  type,
                                  breed,
                                  ageCategory,
                                  size,
                                  gender,
                                  locationCity,
                                  locationRegion,
                                  description
                                );
                                if (response == "201") {
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          HomeRescuerGate(),
                                      transitionDuration: Duration.zero,
                                    ),
                                  );
                                } else {
                                  mySnackBars.showError(response, context);
                                }
                              }
                            },
                            text: 'Continuar', // Or "Guardar", "Enviar", etc.
                          ),
                        ),
                        // Texto informativo opcional
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 20.0),
                          child: Text(
                            'Sube una foto de la mascota.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
