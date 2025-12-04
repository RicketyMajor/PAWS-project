import 'package:festymatch_frontend/components/my_appBar.dart';
import 'package:flutter/material.dart';
import '../../components/my_button.dart';
import '../../components/my_text_field.dart';
import '../../components/my_text_field_2.dart';

class SetaboutMePage extends StatefulWidget {
  const SetaboutMePage({super.key});

  @override
  State<SetaboutMePage> createState() => _SetaboutMePageState();
}

class _SetaboutMePageState extends State<SetaboutMePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _aboutMeController = TextEditingController();
  String _errorMessage = "";

  // Variables para almacenar los valores recibidos de la página anterior
String? _firstName;
  String? _lastName;
  bool _isAdoptant = false;
  bool _isRescuer = false;



  @override
  Widget build(BuildContext context) {
    // Recibir los argumentos de la página anterior
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      _firstName = args['firstName'];
      _lastName = args['lastName'];
      _isAdoptant = args['isAdoptant'] ?? false;
      _isRescuer = args['isRescuer'] ?? false;
    }

    return Scaffold(
      appBar: myAppBar(),
      body: Column(
        children: [
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
          const Padding(
            padding: EdgeInsets.only(bottom: 30.0),
            child: Text(
              'Cuéntanos sobre ti',
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: MyTextField2(
    controller: _aboutMeController,
    hintText: 'Escribe una breve descripción sobre ti...',
    obscureText: false,
    maxLines: 6,            // <-- permitirá ver hasta 6 líneas antes de hacer scroll
    maxLength: 1000,        // <-- máximo de caracteres
    validatorFunction: (String? value) {
      if (value == null || value.isEmpty) {
        return 'Por favor, ingresa una descripción';
      }
      if (value.length < 10) {
        return 'La descripción debe tener al menos 10 caracteres';
      }
      if (value.length > 1000) {
        return 'La descripción no puede superar los 1000 caracteres';
      }
      return null;
    },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0),
                          child: MyButton(
                            onTap: () {
                                  print("firstName: $_firstName");
                              print("lastName: $_lastName");
                              if (_formKey.currentState!.validate()) {
                                String aboutMe = _aboutMeController.text;

                                setState(() {
                                  _errorMessage = "";
                                });

                                Navigator.pushNamed(
                                  context,
                                  '/set_location_page',
                                  arguments: {
                                    'firstName':_firstName,
                                    'lastName':_lastName,
                                    'aboutMe': aboutMe,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 20.0),
                          child: Text(
                            '¡Comparte tus intereses, gustos y lo que buscas en esta comunidad!',
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
