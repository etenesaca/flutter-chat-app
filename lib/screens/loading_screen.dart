import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  static const routeName = 'Loading';
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loading')),
      body: Center(
        child: Text('LoadingScreen'),
      ),
    );
  }
}
