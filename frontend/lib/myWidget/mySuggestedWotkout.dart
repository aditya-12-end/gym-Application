import 'package:flutter/material.dart';

class Mysuggestedwotkout extends StatelessWidget {
  final String title;
  final String subititle;
  final IconData icon;
  const Mysuggestedwotkout({
    super.key,
    required this.title,
    required this.subititle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
        leading: Icon(icon, color: Colors.white, size: 40),
        subtitle: Row(
          children: [
            SizedBox(width: 5),
            Text(
              subititle,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        tileColor: const Color.fromARGB(255, 24, 24, 24),
        title: Row(
          children: [
            SizedBox(width: 5),
            Text(title, style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
