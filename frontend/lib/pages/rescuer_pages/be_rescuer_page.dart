import 'package:flutter/material.dart';
import '../../components/my_button_3.dart';
import '../../components/navbar.dart';

class BeRescuerPage extends StatelessWidget {
  const BeRescuerPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Logo en la parte superior
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Image.asset(
                'lib/images/paws_logo.png',
                width: 200,
                height: 200,
              ),
            ),
            // Espacio flexible para separar logo y botón
            const Spacer(flex: 2),
            // Botón centrado vertical y horizontalmente
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: MyButton3(
                  onTap: () {
                    Navigator.pushNamed(context, '/set_pet_name_page');
                  },
                  text: 'Quiero dar en adopcion una mascota',
                ),
              ),
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(currentIndex: 0),
    );
  }
}
