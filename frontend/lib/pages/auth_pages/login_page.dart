import 'package:festymatch_frontend/components/show_snackbar.dart';
import 'package:festymatch_frontend/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../gates/home_adopter_gate.dart';
import '../../components/my_button.dart';
import '../../components/my_text_field.dart';
import '../../services/auth_service.dart';
import 'verification_email_page.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<loginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage =
      FlutterSecureStorage(); // Instancia para guardar datos de forma segura
  String _errorMessage = ""; // Variable para almacenar el mensaje de error

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Logo en la parte superior con espacio controlado
          Padding(
            padding: const EdgeInsets.only(top: 60.0, bottom: 20.0),
            child: Center(
              child: Image.asset(
                'lib/images/paws_logo.png',
                width: 250,
                height: 250,
              ),
            ),
          ),
          Expanded(
            // Formulario centrado con desplazamiento si es necesario
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
                          height: 20, // Altura fija para el mensaje de error
                          child: _errorMessage.isNotEmpty
                              ? Text(
                                  _errorMessage,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.left,
                                )
                              : null,
                        ),
                        MyTextField(
                          controller: _emailController,
                          hintText: 'Email',
                          obscureText: false,
                          validatorFunction: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa tu correo electrónico';
                            }
                            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Por favor, ingresa un email válido';
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: MyTextField(
                            controller: _passwordController,
                            hintText: 'Contraseña',
                            obscureText: true,
                            validatorFunction: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa tu contraseña';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: MyButton(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                final email = _emailController.text;
                                final password = _passwordController.text;
                                final authenticated = await AuthService()
                                    .loginUser(email, password);
print(authenticated);
                                final _userData = await ProfileService()
                                    .verifyProfileCreated();

                                if (_userData == 404) {
                                  Navigator.pushReplacementNamed(
                                      context, '/user_purpose_page');
                                } else if (authenticated == "201") {
                                   Navigator.pushReplacementNamed(
                                      context, '/profile_page');
                                  ProfileService().fetchMyProfileData();
                                  setState(() {
                                    _errorMessage = ""; // Limpia el error
                                  });
                                  Navigator.of(context, rootNavigator: true)
                                      .pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => HomeAdopterGate(),
                                    ),
                                    (Route<dynamic> route) => false,
                                  );
                                } else if (authenticated == "409") {
                                  setState(() {
                                    _errorMessage = ""; // Limpia el error
                                  });
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          VerificationPage(email: email),
                                    ),
                                  );
                                } else {
                                  mySnackBars.showError(authenticated, context);
                                }
                              }
                            },
                            text: 'Iniciar sesión',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '¿No tienes cuenta? ',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/register', // Reemplaza '/register' con tu ruta inicial
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                child: Text(
                                  'Regístrate',
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
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
