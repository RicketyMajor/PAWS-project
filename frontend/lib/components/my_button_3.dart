import 'package:flutter/material.dart';

class MyButton3 extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color? backgroundColor; // Add backgroundColor

  const MyButton3({
    Key? key,
    required this.onTap,
    required this.text,
    this.backgroundColor, // Make it optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.84,
        padding: const EdgeInsets.all(13),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color:
              backgroundColor ?? Colors.black, // Use provided color or default
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
