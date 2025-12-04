import 'package:festymatch_frontend/components/my_appBar.dart';
import 'package:festymatch_frontend/components/my_text_field_2.dart';
import 'package:festymatch_frontend/components/show_snackbar.dart';
import 'package:flutter/material.dart';
import '../../components/my_button.dart';
import '../../components/my_text_field.dart';
import '../../components/my_drop_down.dart';
import '../../components/my_drop_down_2.dart';
import '../../components/chile_regions_comunas.dart';
import '../../components/pet_characteristics.dart';
import '../../services/pet_service.dart';

class EditPetProfilePage extends StatefulWidget {
  final String petId;
  const EditPetProfilePage({super.key, required this.petId});

  @override
  State<EditPetProfilePage> createState() => _EditPetProfilePageState();
}

class _EditPetProfilePageState extends State<EditPetProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _photoUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _petType = '';
  String _petSize = '';
  String _petGender = '';
  String? _petBreed;
  String _petAge = '';
  String? _selectedRegion;
  String? _selectedComuna;
  String _errorMessage = "";
  bool _isLoading = true;
  bool _isSaving = false;

  final Color customActiveColor = Color(0xFF8B002D);

  @override
  void initState() {
    super.initState();
    _loadPetData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _photoUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadPetData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = "";
      });

      final petData = await PetService().fetchPetData(widget.petId);

      if (petData != null) {
        setState(() {
          _nameController.text = petData['name'] ?? '';
          _photoUrlController.text = petData['mainPhotoUrl'] ?? '';
          _descriptionController.text = petData['description'] ?? '';
          _petType = petData['type'] ?? '';
          _petBreed = petData['breed'];
          _petAge = petData['ageCategory'] ?? '';
          _petSize = petData['size'] ?? '';
          _petGender = petData['gender'] ?? '';
          _selectedRegion = petData['locationRegion'];
          _selectedComuna = petData['locationCity'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Error al cargar los datos de la mascota";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error al cargar los datos de la mascota: $e";
        _isLoading = false;
      });
    }
  }

  Future<void> _updatePetProfile() async {
    if (_formKey.currentState!.validate()) {
      // Validación adicional para campos de selección
      if (_petType.isEmpty || _petGender.isEmpty || _petSize.isEmpty || 
          _petAge.isEmpty || _selectedRegion == null || _selectedComuna == null) {
        mySnackBars.showError('Por favor completa todos los campos', context);
        return;
      }

      // Validar raza para perros
      if (_petType == 'dog' && (_petBreed == null || _petBreed!.isEmpty)) {
        mySnackBars.showError('Por favor selecciona una raza para el perro', context);
        return;
      }

      setState(() {
        _isSaving = true;
      });

      try {
        String response = await PetService().updatePetProfile(
          petId: widget.petId,
          name: _nameController.text,
          mainPhotoUrl: _photoUrlController.text,
          type: _petType,
          breed: _petBreed,
          ageCategory: _petAge,
          size: _petSize,
          gender: _petGender,
          locationCity: _selectedComuna!,
          locationRegion: _selectedRegion!,
          description: _descriptionController.text,
        );

        setState(() {
          _isSaving = false;
        });

        if (response == "200" || response == "201") {
          Navigator.pop(context, true);
        } else {
          mySnackBars.showError(response, context);
        }
      } catch (e) {
        setState(() {
          _isSaving = false;
        });
        mySnackBars.showError('Error al actualizar: $e', context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: Stack(
        children: [
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                  child: Text(
                    'Actualizar información de la mascota',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Error message
                              if (_errorMessage.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.red[200]!),
                                  ),
                                  child: Text(
                                    _errorMessage,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                              // Nombre de la mascota
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10.0, left: 5.0),
                                child: Text(
                                  'Nombre de la mascota',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              MyTextField(
                                controller: _nameController,
                                hintText: 'Nombre de la mascota',
                                obscureText: false,
                                validatorFunction: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, ingresa el nombre';
                                  }
                                  if (value.length < 2) {
                                    return 'El nombre debe tener al menos 2 caracteres';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // Foto Principal
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10.0, left: 5.0),
                                child: Text(
                                  'Foto Principal',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: _photoUrlController.text.isNotEmpty
                                        ? Image.network(
                                            _photoUrlController.text,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey[200],
                                                child: const Icon(
                                                  Icons.pets,
                                                  size: 60,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            },
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return Container(
                                                color: Colors.grey[200],
                                                child: const Center(
                                                  child: CircularProgressIndicator(),
                                                ),
                                              );
                                            },
                                          )
                                        : Container(
                                            color: Colors.grey[200],
                                            child: const Icon(
                                              Icons.pets,
                                              size: 60,
                                              color: Colors.grey,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              MyTextField(
                                controller: _photoUrlController,
                                hintText: 'URL de la foto principal',
                                obscureText: false,
                                validatorFunction: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, ingresa la URL de la foto';
                                  }
                                  if (!value.startsWith('http://') && !value.startsWith('https://')) {
                                    return 'Por favor, ingresa una URL válida';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // Tipo de mascota
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
                                          if (_petType != 'dog') {
                                            _petBreed = null;
                                          }
                                        });
                                      },
                                    ),
                                  ).toList(),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Género
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10.0, left: 5.0),
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

                              const SizedBox(height: 20),

                              // Tamaño
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10.0, left: 5.0),
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
                                      groupValue: _petSize,
                                      activeColor: customActiveColor,
                                      onChanged: (value) {
                                        setState(() {
                                          _petSize = value!;
                                        });
                                      },
                                    )
                                  ).toList(),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Raza (solo para perros)
                              if (_petType == 'dog') ...[
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 10.0, left: 5.0),
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
                                  value: _petBreed,
                                  items: dogBreeds.entries.map((entry) {
                                    return DropdownMenuItem<String>(
                                      value: entry.key,
                                      child: Text(entry.value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _petBreed = newValue;
                                    });
                                  },
                                  validator: (value) {
                                    if (_petType == 'dog' && (value == null || value.isEmpty)) {
                                      return 'Por favor selecciona una raza';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                              ],

                              // Edad
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10.0, left: 5.0),
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

                              const SizedBox(height: 20),

                              // Ubicación
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10.0, left: 5.0),
                                child: Text(
                                  '¿Donde vive la mascota?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              
                              // Región
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: MyDropdown(
                                  hintText: 'Selecciona tu Región',
                                  value: _selectedRegion,
                                  items: chileRegions.map((region) => DropdownMenuItem<String>(
                                    value: region,
                                    child: Text(region),
                                  )).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedRegion = newValue;
                                      _selectedComuna = null;
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

                              // Comuna
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: MyDropdown(
                                  hintText: 'Selecciona tu Comuna',
                                  value: _selectedComuna,
                                  items: _selectedRegion != null
                                      ? chileComunas[_selectedRegion]!.map((comuna) => DropdownMenuItem<String>(
                                          value: comuna,
                                          child: Text(comuna),
                                        )).toList()
                                      : [],
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

                              const SizedBox(height: 20),

                              // Descripción
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10.0, left: 5.0),
                                child: Text(
                                  'Descripción de la mascota',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              MyTextField2(
                                controller: _descriptionController,
                                hintText: 'Escribe una descripción de la mascota...',
                                obscureText: false,
                                maxLines: 6,
                                maxLength: 1000,
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

                              const SizedBox(height: 30),

                              // Botón guardar
                              Center(
                                child: MyButton(
                                  onTap: _updatePetProfile,
                                  text: 'Guardar información',
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
          if (_isSaving)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}