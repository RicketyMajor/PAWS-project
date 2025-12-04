import 'package:festymatch_frontend/components/show_snackbar.dart';
import 'package:festymatch_frontend/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../../components/my_button.dart';
import '../../components/my_text_field.dart';

class changePasswordPage extends StatefulWidget {
  const changePasswordPage({super.key});

  @override
  State<changePasswordPage> createState() => _changePasswordPagePageState();
}

class _changePasswordPagePageState extends State<changePasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambiar contraseña',
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Contraseña actual
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contraseña actual',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      MyTextField(
                        controller: _currentPasswordController,
                        hintText: 'Ingresa tu contraseña actual',
                        obscureText: true,
                        isPassword: true,
                        validatorFunction: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese su contraseña actual';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                // Nueva contraseña
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nueva contraseña',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      MyTextField(
                        controller: _newPasswordController,
                        hintText: 'Ingresa una nueva contraseña',
                        obscureText: true,
                        isPassword: true,
                        validatorFunction: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese una nueva contraseña';
                          }
                          if (value.length < 8) {
                            return 'La contraseña debe tener al menos 8 caracteres';
                          }
                          if (value.length > 25) {
                            return 'La contraseña debe tener menos de 25 caracteres';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                // Confirmación de contraseña
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Confirmar nueva contraseña',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      MyTextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        isPassword: true,
                        hintText: 'Confirma tu nueva contraseña',
                        validatorFunction: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor confirme su contraseña';
                          }
                      
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                // Botón
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: MyButton(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        String currentPassword =
                            _currentPasswordController.text;
                        String newPassword = _newPasswordController.text;
                        String passwordConfirm =
                            _confirmPasswordController.text;
print("current password: $currentPassword");
print("new password:$newPassword");
print("confirm $passwordConfirm");
                        final response = await AuthService().updatePassword(
                          currentPassword,
                          newPassword,
                          passwordConfirm,
                        );

                        if (response == "201") {
                          Navigator.pop(context, '/settings_page');
                        } else {
                          mySnackBars.showError(response, context);
                        }
                      }
                    },
                    text: 'Cambiar contraseña',
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
