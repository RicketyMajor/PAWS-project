import 'package:flutter/material.dart';

class MyButton2 extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const MyButton2({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: const Color.fromARGB(16, 0, 0, 0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Espaciado entre texto e ícono
          children: [
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 39, 39, 39),
                fontSize: 16,
              ),
            ),
            const Icon(
              Icons.navigate_next, // Ícono de flecha
              color: Color.fromARGB(255, 47, 47, 47),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
