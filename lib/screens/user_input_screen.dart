// lib/screens/user_input_screen.dart
import 'package:flutter/material.dart';
import 'dart:ui'; // Needed for the blur effect
import 'package:flutter/services.dart'; // Needed for Haptic Feedback and TextInputFormatter
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/calculation_result.dart';
import './report_screen.dart';

class UserInputScreen extends StatefulWidget {
  const UserInputScreen({super.key});

  @override
  State<UserInputScreen> createState() => _UserInputScreenState();
}

class _UserInputScreenState extends State<UserInputScreen> {
  final _pinCodeController = TextEditingController();
  final _addressController = TextEditingController();
  final _roofAreaController = TextEditingController();
  final _openAreaController = TextEditingController();
  final _dwellersController = TextEditingController();

  String? _roofMaterial = 'Concrete';
  String _locationType = 'Urban';
  bool _isLoading = false;

  @override
  void dispose() {
    _pinCodeController.dispose();
    _addressController.dispose();
    _roofAreaController.dispose();
    _openAreaController.dispose();
    _dwellersController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_validateInputs()) return;

    // Create a dummy response
    final feasibilityResponse = CalculationResult(
      input: FeasibilityInput(
        roofArea: double.parse(_roofAreaController.text),
        pincode: _pinCodeController.text,
        address: _addressController.text,
        roofMaterial: _roofMaterial ?? 'Other',
        locationType: _locationType,
        openArea: double.parse(_openAreaController.text),
        dwellers: int.parse(_dwellersController.text),
      ),
      location: LocationData(
        district: 'Dummy District',
        state: 'Dummy State',
      ),
      data: EnvironmentalData(
        avgMonsoon: 500,
        maxMonsoon: 700,
        soilType: 'Clay',
        gwDepthM: 10,
      ),
      feasibilityScores: CalculationScores(
        soakPit: 80,
        rechargePit: 70,
        trench: 60,
        dugWell: 50,
        shaft: 40,
      ),
      warning: null,
    );

    // Navigate to ReportScreen
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReportScreen(response: feasibilityResponse),
        ),
      );
    }
  }

  bool _validateInputs() {
    if (_pinCodeController.text.trim().isEmpty) {
      _showErrorDialog('Please enter PIN Code');
      return false;
    }
    if (_pinCodeController.text.trim().length != 6) {
      _showErrorDialog('PIN Code must be 6 digits');
      return false;
    }
    if (_roofAreaController.text.trim().isEmpty) {
      _showErrorDialog('Please enter roof area');
      return false;
    }
    final roofArea = double.tryParse(_roofAreaController.text.trim());
    if (roofArea == null || roofArea <= 0) {
      _showErrorDialog('Please enter a valid roof area');
      return false;
    }
    if (_openAreaController.text.trim().isEmpty) {
      _showErrorDialog('Please enter open area');
      return false;
    }
    final openArea = double.tryParse(_openAreaController.text.trim());
    if (openArea == null || openArea < 0) {
      _showErrorDialog('Please enter a valid open area (can be 0)');
      return false;
    }
    if (_dwellersController.text.trim().isEmpty) {
      _showErrorDialog('Please enter the number of dwellers');
      return false;
    }
    final dwellers = int.tryParse(_dwellersController.text.trim());
    if (dwellers == null || dwellers <= 0) {
      _showErrorDialog('Please enter a valid number of dwellers');
      return false;
    }
    return true;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    _showInfoDialog('Location feature will be implemented soon!');
  }

  void _showInfoDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Info'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formSections = [
      _buildSectionCard(
        title: 'Location',
        children: [
          _BuildTextField('PIN Code', _pinCodeController),
          const SizedBox(height: 16),
          _BuildTextField('Address', _addressController),
          const SizedBox(height: 16),
          _BuildStyledButton(
            text: 'Use location',
            icon: Icons.location_on_outlined,
            onTap: _getCurrentLocation,
          ),
        ],
      ),
      _buildSectionCard(
        title: 'Area Details',
        children: [
          _BuildTextField('Roof Area', _roofAreaController, suffixText: 'm²'),
          const SizedBox(height: 16),
          _BuildTextField('Open Area', _openAreaController, suffixText: 'm²'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            decoration: BoxDecoration(
                color: Colors.blue.shade50.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white, width: 1.5)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _roofMaterial,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF012A4A)),
                dropdownColor: Colors.blue.shade50.withOpacity(0.9),
                onChanged: (String? newValue) =>
                    setState(() => _roofMaterial = newValue),
                items: <String>['Concrete', 'Tin', 'Tiles', 'Other']
                    .map((String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,
                      style: const TextStyle(
                          color: Color(0xFF012A4A),
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
      _buildSectionCard(
        title: 'Household Details',
        children: [
          _BuildTextField('No. of Dwellers', _dwellersController),
        ],
      ),
      _buildSectionCard(
        title: 'Location Type',
        children: [
          _buildToggleButtons(),
        ],
      ),
      Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _BuildStyledButton(
          text: 'SUBMIT',
          isSubmitButton: true,
          onTap: _submitForm,
        ),
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
              gradient: const LinearGradient(
                  colors: [Color(0xFF42A5F5), Color(0xFF1976D2)]),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10)
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002)
            ..rotateX(0.1),
          alignment: FractionalOffset.center,
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF42A5F5), Color(0xFF0D47A1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
            child: Text(
              'USER INPUT',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                fontSize: 24,
                shadows: [
                  const Shadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 2))
                ],
              ),
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
              end: Alignment.bottomCenter),
        ),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
            left: 16,
            right: 16,
            bottom: 20,
          ),
          itemCount: formSections.length,
          itemBuilder: (context, index) {
            return _AnimatedSection(
              delay: 110 * (index + 1),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: formSections[index],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildToggleButtons() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth / 2;
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                left: _locationType == 'Urban' ? 0 : width,
                child: Container(
                  width: width,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF42A5F5), Color(0xFF1976D2)]),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2)
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() => _locationType = 'Urban');
                      },
                      child: Container(
                        height: 50,
                        color: Colors.transparent,
                        child: Center(
                          child: Text('Urban',
                              style: TextStyle(
                                  color: _locationType == 'Urban'
                                      ? Colors.white
                                      : const Color(0xFF012A4A),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() => _locationType = 'Rural');
                      },
                      child: Container(
                        height: 50,
                        color: Colors.transparent,
                        child: Center(
                          child: Text('Rural',
                              style: TextStyle(
                                  color: _locationType == 'Rural'
                                      ? Colors.white
                                      : const Color(0xFF012A4A),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionCard(
      {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF012A4A))),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 2,
                  blurRadius: 20,
                  offset: const Offset(0, 5))
            ],
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children),
        ),
      ],
    );
  }
}

class _BuildTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final String? suffixText;

  const _BuildTextField(this.hintText, this.controller, {this.suffixText});

  @override
  State<_BuildTextField> createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<_BuildTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // --- THIS IS THE SECTION THAT CHANGED ---
    final isNumeric = widget.hintText.contains('PIN Code') ||
        widget.hintText.contains('Area') ||
        widget.hintText.contains('Dwellers');

    return TweenAnimationBuilder<Decoration>(
      duration: const Duration(milliseconds: 300),
      tween: DecorationTween(
        begin: _buildDecoration(isFocused: false),
        end: _buildDecoration(isFocused: _isFocused),
      ),
      builder: (context, decoration, child) {
        return Container(
          decoration: decoration,
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(widget.hintText,
                        style: GoogleFonts.poppins(
                            color: const Color(0xFF012A4A),
                            fontSize: 16,
                            fontWeight: FontWeight.w600))),
                if (widget.suffixText != null)
                  Text(widget.suffixText!,
                      style: const TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
            TextField(
              focusNode: _focusNode,
              controller: widget.controller,
              decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none),
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              // Set keyboard type
              keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
              // Set input formatter to only allow digits for numeric fields
              inputFormatters: isNumeric
                  ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
                  : null,
            ),
            const DottedLine(color: Colors.black54),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration({required bool isFocused}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: isFocused ? Colors.white : Colors.white.withOpacity(0.5),
      border: Border.all(
        color: isFocused ? Colors.blue.shade300 : Colors.white.withOpacity(0.7),
        width: 1.5,
      ),
    );
  }
}

class _BuildStyledButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onTap;
  final bool isSubmitButton;

  const _BuildStyledButton(
      {required this.text,
        this.icon,
        required this.onTap,
        this.isSubmitButton = false});

  @override
  State<_BuildStyledButton> createState() => _BuildStyledButtonState();
}

class _BuildStyledButtonState extends State<_BuildStyledButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapCancel: () => setState(() => _isPressed = false),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        if (widget.isSubmitButton) HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            gradient: widget.isSubmitButton
                ? const LinearGradient(
                colors: [Color(0xFF42A5F5), Color(0xFF1976D2)])
                : null,
            color: !widget.isSubmitButton ? Colors.white.withOpacity(0.8) : null,
            borderRadius: BorderRadius.circular(25.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 5))
            ],
          ),
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 32.0, vertical: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null)
                  Icon(widget.icon, color: const Color(0xFF012A4A)),
                if (widget.icon != null) const SizedBox(width: 8),
                Text(widget.text,
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: widget.isSubmitButton
                            ? Colors.white
                            : const Color(0xFF012A4A),
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
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
        transform: Matrix4.translationValues(0, _animate ? 0 : 50, 0),
        child: widget.child,
      ),
    );
  }
}

class DottedLine extends StatelessWidget {
  const DottedLine({super.key, this.height = 1, this.color = Colors.grey});
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(decoration: BoxDecoration(color: color)));
          }),
        );
      },
    );
  }
}