import 'package:flutter/material.dart';
import '../pages/rescuer_pages/home_page_rescue.dart';
import '../pages/rescuer_pages/be_rescuer_page.dart';
import "../services/pet_service.dart";

class HomeRescuerGate extends StatefulWidget {
  const HomeRescuerGate({Key? key}) : super(key: key);

  @override
  _HomeRescuerGateState createState() => _HomeRescuerGateState();
}

class _HomeRescuerGateState extends State<HomeRescuerGate> {
  bool _isLoading = true; // Indica si estamos esperando la verificación

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final allowed = await PetService().verifyPetCreated();
    if (!allowed) {
      // Si no está permitido, reemplazamos la ruta
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const BeRescuerPage(),
          transitionDuration: Duration.zero,
        ),
      );
    } else {
      // Si está permitido, actualizamos el estado para mostrar HomePageRescue
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Muestra un indicador de carga mientras se verifica el permiso
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      // Si el permiso es concedido y ya no estamos cargando, muestra la página principal del rescatista
      return const HomePageRescue();
    }
  }
}
