import 'package:festymatch_frontend/components/my_appBar.dart';
import 'package:flutter/material.dart';
import '../../components/pet_preferences.dart';
import '../../components/show_snackbar.dart';
import '../../gates/home_adopter_gate.dart';
import '../../components/my_button.dart';
import '../../services/preference_service.dart';
import '../../services/profile_service.dart';

class PreferencesFormPage extends StatefulWidget {
  const PreferencesFormPage({Key? key}) : super(key: key);

  @override
  _PreferencesFormPageState createState() => _PreferencesFormPageState();
}

class _PreferencesFormPageState extends State<PreferencesFormPage> {
  String preferredPetType = '';
  String preferredPetSize = '';
  String preferredPetAge = '';
  String preferredPetGender = '';
  final Color customActiveColor = Color(0xFF8B002D); // Your color
  bool _isLoading = false; // Added to manage loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(), // La AppBar se mostrará aquí
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
              left: 20.0, right: 20.0, bottom: 20.0), // **Eliminado top: 60.0**
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                    top: 10.0,
                    bottom:
                        20.0), // Puedes ajustar este padding si necesitas espacio desde la AppBar
                child: Text(
                  'Dinos tus preferencias de mascotas',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0, left: 5.0),
                child: Text(
                  'Mascota preferida',
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
                  children: preferencesTypesOptions.entries.map((entry) {
                    return RadioListTile<String>(
                      title: Text(entry.value),
                      value: entry.key,
                      groupValue: preferredPetType,
                      activeColor: customActiveColor,
                      onChanged: (value) {
                        setState(() {
                          preferredPetType = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 5.0),
                child: Text(
                  'Edad de la mascota preferida',
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
                  children: preferencesAgeOptions.entries.map((entry) {
                    return RadioListTile<String>(
                      title: Text(entry.value),
                      value: entry.key,
                      groupValue: preferredPetAge,
                      activeColor: customActiveColor,
                      onChanged: (value) {
                        setState(() {
                          preferredPetAge = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 5.0),
                child: Text(
                  'Género de la mascota preferida',
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
                  children: preferencesGenderOptions.entries.map((entry) {
                    return RadioListTile<String>(
                      title: Text(entry.value),
                      value: entry.key,
                      groupValue: preferredPetGender,
                      activeColor: customActiveColor,
                      onChanged: (value) {
                        setState(() {
                          preferredPetGender = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 5.0),
                child: Text(
                  'Tamaño de mascota preferido',
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
                  children: preferencesPetSize.entries.map((entry) {
                    return RadioListTile<String>(
                      title: Text(entry.value),
                      value: entry.key,
                      groupValue: preferredPetSize,
                      activeColor: customActiveColor,
                      onChanged: (value) {
                        setState(() {
                          preferredPetSize = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : MyButton(
                          onTap: () async {
                            bool isFormValid = preferredPetType.isNotEmpty &&
                                preferredPetAge.isNotEmpty &&
                                preferredPetGender.isNotEmpty &&
                                preferredPetSize.isNotEmpty;
                                 
                            if (!isFormValid) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Por favor completa todas las preferencias antes de continuar.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            setState(() {
                              _isLoading = true;
                            });
                            bool createdPreference = await PreferenceService().verifyPreferenceCreated();
                           String response="ola";
                             if(createdPreference==false){

                             response =
                                await PreferenceService().createPreference(
                              preferredPetType,
                              preferredPetSize,
                              preferredPetAge,
                              preferredPetGender,
                            );
                             }
                             else{
                               response =
                                await PreferenceService().changePreference(
                              preferredPetType,
                              preferredPetSize,
                              preferredPetAge,
                              preferredPetGender,
                            );
                             }
                             print(response);
                            if (response == "201") {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      HomeAdopterGate(),
                                  transitionDuration: Duration.zero,
                                ),
                              );
                            } else {
                              mySnackBars.showError(response, context);
                            }
                          },
                          text: 'Guardar preferencias',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
