import 'package:flutter/material.dart';
import 'package:frontend/integration/auth.dart';
import 'package:frontend/myWidget/myAuthPageAvatar.dart';
import 'package:frontend/myWidget/myAuthPageCard.dart';
import 'package:frontend/myWidget/myTextButtonForAuth.dart';
import 'package:frontend/pages/loginPage.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  void register() async {
    try {
      await registerUser(email: email.text, password: password.text);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User created successfully")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Loginpage()),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),

            child: Column(
              children: [
                const SizedBox(height: 40),

                Myauthpageavatar(),

                const SizedBox(height: 30),

                const Text(
                  "Start your journey !",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 45),

                Card(
                  elevation: 10,

                  shadowColor: Colors.black,

                  color: Colors.black,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(24.0),

                    child: Column(
                      children: [
                        Myauthpagecard(
                          t1: "*Email",
                          t2: "Enter your email",
                          controller: email,
                          val: false,
                        ),

                        const SizedBox(height: 25),

                        Myauthpagecard(
                          t1: "*Password",
                          t2: "Enter your password",
                          controller: password,
                          val: true,
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 55,

                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,

                              elevation: 5,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),

                            onPressed: () {
                              register();
                            },

                            child: const Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(color: Colors.white70),
                            ),

                            Mytextbuttonforauth(
                              t1: " Login your Account",
                              onpressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return Loginpage();
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
