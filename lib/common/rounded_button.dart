import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final VoidCallback ontap;
  final Color backgroundcolor;
  final Color color;
  const RoundedButton(
    {
    super.key,
    required this.label, 
    required this.ontap, 
    required this.color, 
    this.backgroundcolor = Colors.black,
    });

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: ontap,
      child: Chip(
        label: Text(
          label,
          style:  TextStyle(
            color: color,
            fontSize: 16,
          )
          ,),
        backgroundColor: backgroundcolor,
        labelPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5 ),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(
          left: Radius.circular(20),
          right: Radius.circular(20),
          ),
        ),
    ),
    );
  }
}