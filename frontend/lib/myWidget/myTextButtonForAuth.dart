import 'package:flutter/material.dart';

class Mytextbuttonforauth extends StatelessWidget {
  final String t1;
  final void Function()? onpressed ;

  const Mytextbuttonforauth({super.key,required this.t1,required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed:onpressed,
      child: Text(t1, style: TextStyle(color: Colors.white)),
    );
  }
}
