import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui'; // Required for the BackdropFilter (glass effect)

class StructureScreen extends StatelessWidget {
  const StructureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF42A5F5), Color(0xFF1976D2)]),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Colors.blue.withOpacity(0.3), blurRadius: 10)
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          'STRUCTURE & STEPS',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF012A4A),
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
              Color(0xFFB6D5E1),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: kToolbarHeight + statusBarHeight + 20,
            bottom: 40,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                _AnimatedFadeIn(
                  delay: 200,
                  child: _buildImageCard(context),
                ),
                const SizedBox(height: 30),
                _AnimatedFadeIn(
                  delay: 400,
                  child: _buildInstructionsCard(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for the top image card
  Widget _buildImageCard(BuildContext context) {
    const String imageUrl =
        'https://image.slidesharecdn.com/rainwaterharvestinginchandigarh-150822112431-lva1-app6891/95/rainwater-harvesting-in-chandigarharchitect-surinder-bahgaaugust-19-2015-29-638.jpg?cb=1440307048';

    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Structure Diagram',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF012A4A),
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return const ImageDetailScreen(imageUrl: imageUrl);
                  }));
                },
                child: Hero(
                  tag: 'structureImage',
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      // --- MODIFIED: Added loading and error handling ---
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 200, // Fixed height for loader
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                                color: const Color(0xFF012A4A),
                                strokeWidth: 3,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200, // Fixed height for error
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                  size: 60,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.fullscreen,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for the instructions list card
  Widget _buildInstructionsCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Step-by-Step Instructions',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF012A4A),
                ),
              ),
              const Divider(height: 24, thickness: 0.5),
              _buildInstructionStep(
                number: '1.',
                title: 'Assess Rooftop Area',
                points: [
                  'Measure the total catchment area (roof size).',
                  'Ensure the roof is clean, sloped, and made of non-toxic material.',
                ],
              ),
              _buildInstructionStep(
                number: '2.',
                title: 'Install Gutters and Downpipes',
                points: [
                  'Fix gutters along roof edges to collect rainwater.',
                  'Connect downpipes to channel water to the storage or filtration system.',
                ],
              ),
              _buildInstructionStep(
                number: '3.',
                title: 'Fit a Mesh or Leaf Guard',
                points: [
                  'Place a mesh filter at the top of downpipes to prevent leaves and debris from entering.',
                ],
              ),
              _buildInstructionStep(
                number: '4.',
                title: 'Add a First Flush Diverter',
                points: [
                  'Install a system to discard the initial, more contaminated rainwater.',
                ],
              ),
              _buildInstructionStep(
                number: '5.',
                title: 'Set Up Filtration System',
                points: [
                  'Use layers of gravel, sand, and charcoal to purify the water before storage.',
                ],
              ),
              _buildInstructionStep(
                number: '6.',
                title: 'Install Storage Tank',
                points: [
                  'Choose a tank size based on your rooftop area and local rainfall patterns.',
                  'Ensure the tank is covered to prevent algae growth and mosquito breeding.',
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for each individual instruction step
  Widget _buildInstructionStep({
    required String number,
    required String title,
    required List<String> points,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number $title',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF012A4A),
            ),
          ),
          const SizedBox(height: 8),
          ...points.map((point) => Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '• ',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                Expanded(
                  child: Text(
                    point,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

// Full-screen image viewer
class ImageDetailScreen extends StatelessWidget {
  final String imageUrl;
  const ImageDetailScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Hero(
          tag: 'structureImage',
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.network(
              imageUrl,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                    color: Colors.white, // White loader for dark background
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade900,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 80,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Simple animation widget
class _AnimatedFadeIn extends StatefulWidget {
  final int delay;
  final Widget child;

  const _AnimatedFadeIn({required this.delay, required this.child});

  @override
  State<_AnimatedFadeIn> createState() => _AnimatedFadeInState();
}

class _AnimatedFadeInState extends State<_AnimatedFadeIn> {
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        setState(() {
          _animate = true;
        });
      }
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
        transform: Matrix4.translationValues(0, _animate ? 0 : 20, 0),
        child: widget.child,
      ),
    );
  }
}