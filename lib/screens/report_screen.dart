import 'package:amritdhara/screens/chat_screen.dart';
import 'package:amritdhara/screens/steps_and_instructions/structure_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';

import '../l10n/app_localizations.dart';

class ReportScreen extends StatefulWidget {
  final dynamic response;

  const ReportScreen({super.key, this.response});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (widget.response == null) {
      return Scaffold(
        appBar: AppBar(title: Text(localizations.error)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(localizations.noFeasibilityData),
            ],
          ),
        ),
      );
    }

    // Data from the backend response
    final Map<String, double> structureScores =
    Map<String, double>.from(widget.response.structureScores);
    final MapEntry<String, double> bestEntry =
    structureScores.entries.reduce((a, b) => a.value > b.value ? a : b);

    final double bestFeasibilityScore = bestEntry.value;
    final int costEstimateLow = widget.response.costEstimateLow;
    final int costEstimateHigh = widget.response.costEstimateHigh;
    final int annualHarvestPotential = widget.response.annualHarvestPotential;
    final int waterSustainabilityDays = widget.response.waterSustainabilityDays;

    // Define gradients for consistency
    const silverGradient = LinearGradient(
        colors: [Color(0xFFE0E0E0), Colors.white],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight);

    const blueGradient = LinearGradient(
        colors: [Color(0xFFA0D2EB), Colors.white],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight);

    final reportWidgets = [
      // Estimated Cost Card
      _InfoCard(
        gradient: silverGradient,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localizations.estimatedCost,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700])),
            const SizedBox(height: 8),
            Text('₹ $costEstimateLow - $costEstimateHigh /- ',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[850])),
          ],
        ),
      ),

      // Best Structure & Feasibility Card
      _InfoCard(
        gradient: blueGradient,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(localizations.bestStructure,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700])),
                const SizedBox(height: 4),
                Text(
                  bestEntry.key,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF012A4A)),
                ),
                const SizedBox(height: 12),
                _FeasibilityScale(score: bestFeasibilityScore),
              ],
            ),
            children: <Widget>[
              const Divider(height: 24, thickness: 0.5, color: Colors.grey),
              ...structureScores.entries.map((entry) {
                return _buildFeasibilityRow(entry.key, entry.value);
              }).toList(),
            ],
          ),
        ),
      ),

      // Harvest Potential Card
      _InfoCard(
        gradient: silverGradient,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localizations.harvestPotential,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700])),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('$annualHarvestPotential',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[850])),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(localizations.litresPerYear,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600])),
                ),
              ],
            ),
          ],
        ),
      ),

      // Water Sustainability Card
      _InfoCard(
        gradient: blueGradient,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localizations.waterSustainabilityTitle,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700])),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(waterSustainabilityDays.toString(),
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[850])),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(localizations.days,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600])),
                ),
              ],
            ),
          ],
        ),
      ),

      // Government Subsidy Card
      _InfoCard(
        gradient: silverGradient,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localizations.govtSubsidy,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700])),
            const SizedBox(height: 20),
            _buildSubsidyRow(
                icon: Icons.energy_savings_leaf_outlined,
                title: localizations.jalJeevanMission,
                subsidy: '₹ 12,000',
                onTap: () {},
                localizations: localizations),
            const SizedBox(height: 16),
            _buildSubsidyRow(
                icon: Icons.agriculture_outlined,
                title: localizations.pmksy,
                subsidy: '₹ 15,000',
                onTap: () {},
                localizations: localizations),
          ],
        ),
      ),

      // Buttons
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const StructureScreen()));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF012A4A),
          foregroundColor: Colors.white,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 18),
          elevation: 5,
        ),
        child: Text(
          localizations.stepsAndInstructions,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.save_alt_rounded),
              label: Text(localizations.saveAsPdf),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF012A4A),
                side: const BorderSide(color: Color(0xFF012A4A), width: 2),
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ChatScreen()));
              },
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              label: Text(localizations.askChatBot),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4FC3F7),
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
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
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 2))
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          localizations.summaryReport,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: const Color(0xFF0D47A1),
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
          itemCount: reportWidgets.length,
          itemBuilder: (context, index) {
            return _AnimatedSection(
              delay: 150 * (index + 1),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: reportWidgets[index],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeasibilityRow(String structure, double score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            structure,
            style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _FeasibilityScale(score: score),
        ],
      ),
    );
  }

  Widget _buildSubsidyRow({
    required IconData icon,
    required String title,
    required String subsidy,
    required VoidCallback onTap,
    required AppLocalizations localizations,
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
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF012A4A)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text('${localizations.subsidyAmount}: $subsidy',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            ],
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.grey.shade200),
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

class _FeasibilityScale extends StatelessWidget {
  final double score;

  const _FeasibilityScale({required this.score});

  LinearGradient _getGradientForScore(double score) {
    if (score < 40) {
      return LinearGradient(
        colors: [Colors.red.shade200, Colors.red.shade500],
      );
    } else if (score < 70) {
      return LinearGradient(
        colors: [Colors.yellow.shade400, Colors.orange.shade600],
      );
    } else {
      return LinearGradient(
        colors: [Colors.green.shade300, Colors.green.shade600],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final percentage = score / 100.0;
    const tooltipWidth = 55.0;
    const tooltipHeight = 28.0;
    const arrowHeight = 10.0;

    return LayoutBuilder(builder: (context, constraints) {
      final double leftPosition =
          (constraints.maxWidth * percentage) - (tooltipWidth / 2);

      return Container(
        padding: const EdgeInsets.only(top: tooltipHeight + arrowHeight - 2),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Background Track
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            // Progress Fill
            FractionallySizedBox(
              widthFactor: percentage,
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  gradient: _getGradientForScore(score),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            // Tooltip Thumb
            Positioned(
              top: -tooltipHeight - arrowHeight,
              left: leftPosition.clamp(
                  0.0, constraints.maxWidth - tooltipWidth),
              child: SizedBox(
                width: tooltipWidth,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      bottom: 0,
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: const Color(0xFF012A4A),
                        size: 20,
                      ),
                    ),
                    Container(
                      height: tooltipHeight,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF012A4A),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        '${score.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}