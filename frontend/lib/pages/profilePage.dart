import 'package:flutter/material.dart';
import 'package:frontend/integration/auth.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  String? email;
  String? id;
  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      final user = await getUser();
      setState(() {
        email = user["email"];
        id = user["id"];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50),
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 40,
          child: Icon(Icons.person, color: Colors.black, size: 40),
        ),
        Text(
          email ?? "Loading....",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}
