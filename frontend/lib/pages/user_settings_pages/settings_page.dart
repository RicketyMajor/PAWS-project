import 'package:festymatch_frontend/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:festymatch_frontend/components/my_button_2.dart';
import 'package:festymatch_frontend/components/my_button.dart';

class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SettingsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Ajustes",
        style: TextStyle(color: Colors.black), // Texto negro
      ),
      backgroundColor: Colors.white, // Fondo blanco
      elevation: 0, // Sin sombra
      iconTheme: const IconThemeData(color: Colors.black), // Íconos negros
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const SettingsAppBar(),
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            // Aquí se agrega el Center para centrar el contenido
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    // Espacio de 16 píxeles entre los botones
                    MyButton2(
                      onTap: () {
                        Navigator.pushNamed(context, '/change_name');
                      },
                      text: "Cambiar nombre",
                    ),
                    const SizedBox(
                        height: 16), // Espacio de 16 píxeles entre los botones
                    MyButton2(
                      onTap: () {
                        Navigator.pushNamed(context, '/change_password');
                      },
                      text: "Cambiar contraseña",
                    ),
                    const SizedBox(
                        height: 580), // Este espacio está bastante grande
                    MyButton(
                      onTap: () async {
                        await AuthService().logout();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/register', // Reemplaza '/register' con tu ruta inicial
                          (Route<dynamic> route) => false,
                        );
                      },
                      text: 'Cerrar sesión',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
