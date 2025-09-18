// lib/screens/report_screen.dart
import 'package:flutter/material.dart';
import 'dart:math' as math; // Needed for rotating an icon

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double feasibilityPercentage = 0.75; // 75%

    // Define the two gradients for the cards
    const silverGradient = LinearGradient(
      colors: [Color(0xFFE0E0E0), Colors.white],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    const blueGradient = LinearGradient(
      colors: [Color(0xFFA0D2EB), Colors.white],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
        // --- CHANGED: Back button now matches the User Input Screen style ---
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue.withOpacity(0.8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'SUMMARY REPORT',
          style: TextStyle(
            decoration: TextDecoration.underline,
            decorationColor: Color(0xFF012A4A),
            decorationThickness: 1.5,
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Color(0xFF012A4A),
          ),
        ),
        centerTitle: true,
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: kToolbarHeight + MediaQuery.of(context).padding.top),

                _buildInfoCard(
                  gradient: silverGradient,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Estimated Cost', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                      const SizedBox(height: 8),
                      Text('₹ 2500 - 2600 /- ', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.grey[850])),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildInfoCard(
                  gradient: blueGradient,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Feasibility', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                          const Text('75%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF012A4A))),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                height: 12,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  gradient: const LinearGradient(colors: [Colors.red, Colors.orange, Colors.yellow, Colors.lightGreen, Colors.green]),
                                ),
                              ),
                              Positioned(
                                left: (constraints.maxWidth * feasibilityPercentage) - 18,
                                top: -10,
                                child: Transform.rotate(
                                  angle: math.pi,
                                  child: const Icon(Icons.arrow_drop_down, size: 40, color: Color(0xFF012A4A)),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildInfoCard(
                  gradient: silverGradient,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Harvest Potential', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('260000', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.grey[850])),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text('Litres/Year', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[600])),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildInfoCard(
                  gradient: blueGradient,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Government Subsidy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                      const SizedBox(height: 20),
                      _buildSubsidyRow(
                        icon: Icons.energy_savings_leaf_outlined,
                        title: 'Jal Jeevan Mission',
                        subsidy: '₹ 12,000',
                        onTap: () {},
                      ),
                      const SizedBox(height: 16),
                      _buildSubsidyRow(
                        icon: Icons.agriculture_outlined,
                        title: 'Pradhan Mantri Krishi Sinchai Yojana (PMKSY)',
                        subsidy: '₹ 15,000',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.save_alt_rounded, size: 20),
                    label: const Text('Save as PDF', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade100,
                      foregroundColor: const Color(0xFF012A4A),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                      shape: const StadiumBorder(),
                      elevation: 4,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // A reusable widget for the main info cards
  Widget _buildInfoCard({required Widget child, required Gradient gradient}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  // Reusable subsidy row
  Widget _buildSubsidyRow({
    required IconData icon,
    required String title,
    required String subsidy,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.green.shade400, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF012A4A)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text('Subsidy Amount: $subsidy', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            ],
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade200),
            child: const Icon(Icons.link, color: Color(0xFF012A4A), size: 20),
          ),
        ),
      ],
    );
  }
}