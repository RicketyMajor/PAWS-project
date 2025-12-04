import 'package:flutter/material.dart';
import '../../components/my_button.dart';
import '../../components/my_text_field.dart';

class ChangeNameAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChangeNameAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Cambiar nombre",
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

class changeNamePage extends StatefulWidget {
  const changeNamePage({super.key});

  @override
  State<changeNamePage> createState() => _changeNamePageState();
}

class _changeNamePageState extends State<changeNamePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  final TextEditingController _nameControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChangeNameAppBar(),
      body: Center(
        child: Form(
            key: _formKey,
            child: SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.9, // 80% del ancho de la pantalla
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: MyTextField(
                          controller: _nameControler,
                          hintText: 'Nuevo nombre',
                          obscureText: false,
                          validatorFunction: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            if (value.length < 6 || value.length > 20) {
                              return 'El nombre debe tener más de 6 caracteres y menos de 20';
                            }
                            return null;
                          },
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: MyButton(
                        onTap: () async {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (_formKey.currentState!.validate()) {
                            String name = _nameControler.text;

                            // Process data.
                            Navigator.pop(context, '/settings_page');
                          }
                        },
                        text: 'Cambiar nombre',
                      ),
                    ),
                  ]),
            )),
      ),
    );
  }
}
