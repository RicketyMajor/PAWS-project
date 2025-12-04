import 'dart:async';
import 'package:festymatch_frontend/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../../components/my_button.dart';
import '../../components/my_text_field.dart';

class VerificationPage extends StatefulWidget {
  final String email;

  const VerificationPage({Key? key, required this.email}) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _codeController = TextEditingController();
  String _errorMessage = "";
  bool _isResendEnabled = true;
  int _timerCountdown = 0;
  Timer? _timer;

  void _startTimer() {
    setState(() {
      _isResendEnabled = false;
      _timerCountdown = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerCountdown > 0) {
          _timerCountdown--;
        } else {
          _isResendEnabled = true;
          _timer?.cancel();
        }
      });
    });
  }

  void _resendCode() async {
    // Simula el envío de un código
    AuthService().sendVerificationCode(widget.email);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Logo en la parte superior
          Padding(
            padding: const EdgeInsets.only(top: 60.0, bottom: 20.0),
            child: Center(
              child: Image.asset(
                'lib/images/paws_logo.png',
                width: 250, // Tamaño del logo
                height: 250,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Espacio para mostrar mensajes de error
                          if (_errorMessage.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                _errorMessage,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          Text(
                            "Se ha enviado un código de verificación al correo electrónico: ${widget.email}. Ingresa el código a continuación y presiona verificar.",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          MyTextField(
                            controller: _codeController,
                            hintText: "Código de verificación",
                            obscureText: false,
                          ),
                          const SizedBox(height: 20),
                          MyButton(
                            onTap: () async {
                              final email = widget.email;
                              final code = _codeController.text.trim();

                              // Verificar que el campo de código no esté vacío
                              if (code.isEmpty) {
                                setState(() {
                                  _errorMessage =
                                      "Por favor, ingresa el código.";
                                });
                                return;
                              }

                              // Llamar al servicio de verificación
                              final success = await AuthService()
                                  .verificationEmail(email, code);
                                  
                              if (success == "201") {
                                // Redirigir o mostrar mensaje de éxito
                                setState(() {
                                  _errorMessage = "Verificación exitosa.";
                                });
                                Navigator.pushReplacementNamed(
                                    context, '/user_purpose_page');
                              } else {
                                setState(() {
                                  _errorMessage =
                                      "Código incorrecto. Inténtalo de nuevo.";
                                });
                              }
                            },
                            text: "Verificar",
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: _isResendEnabled ? _resendCode : null,
                            child: Text(
                              _isResendEnabled
                                  ? "Reenviar código"
                                  : "Reenviar código (${_timerCountdown}s)",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: _isResendEnabled
                                    ? Colors.blue
                                    : Colors.grey,
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
        ],
      ),
    );
  }
}
