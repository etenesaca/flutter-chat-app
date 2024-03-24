import 'package:flutter/material.dart';

class UsuariosScreen extends StatelessWidget {
   
  static const routeName = 'Usuarios';
  const UsuariosScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios')),
      body: Center(
         child: Text('UsuariosScreen'),
      ),
    );
  }
}