import 'package:festymatch_frontend/components/show_snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../components/my_button.dart';
import '../../components/my_text_field.dart';
import '../../services/auth_service.dart';
import 'verification_email_page.dart';

class registerPage extends StatefulWidget {
  const registerPage({super.key});

  @override
  State<registerPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<registerPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  // String _errorMessage = ""; // Ya no necesitas esta variable

  // Función para mostrar el SnackBar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Logo con menos espacio superior
          Padding(
            padding: const EdgeInsets.only(top: 60.0, bottom: 20.0),
            child: Center(
              child: Image.asset(
                'lib/images/paws_logo.png',
                width: 250, // Tamaño reducido para ajustar el diseño
                height: 250,
              ),
            ),
          ),
          Expanded(
            // Formulario más centrado
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
                        // Este SizedBox ya no es necesario para mostrar el mensaje de error
                        // Solo si tienes otro contenido que deba ocupar ese espacio
                        const SizedBox(
                          height: 20, // Altura fija para el espacio
                        ),
                        MyTextField(
                          controller: _emailController,
                          hintText: 'Correo electrónico',
                          obscureText: false,
                          validatorFunction: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa un correo electrónico';
                            }
                            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Por favor, ingresa un correo válido';
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: MyTextField(
                            controller: _passwordController,
                            hintText: 'Contraseña',
                            isPassword: true,
                            obscureText: true,
                            validatorFunction: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa una contraseña';
                              }
                              if (value.length < 8) {
                                return 'La contraseña debe tener más de 8 caracteres';
                              }
                              if (value.length > 25) {
                                return 'La contraseña debe tener menos de 25 caracteres';
                              }
                              return null;
                            },
                          ),
                        ),
                        MyTextField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          hintText: 'Confirma tu contraseña',
                          isPassword: true,
                          validatorFunction: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, confirma tu contraseña';
                            }
                            // No es necesario comparar aquí, ya que la comparación se hace en el servicio
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            children: [
                              MyButton(
                                onTap: () async {
                                  // Asegúrate de que las validaciones de los campos del formulario pasen primero
                                  if (_formKey.currentState!.validate()) {
                                    // Compara las contraseñas antes de llamar al servicio de autenticación
                                    if (_passwordController.text !=
                                        _confirmPasswordController.text) {
                                      mySnackBars.showError(
                                          'Las contraseñas no coinciden',
                                          context);
                                      return; // Detiene la ejecución si las contraseñas no coinciden
                                    }

                                    String email = _emailController.text;
                                    String password = _passwordController.text;
                                    String confirmPassword =
                                        _confirmPasswordController.text;

                                    String response = await AuthService()
                                        .registerUser(
                                            email, password, confirmPassword);

                                    if (response == "201") {
                                      // Registro exitoso, navega a la página de verificación
                                      Navigator.of(context, rootNavigator: true)
                                          .pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              VerificationPage(email: email),
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                    } else {
                                      // Muestra el mensaje de error del backend en un SnackBar
                                      mySnackBars.showError(response, context);
                                    }
                                  }
                                },
                                text: 'Registrarse',
                              ),
                              const SizedBox(height: 10),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text:
                                      'Al hacer clic en Registrarse, aceptas nuestros ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Términos de servicio',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pushNamed(
                                              context, '/terms_of_service');
                                        },
                                    ),
                                    TextSpan(
                                      text: ' y ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Política de privacidad',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pushNamed(
                                              context, '/privacy_policy');
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '¿Ya tienes una cuenta? ',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/login',
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                child: const Text(
                                  'Inicia sesión',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
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
