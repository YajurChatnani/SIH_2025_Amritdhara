import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart'; // IMPORT ADDED
import 'package:url_launcher/url_launcher.dart';

// A simple data model for a vendor
class Vendor {
  final String name;
  final String role; // Role will now be the translated string
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

  @override
  Widget build(BuildContext context) {
    // Get the localizations object once
    final localizations = AppLocalizations.of(context)!;

    // CHANGED: Build the list inside the build method to use translations
    final List<Vendor> activeVendors = [
      Vendor(
        name: 'Mr. Mohan Kumar',
        role: localizations.roleContractor, // Use translated role
        mobile: '+919009312222',
        address: 'J-45, Nehru Place, New Delhi',
      ),
      Vendor(
        name: 'Mr. Ramkamal',
        role: localizations.roleContractor, // Use translated role
        mobile: '+919109447974',
        address: 'B-112, Sector 5, Noida',
      ),
      Vendor(
        name: 'Mr. Rajat Singh',
        role: localizations.roleContractor, // Use translated role
        mobile: '+918821811285',
        address: 'D-2, Hauz Khas, New Delhi',
      ),
      Vendor(
        name: 'Mr. Suresh Patel',
        role: localizations.rolePlumber, // Use translated role
        mobile: '+919129785055',
        address: '15/A, Karol Bagh, New Delhi',
      ),
    ];

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
              splashRadius: 24,
            ),
          ),
        ),
        // CHANGED
        title: Text(
          localizations.vendorsTitle,
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
              ]),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Divider(color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    // CHANGED
                    Text(
                      localizations.activeVendors,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
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
    final localizations = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFD7F8FA),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.5)),
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
                    '${localizations.mobileNo} ${vendor.mobile}',
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${localizations.addressLabel} ${vendor.address}',
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // Call Now Button
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.4),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            launchUrl(Uri.parse('tel:${vendor.mobile}'));
                          },
                          icon: const Icon(Icons.call, size: 16),
                          label: Text(localizations.callNow),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                          ),
                        ),
                      ),
                      // WhatsApp Button
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.4),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final whatsappUrl = Uri.parse(
                                "https://wa.me/${vendor.mobile}?text=Hello%20${Uri.encodeComponent(vendor.name)},%20I%20would%20like%20to%20connect%20with%20you.");
                            launchUrl(whatsappUrl,
                                mode: LaunchMode.externalApplication);
                          },
                          icon: const Icon(Icons.message, size: 16),
                          label: Text(localizations.messageWhatsApp),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            elevation: 0,
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

// ... _AnimatedSection widget remains the same ...
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
