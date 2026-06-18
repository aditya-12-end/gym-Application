import 'package:flutter/material.dart';

class Myauthpagecard extends StatelessWidget {
  final String t1;
  final String t2;
  final TextEditingController controller;
  final bool val;
  const Myauthpagecard({
    super.key,
    required this.t1,
    required this.t2,
    required this.controller,
    required this.val
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t1, style: TextStyle(color: Colors.white)),
        SizedBox(height: 20),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            label: Text(t2, style: TextStyle(color: Colors.black)),
          ),
          obscureText: val,
        ),
      ],
    );
  }
}
