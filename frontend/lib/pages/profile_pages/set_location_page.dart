import 'package:flutter/material.dart';
import '../../components/my_appBar.dart';
import '../../components/my_button.dart';
import '../../components/my_drop_down.dart';
import '../../components/chile_regions_comunas.dart';

class SetLocationPage extends StatefulWidget {
  const SetLocationPage({super.key});

  @override
  State<SetLocationPage> createState() => _SetLocationPageState();
}

class _SetLocationPageState extends State<SetLocationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedRegion;
  String? _selectedComuna;
  String _errorMessage = "";

  // Variables para almacenar datos del usuario
  String? _firstName;
  String? _lastName;
    String? _aboutMe;

  bool _isAdoptant = false;
  bool _isRescuer = false;

  @override
  Widget build(BuildContext context) {
    // Obtener los argumentos recibidos
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    // Actualizar las variables con los valores recibidos
    if (args != null) {
      _aboutMe=args['aboutMe'];
      _firstName = args['firstName'];
      _lastName = args['lastName'];
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
              '¿Dónde vives?',
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
                        // Dropdown para Región
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: MyDropdown(
                            hintText: 'Selecciona tu Región',
                            value: _selectedRegion,
                            items: chileRegions
                                .map((region) => DropdownMenuItem<String>(
                                      value: region,
                                      child: Text(region),
                                    ))
                                .toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedRegion = newValue;
                                _selectedComuna =
                                    null; // Reset comuna when region changes
                              });
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, selecciona tu región';
                              }
                              return null;
                            },
                          ),
                        ),
                        // Dropdown para Comuna
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0),
                          child: MyDropdown(
                            hintText: 'Selecciona tu Comuna',
                            value: _selectedComuna,
                            items: _selectedRegion != null
                                ? chileComunas[_selectedRegion]!
                                    .map((comuna) => DropdownMenuItem<String>(
                                          value: comuna,
                                          child: Text(comuna),
                                        ))
                                    .toList()
                                : [], // Empty list if no region selected
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedComuna = newValue;
                              });
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, selecciona tu comuna';
                              }
                              return null;
                            },
                          ),
                        ),
                        // Botón para continuar
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: MyButton(
                            onTap: () {
                           
                              if (_formKey.currentState!.validate()) {
                                // Obtener datos de ubicación
                                final String? region = _selectedRegion;
                                final String? comuna = _selectedComuna;
                                   print(_aboutMe);
                              print("firstName: $_firstName");
                              print("lastName: $_lastName");
                              print("region: $region");

                                // Navegar a la página de foto de perfil, pasando todos los datos
                                Navigator.pushNamed(
                                  context,
                                  '/set_profile_picture_page',
                                  arguments: {
                                    'aboutMe': _aboutMe,
                                    'firstName': _firstName,
                                    'lastName': _lastName,
                                    'region': region,
                                    'comuna': comuna,
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
                            'Necesitamos tu ubicación para personalizar tu experiencia en la aplicación.',
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
