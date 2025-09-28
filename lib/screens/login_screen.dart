import 'package:amritdhara/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'dart:ui'; // Required for ImageFilter.blur

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Using the same gradient style as the home page
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFD4EFFC),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- Logo and App Name ---
                  // Note: Replace 'assets/images/logo.png' with the actual path to your logo asset
                  Image.asset(
                    'assets/images/logo.png',
                    height: 300,
                  ),
                  const SizedBox(height: 40),

                  // --- Email Input Field ---
                  _buildInputField(
                    label: 'EMAIL',
                    hint: 'hello@reallygreatsite.com',
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 20),

                  // --- Password Input Field ---
                  _buildInputField(
                    label: 'PASSWORD',
                    hint: '**************',
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),
                  const SizedBox(height: 40),

                  // --- Log in Button ---
                  _buildLoginButton(context),
                  const SizedBox(height: 24),

                  // --- "OR" Divider ---
                  const Text(
                    'OR',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Log in with Google Button ---
              _buildGoogleLoginButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for TextFields
  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.black45),
            filled: true,
            fillColor: Colors.lightBlue.withOpacity(0.15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
                vertical: 16, horizontal: 20),
          ),
        ),
      ],
    );
  }

  // Helper widget for the main login button
  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: 220, // Set a specific width that isn't too large
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomePage()));
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 8, // A more noticeable shadow
          shadowColor: Colors.blue.withOpacity(0.6),
        ),
        child: Ink(
          decoration: BoxDecoration(
            // New gradient to match the image
            gradient: const LinearGradient(
              colors: [Color(0xFF64B5F6), Color(0xFF1976D2)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            constraints: const BoxConstraints(minHeight: 50),
            alignment: Alignment.center,
            child: const Text(
              'Log in',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for the Google login button
  // Helper widget for the Google login button
  Widget _buildGoogleLoginButton() {
    return ElevatedButton(
      onPressed: () {
        // TODO: Add your Google sign-in logic here
      },
      // Style the button to match the image
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero, // Remove default padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Pill shape
        ),
        elevation: 5, // Add a subtle shadow
        shadowColor: Colors.lightBlue.withOpacity(0.5),
      ),
      child: Ink(
        decoration: BoxDecoration(
          // The gradient background
          gradient: const LinearGradient(
            colors: [
              Color(0xFFE0F7FA), // Light Cyan
              Color(0xFFB2EBF2), // Darker Cyan
            ],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
          constraints: const BoxConstraints(minHeight: 50),
          // Ensure consistent height
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ensure you have the google.png in 'assets/images/'
              // and have declared it in your pubspec.yaml
              Image.asset(
                'assets/images/goggle.png',
                height: 30,
              ),
              const SizedBox(width: 20),
              const Text(
                'Log in with Google',
                style: TextStyle(
                  color: Color(0xFF01579B), // A dark blue color for contrast
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}