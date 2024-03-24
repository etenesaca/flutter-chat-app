import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  const CustomInput(
      {super.key,
      required this.icon,
      required this.placeholder,
      required this.textController,
      this.keyboardType = TextInputType.text,
      this.isPassword = false});

  final IconData icon;
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 50),
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 5),
                  blurRadius: 5)
            ]),
        child: Column(
          children: [
            Container(
                child: TextField(
              obscureText: isPassword,
              controller: textController,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  prefixIcon: Icon(icon),
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  hintText: placeholder),
            )),
          ],
        ));
  }
}
