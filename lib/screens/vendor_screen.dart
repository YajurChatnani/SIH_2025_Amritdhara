import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math; // Used for animation transform

// A simple data model for a vendor
class Vendor {
  final String name;
  final String role;
  final String mobile;
  final String address;

  const Vendor({
    required this.name,
    required this.role,
    required this.mobile,
    required this.address,
  });
}

class VendorsScreen extends StatelessWidget {
  const VendorsScreen({super.key});

  // Sample list of vendors
  final List<Vendor> activeVendors = const [
    Vendor(
      name: 'Mr. Mohan Kumar',
      role: 'Contractor',
      mobile: '1234561246',
      address: 'J-45, Nehru Place, New Delhi',
    ),
    Vendor(
      name: 'Mr. Ramkamal',
      role: 'Contractor',
      mobile: '1234561246',
      address: 'B-112, Sector 5, Noida',
    ),
    Vendor(
      name: 'Mr. Rajat Singh',
      role: 'Contractor',
      mobile: '1234561246',
      address: 'D-2, Hauz Khas, New Delhi',
    ),
    Vendor(
      name: 'Mr. Suresh Patel',
      role: 'Plumber',
      mobile: '9876543210',
      address: '15/A, Karol Bagh, New Delhi',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
              splashRadius: 24,
            ),
          ),
        ),
        title: Text(
          'VENDORS',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0D47A1),
              fontSize: 24,
              shadows: [
                const Shadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                )
              ]
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
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // This is the static header section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height:  10), // Space for AppBar
                    // --- MODIFIED: Divider is now BEFORE the text ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Divider(color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Active Vendors',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              // This is the scrollable list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 16.0),
                  itemCount: activeVendors.length,
                  itemBuilder: (context, index) {
                    final vendor = activeVendors[index];
                    return _AnimatedSection(
                      delay: 150 * (index + 1),
                      child: _VendorCard(vendor: vendor),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VendorCard extends StatelessWidget {
  final Vendor vendor;

  const _VendorCard({required this.vendor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
          color: const Color(0xFFD7F8FA),
          borderRadius: BorderRadius.circular(20.0),
          // --- MODIFIED: Shadow is now deeper and more pronounced ---
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.5))
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundColor: Color(0xFF01579B),
              child: Icon(Icons.person, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vendor.name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    vendor.role,
                    style: GoogleFonts.poppins(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Mob. No. - ${vendor.mobile}',
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          'Address - ${vendor.address}',
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.red.withOpacity(0.4),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 4)
                              )
                            ]
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement call functionality
                          },
                          icon: const Icon(Icons.call, size: 16),
                          label: const Text('Call Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Animation Widget for staggered list effect
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
        transform: Matrix4.translationValues(0, _animate ? 0 : 30, 0),
        child: widget.child,
      ),
    );
  }
}