import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taskmate/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration:const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 35, 92, 99), // Dark blue
              Color.fromRGBO(129, 199, 132, 1), // Light green
              Color.fromRGBO(178, 255, 218, 1), // Pale green
            ],
          ),
        ),
        child:const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              maxRadius: 60,

              foregroundImage: AssetImage('assets/images/taskmate_logo.png'),
            ),
            SizedBox(height: 15),
            Text(
              "Get things done, one task at a time.",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
