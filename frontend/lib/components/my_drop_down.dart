import 'package:flutter/material.dart';

class MyDropdown extends StatelessWidget {
  final String hintText;
  final String? value;
  final List<DropdownMenuItem<String>>? items;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final TextStyle? itemTextStyle;
  final TextStyle? hintTextStyle; // Added this line

  const MyDropdown({
    Key? key,
    required this.hintText,
    this.value,
    this.items,
    this.onChanged,
    this.validator,
    this.itemTextStyle,
    this.hintTextStyle, // Added this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color.fromARGB(255, 157, 150, 150)),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: hintTextStyle, // Applied the passed style here
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        value: value,
        items: items?.map((item) {
          return DropdownMenuItem<String>(
            value: item.value,
            child: Text(
              item.value!,
              style: itemTextStyle,
            ),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down),
        dropdownColor: Colors.white,
        style: itemTextStyle ?? const TextStyle(color: Colors.black87),
      ),
    );
  }
}
