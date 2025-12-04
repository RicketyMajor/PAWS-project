import 'package:flutter/material.dart';
import '../../components/my_button.dart';
import '../../services/auth_service.dart';

class UserPurposePage extends StatefulWidget {
  const UserPurposePage({Key? key}) : super(key: key);

  @override
  _UserPurposePageState createState() => _UserPurposePageState();
}

class _UserPurposePageState extends State<UserPurposePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isAdoptant = false;
  bool _isRescuer = false;
  late bool _initialIsAdoptant;
  late bool _initialIsRescuer;
  final Color customActiveColor = const Color(0xFF8B002D); // Your color
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _initialIsAdoptant = _isAdoptant;
    _initialIsRescuer = _isRescuer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Logo con espacio superior
          Padding(
            padding: const EdgeInsets.only(top: 80.0, bottom: 30.0),
            child: Center(
              child: Image.asset(
                'lib/images/paws_logo.png', // Replace with your logo path
                width: 200,
                height: 200,
              ),
            ),
          ),
          // Título de la página
          const Padding(
            padding: EdgeInsets.only(bottom: 30.0),
            child: Text(
              '¿Qué buscas hacer en Paws?',
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
                        // Propósito del usuario (Checkboxes)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 157, 150, 150)),
                            ),
                            child: Column(
                              children: [
                                CheckboxListTile(
                                  title: const Text('Adoptar una mascota'),
                                  value: _isAdoptant,
                                  activeColor: customActiveColor,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isAdoptant = value!;
                                    });
                                  },
                                ),
                                CheckboxListTile(
                                  title: const Text('Dar en adopción mascotas'),
                                  value: _isRescuer,
                                  activeColor: customActiveColor,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isRescuer = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Botón para continuar
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: MyButton(
                          
                            onTap: () async {
                              if (_isAdoptant != _initialIsAdoptant ||
                                  _isRescuer != _initialIsRescuer) {
                                Navigator.pushNamed(
                                  context,
                                  '/set_name_page',
                                  arguments: {
                                    'isAdoptant': _isAdoptant,
                                    'isRescuer': _isRescuer,
                                  },
                                );
                              } else {
                                setState(() {
                                  _errorMessage =
                                      "Por favor, selecciona alguna opción para continuar.";
                                });
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
                            'Selecciona tu propósito para que podamos personalizar tu experiencia.',
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
