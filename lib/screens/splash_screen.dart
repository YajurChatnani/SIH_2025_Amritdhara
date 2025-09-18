// lib/screens/splash_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import the home screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Layer 1: The background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFD4EFFC),
                  Color(0xFFD3D3D3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.7],
              ),
            ),
          ),

          // Layer 2: Your content with tweaked proportions
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Spacer(flex: 1),

                  Expanded(
                    flex: 10, 
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo's size is stable due to fixed height
                        Image.asset(
                          "assets/images/logo.png",
                          height: screenHeight * 0.20,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 15),
                        // This will now expand to fill the new, larger space
                        Expanded(
                          child: Image.asset(
                            "assets/images/illustration.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 1),

                  Image.asset(
                    "assets/images/safe.png",
                    width: screenWidth * 0.9,
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}