import 'package:flutter/material.dart';
import '../../components/my_button.dart';
import '../../components/my_text_field.dart';

class HousingFormPage extends StatefulWidget {
  const HousingFormPage({super.key});

  @override
  State<HousingFormPage> createState() => _HousingFormPageState();
}

class _HousingFormPageState extends State<HousingFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _housingType = '';
  String _yardSize = '';
  bool _hasOtherPets = false;
  final TextEditingController _otherPetsController = TextEditingController();

  bool _showYardOption = false;
  final Color customActiveColor = Color(0xFF8B002D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Información de Vivienda',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                  child: Text(
                    'Cuéntanos sobre tu hogar',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0, left: 5.0),
                  child: Text(
                    'Tipo de vivienda',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: const Color.fromARGB(255, 157, 150, 150)),
                  ),
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        title: const Text('Casa'),
                        value: 'Casa',
                        groupValue: _housingType,
                        activeColor: customActiveColor,
                        onChanged: (value) {
                          setState(() {
                            _housingType = value!;
                            _showYardOption = true;
                            _yardSize = ''; // No seleccionar automáticamente
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Departamento'),
                        value: 'Departamento',
                        groupValue: _housingType,
                        activeColor: customActiveColor,
                        onChanged: (value) {
                          setState(() {
                            _housingType = value!;
                            _showYardOption = false;
                            _yardSize = '';
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Otro tipo de vivienda'),
                        value: 'Otro',
                        groupValue: _housingType,
                        activeColor: customActiveColor,
                        onChanged: (value) {
                          setState(() {
                            _housingType = value!;
                            _showYardOption = false;
                            _yardSize = '';
                          });
                        },
                      ),
                    ],
                  ),
                ),
                if (_showYardOption) ...[
                  const Padding(
                    padding:
                        EdgeInsets.only(top: 20.0, bottom: 10.0, left: 5.0),
                    child: Text(
                      'Tamaño del patio',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 15.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color.fromARGB(255, 157, 150, 150)),
                    ),
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text('Patio amplio'),
                          value: 'Grande',
                          groupValue: _yardSize,
                          activeColor: customActiveColor,
                          onChanged: (value) {
                            setState(() {
                              _yardSize = value!;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Patio pequeño'),
                          value: 'Pequeño',
                          groupValue: _yardSize,
                          activeColor: customActiveColor,
                          onChanged: (value) {
                            setState(() {
                              _yardSize = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 5.0),
                  child: Text(
                    '¿Tienes otros animales en casa?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: const Color.fromARGB(255, 157, 150, 150)),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Tengo otros animales'),
                        value: _hasOtherPets,
                        activeColor: customActiveColor,
                        onChanged: (bool value) {
                          setState(() {
                            _hasOtherPets = value;
                            if (!value) {
                              _otherPetsController.clear();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                if (_hasOtherPets) ...[
                  const Padding(
                    padding:
                        EdgeInsets.only(top: 20.0, bottom: 10.0, left: 5.0),
                    child: Text(
                      'Describe tus mascotas actuales:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  MyTextField(
                    controller: _otherPetsController,
                    hintText: 'Ejemplo: 2 gatos, 1 perro pequeño...',
                    obscureText: false,
                    validatorFunction: _hasOtherPets
                        ? (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, describe tus mascotas actuales';
                            }
                            return null;
                          }
                        : null,
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Center(
                    child: MyButton(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          if (_housingType.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Por favor, selecciona un tipo de vivienda'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          if (_housingType == 'Casa' && _yardSize.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Por favor, selecciona el tamaño del patio'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          Map<String, dynamic> housingData = {
                            'housingType': _housingType,
                            'yardSize': _housingType == 'Casa'
                                ? _yardSize
                                : 'No aplica',
                            'hasOtherPets': _hasOtherPets,
                            'otherPetsDescription': _hasOtherPets
                                ? _otherPetsController.text
                                : 'Ninguno',
                          };

                          Navigator.pushNamed(
                            context,
                            '/preference_form_page',
                            arguments: housingData,
                          );
                        }
                      },
                      text: 'Guardar y continuar',
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
