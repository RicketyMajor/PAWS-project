import 'package:flutter/material.dart';
import '../pages/adoptant_pages/be_adoptant_page.dart';
import '../pages/adoptant_pages/home_page_adopter.dart';
import '../services/preference_service.dart';
import "../services/profile_service.dart";

class HomeAdopterGate extends StatefulWidget {
  const HomeAdopterGate({Key? key}) : super(key: key);

  @override
  _HomeAdopterGateState createState() => _HomeAdopterGateState();
}

class _HomeAdopterGateState extends State<HomeAdopterGate> {
  bool _isLoading = true; // Estado para controlar si estamos cargando

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final allowed = await PreferenceService().verifyPreferenceCreated();
    if (!allowed) {
      // Reemplazamos la ruta directamente
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const BeAdoptantPage(),
          transitionDuration: Duration.zero,
        ),
      );
    } else {
      // Si está permitido, dejamos de cargar para que se muestre HomePageAdopter
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Mostrar un indicador de carga mientras se verifica el permiso
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      // Si el permiso es concedido y ya no estamos cargando, mostrar HomePageAdopter
      return const HomePageAdopter();
    }
  }
}
