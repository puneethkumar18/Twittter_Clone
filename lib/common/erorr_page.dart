import 'package:flutter/material.dart';

class ErorrText extends StatelessWidget {
  final String erorrtext;
  const ErorrText({super.key,required this.erorrtext});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(erorrtext),
    );
  }
}

class ErorrPage extends StatelessWidget {
  final String erorrtext;
  const ErorrPage({super.key, required this.erorrtext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ErorrText(erorrtext: erorrtext,),
    );
  }
}