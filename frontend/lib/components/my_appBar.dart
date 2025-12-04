import 'package:flutter/material.dart';

class myAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? titleText; // Título opcional
  final List<Widget>? actions; // Acciones opcionales

  const myAppBar({
    Key? key,
    this.titleText,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      // **¡Elimina la propiedad 'leading' por completo!**
      // Flutter se encargará de mostrar la flecha si es necesario.
      // Puedes, opcionalmente, poner automaticallyImplyLeading: true,
      // pero es el valor por defecto, así que no es estrictamente necesario.
      // automaticallyImplyLeading: true,

      title: titleText != null // Si el título no es nulo, lo mostramos
          ? Text(
              titleText!,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold, // Título en negrita
              ),
            )
          : null, // Si titleText es nulo, no se muestra ningún widget de título

      actions: actions, // Agrega las acciones si existen
      centerTitle: true, // Centra el título si lo deseas
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
