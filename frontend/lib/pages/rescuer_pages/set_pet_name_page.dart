import 'package:festymatch_frontend/components/my_appBar.dart';
import 'package:flutter/material.dart';

import '../../components/my_button.dart';
import '../../components/my_text_field.dart';

class SetPetNamePage extends StatefulWidget {
  const SetPetNamePage({super.key});

  @override
  State<SetPetNamePage> createState() => _SetPetNamePageState();
}

class _SetPetNamePageState extends State<SetPetNamePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _petNameController = TextEditingController();
  String _errorMessage = "";

  @override
  void dispose() {
    _petNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: Column(
        children: [
          // Logo con espacio superior
          Padding(
            padding: const EdgeInsets.only(
                top: 30.0,
                bottom: 30.0), // Ajusta el padding superior si es necesario
            child: Center(
              child: Image.asset(
                'lib/images/paws_logo.png',
                width: 200,
                height: 200,
              ),
            ),
          ),

          // Título principal
          const Padding(
            padding: EdgeInsets.only(bottom: 30.0),
            child: Text(
              '¡Dinos cómo se llama la mascota!',
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

                        // Campo de texto para el nombre de la mascota
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: MyTextField(
                            controller: _petNameController,
                            hintText: 'Nombre de la mascota',
                            obscureText: false,
                            validatorFunction: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa el nombre de la mascota';
                              }
                              if (value.length < 2) {
                                return 'El nombre debe tener al menos 2 caracteres';
                              }
                              return null;
                            },
                          ),
                        ),

                        // Botón para continuar
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: MyButton(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                final String petName = _petNameController.text;
                                setState(() {
                                  _errorMessage = "";
                                });

                                // Navegar a la siguiente página con el nombre de la mascota
                                Navigator.pushNamed(
                                  context,
                                  '/set_pet_info_1_page',
                                  arguments: {'petName': petName},
                                );
                              }
                            },
                            text: 'Continuar',
                          ),
                        ),

                        // Texto informativo opcional
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 20.0),
                          child: Text(
                            'Usaremos el nombre de tu mascota para personalizar su publicación.',
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
