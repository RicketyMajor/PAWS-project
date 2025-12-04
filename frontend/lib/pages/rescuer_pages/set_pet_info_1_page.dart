// pages/set_pet_info_1_page.dart

import 'package:festymatch_frontend/components/my_appBar.dart';
import 'package:flutter/material.dart';
import '../../components/my_button.dart';
import '../../components/my_drop_down.dart'; // <--- IMPORTACIÓN CRÍTICA: Asegúrate de que el nombre del archivo sea correcto
import '../../components/chile_regions_comunas.dart';
import '../../components/my_drop_down_2.dart'; // Si no lo usas, puedes eliminar esta importación
import '../../components/my_text_field_2.dart';
import '../../components/pet_characteristics.dart';

class SetPetInfo1Page extends StatefulWidget {
  const SetPetInfo1Page({Key? key}) : super(key: key);

  @override
  _SetPetInfo1PageState createState() => _SetPetInfo1PageState();
}

class _SetPetInfo1PageState extends State<SetPetInfo1Page> {
  String _petType = '';
  String _dogSize = '';
  String _petGender = '';
  String? _dogBreed; // Cambiado a String? para manejar el estado inicial sin selección
  String _petAge = '';
  String? _selectedRegion;
  String? _selectedComuna;
  String? description;
  final Color customActiveColor = Color(0xFF8B002D);


  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final String? petName = args?['petName'];
  final TextEditingController _descriptionController = TextEditingController();

    return Scaffold(
      appBar: myAppBar( titleText: 'Cuéntanos acerca de $petName'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // Selección de tipo de mascota
            const Padding(
              padding: EdgeInsets.only(bottom: 10.0, left: 5.0),
              child: Text(
                '¿Qué animal es?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color.fromARGB(255, 157, 150, 150)),
              ),
              child: Column(
                children: petTypes.entries.map((entry) =>
                  RadioListTile<String>(
                    title: Text(entry.value),
                    value: entry.key,
                    groupValue: _petType,
                    activeColor: customActiveColor,
                    onChanged: (value) {
                      setState(() {
                        _petType = value!;
                        // Si se selecciona gato, establecer _dogBreed como null
                        if (_petType != 'dog') {
                          _dogBreed = null;
                        }
                      });
                    },
                  ),
                ).toList(),
              ),
            ),

            // Género de la mascota
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 5.0),
              child: Text(
                'Género de la mascota',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color.fromARGB(255, 157, 150, 150)),
              ),
              child: Column(
                children: petGender.entries.map((entry) =>
                  RadioListTile<String>(
                    title: Text(entry.value),
                    value: entry.key,
                    groupValue: _petGender,
                    activeColor: customActiveColor,
                    onChanged: (value) {
                      setState(() {
                        _petGender = value!;
                      });
                    },
                  )
                ).toList(),
              ),
            ),

            // Opciones de tamaño
            const Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 5.0),
              child: Text(
                'Tamaño de la mascota',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color.fromARGB(255, 157, 150, 150)),
              ),
              child: Column(
                children: petSize.entries.map((entry) =>
                  RadioListTile<String>(
                    title: Text(entry.value),
                    value: entry.key,
                    groupValue: _dogSize,
                    activeColor: customActiveColor,
                    onChanged: (value) {
                      setState(() {
                        _dogSize = value!;
                      });
                    },
                  )
                ).toList(),
              ),
            ),

            // Opciones de raza - Solo mostrar si es perro
            if (_petType == 'perro') ...[
              const Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 5.0),
                child: Text(
                  'Raza de perro',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              MyDropdown2(
                hintText: 'Selecciona una raza',
                value: _dogBreed,
                items: dogBreeds.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _dogBreed = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor selecciona una raza';
                  }
                  return null;
                },
              ),
            ],

            // Campo de selección para la edad
            const Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 5.0),
              child: Text(
                'Edad de la mascota',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color.fromARGB(255, 157, 150, 150)),
              ),
              child: Column(
                children: petAge.entries.map((entry) =>
                  RadioListTile<String>(
                    title: Text(entry.value),
                    value: entry.key,
                    groupValue: _petAge,
                    activeColor: customActiveColor,
                    onChanged: (value) {
                      setState(() {
                        _petAge = value!;
                      });
                    },
                  )
                ).toList(),
              ),
            ),

            // New title for location
            const Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 5.0),
              child: Text(
                '¿Donde vive la mascota?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: MyDropdown( // Asegúrate de usar el nombre correcto aquí
                hintText: 'Selecciona tu Región',
                value: _selectedRegion,
                items: chileRegions.map((region) => DropdownMenuItem<String>(
                  value: region,
                  child: Text(region),
                )).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRegion = newValue;
                    _selectedComuna = null; // Reset comuna when region changes
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
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: MyDropdown( // Asegúrate de usar el nombre correcto aquí
                hintText: 'Selecciona tu Comuna',
                value: _selectedComuna,
                items: _selectedRegion != null
                    ? chileComunas[_selectedRegion]!.map((comuna) => DropdownMenuItem<String>(
                        value: comuna,
                        child: Text(comuna),
                      )).toList()
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
Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: MyTextField2(
    controller: _descriptionController,
    hintText: 'Escribe una  descripción $petName...',
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
    },),
                          ),
            // Botón guardar preferencias
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Center(
                child: MyButton(
                  onTap: () {
                                                    String description = _descriptionController.text;

                    final String? region = _selectedRegion;
                    final String? comuna = _selectedComuna;

                    // Validar selección - ajustar validación para gatos
                    bool isValidForDog = _petType == 'dog' && (_dogBreed == null || _dogBreed!.isEmpty);
                    bool isValidGeneral = _petType.isEmpty || _petGender.isEmpty || _dogSize.isEmpty || _petAge.isEmpty || region == null || comuna == null;
                    
                    if (isValidGeneral || isValidForDog) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor completa todas las preferencias antes de continuar.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                       
                    // Navegar a la siguiente página, pasando los datos
                    Navigator.of(context).pushNamed(
                      '/set_pet_picture_page',
                      arguments: {
                        'petType': _petType,
                        'petGender': _petGender,
                        'dogSize': _dogSize,
                        'dogBreed': _dogBreed, // Será null para gatos
                        'age': _petAge,
                        'region': region,
                        'comuna': comuna,
                        'petName': petName,
                        'description':description
                      },
                    );
                  },
                  text: 'Siguiente',
                ),
              ),
            ),

        
          ]
        ),
      ),
    );
  }
}