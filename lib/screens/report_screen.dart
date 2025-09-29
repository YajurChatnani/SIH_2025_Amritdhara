// lib/screens/report_screen.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';

class ReportScreen extends StatefulWidget {
  final response;

  const ReportScreen({super.key, this.response});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    // Handle null response
    if (widget.response == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text('No feasibility data available'),
              Text('Please try again'),
            ],
          ),
        ),
      );
    }

    // Get the best feasibility score from the response
    // Get the structure map from response
    final Map<String, double> structureScores = widget.response!.structureScores;

    // Find the structure with the highest score
    final MapEntry<String, double> bestEntry =
    structureScores.entries.reduce((a, b) => a.value > b.value ? a : b);

    // Extract best structure and score
    final String bestStructure = bestEntry.key;
    final double bestfeasibilityScore = bestEntry.value;
    final double feasibilityPercentage = bestfeasibilityScore / 100.0; // Convert to 0-1 range for positioning
    final int costEstimate_low = widget.response!.costEstimate_low;
    final int costEstimate_high = widget.response!.costEstimate_high;
    final int annual_harvest_potential = widget.response!.annual_harvest_potential;

    final reportCards = [
      _InfoCard(
        gradient: const LinearGradient(colors: [Color(0xFFE0E0E0), Colors.white], begin: Alignment.topLeft, end: Alignment.bottomRight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estimated Cost', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700])),
            const SizedBox(height: 8),

            Text('₹ ${costEstimate_low.toStringAsFixed(0)} - ${costEstimate_high.toStringAsFixed(0)} /- ', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.grey[850])),
          ],
        ),
      ),
      _InfoCard(
        gradient: const LinearGradient(colors: [Color(0xFFA0D2EB), Colors.white], begin: Alignment.topLeft, end: Alignment.bottomRight),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Feasibility', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                Text('${bestfeasibilityScore.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF012A4A))),
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
                      child: Transform.rotate(angle: math.pi, child: const Icon(Icons.arrow_drop_down, size: 40, color: Color(0xFF012A4A))),
                    ),
                  ],
                );
              },
            ),

          ],
        ),
      ),
      _InfoCard(
        gradient: const LinearGradient(colors: [Color(0xFFE0E0E0), Colors.white], begin: Alignment.topLeft, end: Alignment.bottomRight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Harvest Potential', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700])),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${annual_harvest_potential.toStringAsFixed(0)}', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.grey[850])),
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
      _InfoCard(
        gradient: const LinearGradient(colors: [Color(0xFFA0D2EB), Colors.white], begin: Alignment.topLeft, end: Alignment.bottomRight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Government Subsidy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700])),
            const SizedBox(height: 20),
            _buildSubsidyRow(icon: Icons.energy_savings_leaf_outlined, title: 'Jal Jeevan Mission', subsidy: '₹ 12,000', onTap: () {}),
            const SizedBox(height: 16),
            _buildSubsidyRow(icon: Icons.agriculture_outlined, title: 'Pradhan Mantri Krishi Sinchai Yojana (PMKSY)', subsidy: '₹ 15,000', onTap: () {}),
          ],
        ),
      ),
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
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue.withOpacity(0.8),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5, offset: const Offset(0, 2))],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF42A5F5), Color(0xFF0D47A1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
          child: Text(
            'SUMMARY REPORT',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w800,
              fontSize: 22,
              shadows: [const Shadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))],
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD4EFFC), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
            left: 16,
            right: 16,
            bottom: 20,
          ),
          itemCount: reportCards.length,
          itemBuilder: (context, index) {
            return _AnimatedSection(
              delay: 150 * (index + 1),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: reportCards[index],
              ),
            );
          },
        ),
      ),
    );
  }

  // --- FIXED: Full code for the helper widget is now included ---
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

class _InfoCard extends StatefulWidget {
  final Widget child;
  final Gradient gradient;

  const _InfoCard({required this.child, required this.gradient});

  @override
  State<_InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<_InfoCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isPressed ? 0.15 : 0.08),
                spreadRadius: _isPressed ? 4 : 2,
                blurRadius: _isPressed ? 25 : 20,
                offset: Offset(0, _isPressed ? 10 : 5),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class _AnimatedSection extends StatefulWidget {
  final int delay;
  final Widget child;

  const _AnimatedSection({required this.delay, required this.child});

  @override
  State<_AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<_AnimatedSection> {
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) setState(() => _animate = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      opacity: _animate ? 1.0 : 0.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        transform: _animate
            ? Matrix4.identity()
            : (Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(-0.3)
          ..translate(0.0, 50.0, 0.0)),
        child: widget.child,
      ),
    );
  }
}