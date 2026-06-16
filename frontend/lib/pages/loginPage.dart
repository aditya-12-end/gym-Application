import 'package:flutter/material.dart';
import 'package:frontend/integration/auth.dart';
import 'package:frontend/myWidget/myAuthPageAvatar.dart';
import 'package:frontend/myWidget/myAuthPageCard.dart';
import 'package:frontend/myWidget/myTextButtonForAuth.dart';
import 'package:frontend/pages/forgetPasswordPage.dart';
import 'package:frontend/pages/landingPage.dart';
import 'package:frontend/pages/registerPage.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  void login() async {
    try {
      await loginUser(email: email.text, password: password.text);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User loggedIn successfully")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Landingpage()),
      );
    } catch (e) {
      print(e.toString());
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
                  "Welcome Back !",
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
                        ),

                        const SizedBox(height: 25),

                        Myauthpagecard(
                          t1: "*Password",
                          t2: "Enter your password",
                          controller: password,
                        ),

                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerRight,

                          child: Mytextbuttonforauth(
                            t1: "Forgot Password?",
                            onpressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Forgetpasswordpage();
                                  },
                                ),
                              );
                            },
                          ),
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
                              login();
                            },

                            child: const Text(
                              "Login",
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
                              "Don't have an account?",
                              style: TextStyle(color: Colors.white70),
                            ),

                            Mytextbuttonforauth(
                              t1: " Create Account",
                              onpressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return Registerpage();
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
