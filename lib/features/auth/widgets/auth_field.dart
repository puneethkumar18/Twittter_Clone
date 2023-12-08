import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hinttext;
  const AuthField({
    super.key, 
  required this.controller,
  required this.hinttext,
  });

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
        controller: controller,
        decoration:  InputDecoration(
          hintText: hinttext,
          hintStyle: const TextStyle(fontSize: 16 ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white54,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 3,
              color: Colors.blue,
            ),
          ),
        ),
      );
    
  }
}