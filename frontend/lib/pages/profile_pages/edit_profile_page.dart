import 'package:festymatch_frontend/components/my_appBar.dart';
import 'package:festymatch_frontend/components/my_text_field_2.dart';
import 'package:festymatch_frontend/components/show_snackbar.dart';
import 'package:flutter/material.dart';
import '../../components/my_button.dart';
import '../../components/my_text_field.dart';
import '../../components/my_drop_down.dart';
import '../../components/chile_regions_comunas.dart';
import '../../services/profile_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _photoUrlController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();

  String? _selectedRegion;
  String? _selectedComuna;
  String _errorMessage = "";
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _photoUrlController.dispose();
    _aboutMeController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = "";
      });

      final userData = await ProfileService().fetchMyProfileData();

      if (userData != null) {
        setState(() {
          _firstNameController.text = userData['name'] ?? '';
          _lastNameController.text = userData['lastName'] ?? '';
          _photoUrlController.text = userData['profilePictureUrl'] ?? '';
          _aboutMeController.text = userData['aboutMe'] ?? '';
          _selectedRegion = userData['addressRegion'];
          _selectedComuna = userData['addressCity'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Error al cargar los datos del perfil";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error al cargar los datos del perfil: $e";
        _isLoading = false;
      });
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
                    'Actualizar información',
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
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              // Error message
                              SizedBox(
                                height: 20,
                                child: _errorMessage.isNotEmpty
                                    ? Text(
                                        _errorMessage,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                    : null,
                              ),
                              // Profile picture
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Foto Principal',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Center(
                                      child: Container(
                                        width: 200,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Colors.grey[300]!,
                                            width: 2,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: _photoUrlController
                                                  .text.isNotEmpty
                                              ? Image.network(
                                                  _photoUrlController.text,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Container(
                                                      color: Colors.grey[200],
                                                      child: const Icon(
                                                        Icons.person,
                                                        size: 60,
                                                        color: Colors.grey,
                                                      ),
                                                    );
                                                  },
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress == null)
                                                      return child;
                                                    return Container(
                                                      color: Colors.grey[200],
                                                      child: const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Container(
                                                  color: Colors.grey[200],
                                                  child: const Icon(
                                                    Icons.person,
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
                                      hintText: 'URL de la foto de perfil',
                                      obscureText: false,
                                      validatorFunction: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, ingresa la URL de tu foto';
                                        }
                                        if (!value.startsWith('http://') &&
                                            !value.startsWith('https://')) {
                                          return 'Por favor, ingresa una URL válida (http:// o https://)';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              // First name
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Nombre',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    MyTextField(
                                      controller: _firstNameController,
                                      hintText: 'Ingresa tu nombre',
                                      obscureText: false,
                                      validatorFunction: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, ingresa tu nombre';
                                        }
                                        if (value.length < 3) {
                                          return 'El nombre debe tener al menos 3 caracteres';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              // Last name
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Apellido',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    MyTextField(
                                      controller: _lastNameController,
                                      hintText: 'Ingresa tu apellido',
                                      obscureText: false,
                                      validatorFunction: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, ingresa tu apellido';
                                        }
                                        if (value.length < 3) {
                                          return 'El apellido debe tener al menos 3 caracteres';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              // Región
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Región',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    MyDropdown(
                                      hintText: 'Selecciona tu Región',
                                      value: _selectedRegion,
                                      items: chileRegions
                                          .map((region) =>
                                              DropdownMenuItem<String>(
                                                value: region,
                                                child: Text(region),
                                              ))
                                          .toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          _selectedRegion = newValue;
                                          _selectedComuna = null;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, selecciona tu región';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              // Comuna
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Comuna',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    MyDropdown(
                                      hintText: 'Selecciona tu Comuna',
                                      value: _selectedComuna,
                                      items: _selectedRegion != null
                                          ? chileComunas[_selectedRegion]!
                                              .map((comuna) =>
                                                  DropdownMenuItem<String>(
                                                    value: comuna,
                                                    child: Text(comuna),
                                                  ))
                                              .toList()
                                          : [],
                                      onChanged: (newValue) {
                                        setState(() {
                                          _selectedComuna = newValue;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, selecciona tu comuna';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              // About Me
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Sobre mí',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    MyTextField2(
                                      controller: _aboutMeController,
                                      hintText:
                                          'Escribe una breve descripción sobre ti...',
                                      obscureText: false,
                                      maxLines:
                                          6, // <-- permitirá ver hasta 6 líneas antes de hacer scroll
                                      maxLength:
                                          1000, // <-- máximo de caracteres
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
                                  ],
                                ),
                              ),
                              // Botón guardar
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: MyButton(
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _isSaving = true;
                                      });

                                      String response =
                                          await ProfileService().updateProfile(
                                        name: _firstNameController.text,
                                        lastName: _lastNameController.text,
                                        profilePictureUrl:
                                            _photoUrlController.text,
                                        addressCity: _selectedComuna!,
                                        addressRegion: _selectedRegion!,
                                        aboutMe: _aboutMeController.text,
                                      );

                                      setState(() {
                                        _isSaving = false;
                                      });

                                      if (response == "200" ||
                                          response == "201") {
                                        Navigator.pop(context, true);
                                      } else {
                                        mySnackBars.showError(
                                            response, context);
                                      }
                                    }
                                  },
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
