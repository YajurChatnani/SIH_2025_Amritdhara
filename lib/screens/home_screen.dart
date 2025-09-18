// lib/screens/home_screen.dart

import 'package:amritdhara/screens/user_input_screen.dart';
import 'package:flutter/material.dart';
import 'report_screen.dart';
import 'chat_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  String getGreeting() {
    final hour = TimeOfDay.now().hour;
    if (hour < 12) {
      return 'Good Morning,';
    } else if (hour < 17) {
      return 'Good Afternoon,';
    } else {
      return 'Good Evening,';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - (16 * 2) - 16) / 2;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                )
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.menu, color: Color(0xFF012A4A)),
              onPressed: () {},
            ),
          ),
        ),
        title: Text(
          'AMRITDHARA',
          style: TextStyle(
            color: const Color(0xFF012A4A),
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 26,
            shadows: [
              Shadow(
                blurRadius: 8.0,
                color: Colors.black.withOpacity(0.4),
                offset: const Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(0.15),
                ),
                child: const Icon(Icons.person, color: Color(0xFF012A4A)),
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
                Text(getGreeting(), style: const TextStyle(fontSize: 22, color: Colors.black54)),
                const Text('John', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF012A4A))),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: const Color(0xFF012A4A), width: 3),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 3, blurRadius: 15, offset: const Offset(0, 8))],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22.0),
                    child: Image.asset('assets/images/map.png', fit: BoxFit.cover, height: 180, width: double.infinity),
                  ),
                ),
                const SizedBox(height: 30),
                _buildTipCard(),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Container(width: 5, height: 28, color: const Color(0xFF012A4A)),
                    const SizedBox(width: 10),
                    const Text('QUICK ACCESS', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _QuickAccessCard(
                          text: 'USER INPUT',
                          icon: Icons.assignment_outlined,
                          gradient: const LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFFC8E6C9)], begin: Alignment.centerLeft, end: Alignment.centerRight),
                          textColor: const Color(0xFF1B5E20),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const UserInputScreen()));
                          },
                        ),
                        _QuickAccessCard(
                          text: 'SUBSIDY',
                          icon: Icons.currency_rupee_outlined,
                          gradient: const LinearGradient(colors: [Color(0xFF4FC3F7), Color(0xFFE1F5FE)], begin: Alignment.centerLeft, end: Alignment.centerRight),
                          textColor: const Color(0xFF01579B),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportScreen()));
                          },
                        ),
                      ],
                    ),
                    // --- CHANGED: Reduced spacing between rows ---
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _QuickAccessCard(
                          text: 'CHAT BOT',
                          icon: Icons.chat_bubble_outline,
                          gradient: const LinearGradient(colors: [Color(0xFFE91E63), Color(0xFFF8BBD0)], begin: Alignment.centerLeft, end: Alignment.centerRight),
                          textColor: const Color(0xFF880E4F),
                          width: cardWidth * 0.8,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
                          },
                        ),
                      ],
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

  Widget _buildTipCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.shade200, Colors.orange.shade200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, color: Colors.orange.shade800, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tip of the Day', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.orange.shade900)),
                const SizedBox(height: 4),
                Text('Check your home for leaks. Even a small drip can waste thousands of litres a year!', style: TextStyle(fontSize: 14, color: Colors.brown.shade800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final Gradient gradient;
  final Color textColor;
  final VoidCallback onTap;
  final double? width;

  const _QuickAccessCard({
    required this.text,
    required this.icon,
    required this.gradient,
    required this.textColor,
    required this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final defaultCardWidth = (screenWidth - (16 * 2) - 16) / 2;
    final actualWidth = width ?? defaultCardWidth;

    return Container(
      width: actualWidth,
      // --- CHANGED: Made the cards shorter ---
      height: actualWidth * 0.85, // Was 0.9
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
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}