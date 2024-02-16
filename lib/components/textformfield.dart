import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final dynamic controller;
  final String hintText;
  final String inputError;
  final bool obscureText;

  const MyTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.inputError,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 56, 52, 52)),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Color.fromRGBO(158, 158, 158, 1)),
        ),
        validator: (value) {                                                        // controller.text = value
          if (value == null || value.isEmpty) {
            return inputError;
          }
          return null;
        },
      ),
    );
  }
}
