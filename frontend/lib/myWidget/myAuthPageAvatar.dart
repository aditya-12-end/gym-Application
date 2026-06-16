import 'package:flutter/material.dart';

class Myauthpageavatar extends StatelessWidget {
  const Myauthpageavatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 130,

      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,

        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 8)),
        ],
      ),

      child: const Icon(Icons.fitness_center, size: 75, color: Colors.white),
    );
  }
}
