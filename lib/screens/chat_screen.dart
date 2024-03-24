import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = 'Char';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Char')),
      body: Center(
        child: Text('CharScreen'),
      ),
    );
  }
}
