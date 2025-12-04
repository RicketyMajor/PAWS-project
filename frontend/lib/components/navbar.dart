import 'package:flutter/material.dart';

// Importaciones necesarias para las páginas mencionadas
import '../gates/home_adopter_gate.dart';
import '../gates/home_rescuer_gate.dart';
import '../pages/profile_pages/profile_page.dart';
import '../pages/auth_pages/chat_list_page.dart';

/// Clase que implementa la barra de navegación reutilizables
class NavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int, BuildContext)? onTap;

  const NavBar({
    Key? key,
    required this.currentIndex,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Material(
          // El Material widget aplica el theme a sus hijos
          color: Colors.transparent,
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) =>
                (onTap ?? NavBarNavigation.defaultNavigation)(index, context),
            backgroundColor: Colors.white,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,

            // El BottomNavigationBar no tiene estas propiedades directamente
            items: [
              BottomNavigationBarItem(
                icon: currentIndex == 0
                    ? Icon(Icons.pets)
                    : SizedBox(
                        width: 24,
                        height: 24,
                        child: Image.asset('lib/images/pets_outlined.png'),
                      ),
                label: 'Mascotas',
              ),
              BottomNavigationBarItem(
                icon:
                    Icon(currentIndex == 1 ? Icons.home : Icons.home_outlined),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                    currentIndex == 2 ? Icons.message : Icons.message_outlined),
                label: 'Mensajes',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                    currentIndex == 3 ? Icons.person : Icons.person_outlined),
                label: 'Perfil',
              ),
            ],
          ),
        ));
  }
}

class NavBarNavigation {
  static void defaultNavigation(int index, BuildContext context) async {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomeRescuerGate(),
            transitionDuration: Duration.zero,
          ),
        );
        break;

      case 1:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomeAdopterGate(),
            transitionDuration: Duration.zero,
          ),
        );

        break;

      case 2:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ChatListPage(),
            transitionDuration: Duration.zero,
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ProfilePage(),
            transitionDuration: Duration.zero,
          ),
        );
        break;
    }
  }
}
