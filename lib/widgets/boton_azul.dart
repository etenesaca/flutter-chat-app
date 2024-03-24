import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final Function() onPress;
  final String text;

  const BotonAzul({super.key, required this.onPress, required this.text});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        elevation: 2,
        highlightElevation: 5,
        color: Colors.blue,
        shape: const StadiumBorder(),
        onPressed: onPress,
        child: Container(
          width: double.infinity,
          height: 50,
          child: Center(
            child: Text(text,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        ));
  }
}
