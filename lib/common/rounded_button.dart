import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final VoidCallback ontap;
  final Color backgroundcolor;
  const RoundedButton({
    super.key,
    required this.label, 
    required this.backgroundcolor,
    required this.ontap,
    });

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: ontap,
      child: Chip(
        label: Text(
          label,
          style: const  TextStyle(
            color: Colors.black,
            fontSize: 16,
          )
          ,),
        backgroundColor: backgroundcolor,
        labelPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
        ),
    );
  }
}