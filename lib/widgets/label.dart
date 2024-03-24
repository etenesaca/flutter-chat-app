import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String routeName;
  final String title;
  final String subtitle;

  const Labels(
      {super.key,
      required this.routeName,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  color: Colors.black54)),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, routeName);
            },
            child: Text(subtitle,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[600])),
          )
        ],
      ),
    );
  }
}
