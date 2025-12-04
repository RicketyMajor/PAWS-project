import 'package:festymatch_frontend/components/my_appBar.dart';
import 'package:flutter/material.dart';
import '../../components/my_button.dart';
import '../../components/my_text_field.dart';

class SetNamePage extends StatefulWidget {
  const SetNamePage({super.key});

  @override
  State<SetNamePage> createState() => _SetNamePageState();
}

class _SetNamePageState extends State<SetNamePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String _errorMessage = "";

  // Variables para almacenar los valores recibidos de la página anterior
  bool _isAdoptant = false;
  bool _isRescuer = false;

  @override
  Widget build(BuildContext context) {
    // Recibir los argumentos de la página anterior
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Actualizar las variables con los valores recibidos
    if (args != null) {
      _isAdoptant = args['isAdoptant'] ?? false;
      _isRescuer = args['isRescuer'] ?? false;
    }

    return Scaffold(
      appBar: myAppBar(),
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
          // Título principal
          const Padding(
            padding: EdgeInsets.only(bottom: 30.0),
            child: Text(
              'Vamos a completar el perfil',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Subtítulo
          const Padding(
            padding: EdgeInsets.only(bottom: 30.0),
            child: Text(
              '¿Cómo te llamas?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
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
                        // Campo de texto para el primer nombre
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0),
                          child: MyTextField(
                            controller: _firstNameController,
                            hintText: 'Nombre',
                            obscureText: false,
                            validatorFunction: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa tu nombre';
                              }
                              if (value.length < 3) {
                                return 'El nombre debe tener al menos 3 caracteres';
                              }
                              return null;
                            },
                          ),
                        ),
                        // Campo de texto para el apellido
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: MyTextField(
                            controller: _lastNameController,
                            hintText: 'Apellido',
                            obscureText: false,
                            validatorFunction: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa tu apellido';
                              }
                              if (value.length < 3) {
                                return 'El apellido debe tener al menos 3 caracteres';
                              }
                              return null;
                            },
                          ),
                        ),
                        // Botón para continuar
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: .0),
                          child: MyButton(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                String firstName = _firstNameController.text;
                                String lastName = _lastNameController.text;

                                // Limpia el error
                                setState(() {
                                  _errorMessage = "";
                                });
print("firstname: $firstName");
print("lastname: $lastName");
                                // Envía todos los datos, incluyendo las variables booleanas
                                Navigator.pushNamed(
                                  context,
                                  '/set_aboutMe_page',
                                  arguments: {
                                    'firstName': firstName,
                                    'lastName': lastName,
                                    'isAdoptant': _isAdoptant,
                                    'isRescuer': _isRescuer,
                                  },
                                );
                              }
                            },
                            text: 'Continuar',
                            backgroundColor: Colors.black,
                          ),
                        ),
                        // Texto informativo opcional
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 20.0),
                          child: Text(
                            'Usaremos tu nombre para personalizar tu experiencia en la aplicación.',
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
