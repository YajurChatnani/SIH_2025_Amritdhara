import 'package:amritdhara/screens/user_input_screen.dart';
import 'package:flutter/material.dart';
import 'report_screen.dart';
import 'chat_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF012A4A)),
          onPressed: () {},
        ),
        title: const Text(
          'AMRITDHARA',
          style: TextStyle(
            color: Color(0xFF012A4A),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                // Handle profile icon tap
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(0.15),
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF012A4A),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFD4EFFC),
              Color(0xFFD3D3D3),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.7, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: kToolbarHeight + MediaQuery.of(context).padding.top + 10),
                const Text(
                  'Good Morning,',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black54,
                  ),
                ),
                const Text(
                  'John',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF012A4A),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(
                      color: const Color(0xFF012A4A),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22.0),
                    child: Image.asset(
                      'assets/images/map.png',
                      fit: BoxFit.cover,
                      height: 180,
                      width: double.infinity,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Container(
                      width: 5,
                      height: 28,
                      color: const Color(0xFF012A4A),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'QUICK ACCESS',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 16.0,
                  runSpacing: 16.0,
                  children: [
                    // --- UPDATED: Added onTap for navigation ---
                    _QuickAccessCard(
                      text: 'USER INPUT',
                      icon: Icons.assignment_outlined,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4CAF50), Color(0xFFC8E6C9)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      textColor: const Color(0xFF1B5E20),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const UserInputScreen()));
                      },
                    ),
                    _QuickAccessCard(
                      text: 'SUBSIDY',
                      icon: Icons.currency_rupee_outlined,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4FC3F7), Color(0xFFE1F5FE)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      textColor: const Color(0xFF01579B),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportScreen()));
                      },
                    ),
                    _QuickAccessCard(
                      text: 'CHAT BOT',
                      icon: Icons.chat_bubble_outline,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE91E63), Color(0xFFF8BBD0)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      textColor: const Color(0xFF880E4F),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final Gradient gradient;
  final Color textColor;
  final VoidCallback onTap; // --- NEW: Added onTap function property

  const _QuickAccessCard({
    required this.text,
    required this.icon,
    required this.gradient,
    required this.textColor,
    required this.onTap, // --- NEW: Required in constructor
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - (16 * 3)) / 2;

    return Container(
      width: cardWidth,
      height: cardWidth * 0.9,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(40.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 40),
              const SizedBox(height: 10),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
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