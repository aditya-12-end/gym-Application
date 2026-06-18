import 'package:flutter/material.dart';
import 'package:frontend/myWidget/myAuthPageAvatar.dart';
import 'package:frontend/myWidget/myAuthPageCard.dart';
import 'package:frontend/myWidget/myTextButtonForAuth.dart';
import 'package:frontend/pages/loginPage.dart';

class Forgetpasswordpage extends StatefulWidget {
  const Forgetpasswordpage({super.key});

  @override
  State<Forgetpasswordpage> createState() => _ForgetpasswordpageState();
}

class _ForgetpasswordpageState extends State<Forgetpasswordpage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

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
                          t1: "* new Password",
                          t2: "Enter your new-password",
                          controller: password,
                          val: false,
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

                            onPressed: () {},

                            child: const Text(
                              "Change password",
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
