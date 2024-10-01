import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFields extends StatelessWidget {
  TextEditingController controller;
  String? hintText;
  String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  TextFormFields(
      {super.key,
      required this.controller,
      this.validator,
      required this.hintText,
      this.keyboardType = TextInputType.text,
      this.inputFormatters});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 223, 207, 207)),
            borderRadius: BorderRadius.circular(28),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(28)),
          filled: false,
          hintText: hintText,
          hintStyle:
              const TextStyle(color: Color.fromARGB(255, 223, 207, 207))),
      style: const TextStyle(color: Color.fromARGB(255, 223, 207, 207)),
      validator: validator,
      inputFormatters: inputFormatters,
    );
  }
}
