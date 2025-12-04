import 'package:festymatch_frontend/components/show_snackbar.dart';
import 'package:flutter/material.dart';
import '../../components/my_appBar.dart';
import '../../components/my_button.dart';
import '../../components/my_text_field.dart';
import '../../services/profile_service.dart';

class SetProfilePicturePage extends StatefulWidget {
  const SetProfilePicturePage({super.key});

  @override
  State<SetProfilePicturePage> createState() => _SetProfilePicturePageState();
}

class _SetProfilePicturePageState extends State<SetProfilePicturePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _photoUrlController = TextEditingController();
  String _errorMessage = "";
  bool _isLoading = false; // Para mostrar un indicador de carga

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final String firstName = args?['firstName'];
    final String lastName = args?['lastName'];
        final String aboutMe = args?['aboutMe'];

    final String addressRegion = args?['region'];
    final String addressCity = args?['comuna'];
    final bool isAdopter = args?['isAdoptant'] ?? false;
    final bool isRescuer = args?['isRescuer'] ?? false;

    return Scaffold(
      appBar: myAppBar(),
      body: Stack(
        children: [
          Column(
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
                  'Sube tu foto de perfil',
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 0.0),
                              child: MyTextField(
                                controller: _photoUrlController,
                                hintText: 'Ingresa la URL de tu foto',
                                obscureText: false,
                                validatorFunction: (String? value) {
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
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: MyButton(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    String profilePictureUrl =
                                        _photoUrlController.text;
                                    String response =
                                        await ProfileService().createProfile(
                                      firstName,
                                      lastName,
                                      profilePictureUrl,
                                      addressCity,
                                      addressRegion,
                                      aboutMe,
                                      isAdopter,
                                      isRescuer,
                                    );

                                    if (response == "201") {
                                      if (isAdopter == true &&
                                          isRescuer == false) {
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          '/preference_form_page',
                                          (Route<dynamic> route) => false,
                                        );
                                      } else if (isRescuer == true &&
                                          isAdopter == false) {
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          '/set_pet_name_page',
                                          (Route<dynamic> route) => false,
                                        );
                                      } else if (isRescuer == true &&
                                          isAdopter == true) {
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          '/profile_page',
                                          (Route<dynamic> route) => false,
                                        );
                                      }
                                    } else {
                                      mySnackBars.showError(response, context);
                                    }
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
                                'Sube una foto para que otros puedan reconocerte.',
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
          if (_isLoading)
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
