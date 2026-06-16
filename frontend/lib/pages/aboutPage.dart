import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Aboutpage extends StatefulWidget {
  const Aboutpage({super.key});

  @override
  State<Aboutpage> createState() => _AboutpageState();
}

class _AboutpageState extends State<Aboutpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("About", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    "Aditya Bhatt",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Flutter Developer & Fitness Enthusiast",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade400),
                  ),

                  const SizedBox(height: 15),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.email, color: Colors.white),
                    title: const Text(
                      "adibhatt280906@gmail.com",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.link, color: Colors.white),
                    title: GestureDetector(
                      child: Text(
                        "linkedin.com/in/your-profile",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.start,
                      ),
                      onTap: () {
                        openLinkedIn();
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "About App",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              "Transform your fitness journey with a powerful yet minimalist fitness application designed to help you stay consistent, motivated, and in control of your health. Whether you're a beginner or an experienced fitness enthusiast, the app provides all the essential tools needed to achieve your fitness goals.",
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 15,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Key Features",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            buildFeature(
              Icons.fitness_center,
              "Workout Planner",
              "Create and manage personalized workout schedules.",
            ),

            buildFeature(
              Icons.person_outline,
              "Personalized Experience",
              "Customize plans according to your fitness goals.",
            ),

            buildFeature(
              Icons.monitor_weight_outlined,
              "BMI Calculator",
              "Track your BMI and understand your health status.",
            ),

            buildFeature(
              Icons.local_fire_department,
              "Motivation System",
              "Stay consistent through streaks and achievements.",
            ),

            buildFeature(
              Icons.analytics_outlined,
              "Progress Tracking",
              "Monitor your fitness improvements over time.",
            ),

            buildFeature(
              Icons.palette_outlined,
              "Minimalist Design",
              "Clean, distraction-free and user-friendly interface.",
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                "Our mission is to make fitness simple, accessible, and sustainable. Every workout completed is a step toward becoming a healthier and stronger version of yourself.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget buildFeature(IconData icon, String title, String subtitle) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade400)),
      ),
    );
  }
}

Future<void> openLinkedIn() async {
  final Uri url = Uri.parse(
    "https://www.linkedin.com/in/aditya-bhatt-b539a2377/",
  );
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}
