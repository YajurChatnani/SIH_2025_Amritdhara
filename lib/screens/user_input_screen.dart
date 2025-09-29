import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui'; // Needed for the blur effect
import '../l10n/app_localizations.dart';
import './report_screen.dart';

class DataResponse {
  final Map<String, double> structureScores;
  final int costEstimate_low;
  final int costEstimate_high;
  final int annual_harvest_potential;

  DataResponse({
    required this.structureScores,
    required this.costEstimate_low,
    required this.costEstimate_high,
    required this.annual_harvest_potential,
  });
}

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

  String _roofMaterial = 'Concrete';
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
    // Get localizations before async gap
    final localizations = AppLocalizations.of(context)!;
    if (!_validateInputs(localizations)) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    final DataResponse hardcodedData = DataResponse(
      structureScores: {
        'Soak Pit': 78.0,
        'Recharge Trench': 92.0,
        'Borewell': 65.0,
      },
      costEstimate_low: 35000,
      costEstimate_high: 55000,
      annual_harvest_potential: 120000,
    );

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReportScreen(response: hardcodedData),
        ),
      );
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _validateInputs(AppLocalizations localizations) {
    if (_pinCodeController.text.trim().isEmpty) {
      _showErrorDialog(localizations.validationEnterPincode);
      return false;
    }
    if (_pinCodeController.text.trim().length != 6) {
      _showErrorDialog(localizations.validationPincode6digits);
      return false;
    }
    if (_roofAreaController.text.trim().isEmpty) {
      _showErrorDialog(localizations.validationEnterRoofArea);
      return false;
    }
    final roofArea = double.tryParse(_roofAreaController.text.trim());
    if (roofArea == null || roofArea <= 0) {
      _showErrorDialog(localizations.validationValidRoofArea);
      return false;
    }
    if (_openAreaController.text.trim().isEmpty) {
      _showErrorDialog(localizations.validationEnterOpenArea);
      return false;
    }
    final openArea = double.tryParse(_openAreaController.text.trim());
    if (openArea == null || openArea < 0) {
      _showErrorDialog(localizations.validationValidOpenArea);
      return false;
    }
    if (_dwellersController.text.trim().isEmpty) {
      _showErrorDialog(localizations.validationEnterDwellers);
      return false;
    }
    final dwellers = int.tryParse(_dwellersController.text.trim());
    if (dwellers == null || dwellers <= 0) {
      _showErrorDialog(localizations.validationValidDwellers);
      return false;
    }
    return true;
  }

  void _showErrorDialog(String message) {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.error),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.ok),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    final localizations = AppLocalizations.of(context)!;
    _showInfoDialog(localizations.locationFeatureSoon);
  }

  void _showInfoDialog(String message) {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.infoDialogTitle),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.ok),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Map for dropdown items
    final Map<String, String> roofMaterialOptions = {
      'Concrete': localizations.roofMaterialConcrete,
      'Tin': localizations.roofMaterialTin,
      'Tiles': localizations.roofMaterialTiles,
      'Other': localizations.roofMaterialOther,
    };

    final formSections = [
      _buildSectionCard(
        title: localizations.location,
        children: [
          _BuildTextField(localizations.pincode, _pinCodeController),
          const SizedBox(height: 16),
          _BuildTextField(localizations.address, _addressController),
          const SizedBox(height: 16),
          _BuildStyledButton(
            text: localizations.useLocation,
            icon: Icons.location_on_outlined,
            onTap: _getCurrentLocation,
          ),
        ],
      ),
      _buildSectionCard(
        title: localizations.areaDetails,
        children: [
          _BuildTextField(localizations.roofArea, _roofAreaController, suffixText: 'm²'),
          const SizedBox(height: 16),
          _BuildTextField(localizations.openArea, _openAreaController, suffixText: 'm²'),
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
                    setState(() => _roofMaterial = newValue!),
                items: roofMaterialOptions.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key, // The English value
                    child: Text(entry.value, // The translated value
                        style: const TextStyle(
                            color: Color(0xFF012A4A),
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      _buildSectionCard(
        title: localizations.householdDetails,
        children: [
          _BuildTextField(localizations.noOfDwellers, _dwellersController),
        ],
      ),
      _buildSectionCard(
        title: localizations.locationType,
        children: [
          _buildToggleButtons(),
        ],
      ),
      Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _BuildStyledButton(
          text: localizations.submit,
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
              localizations.userInputTitle,
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
    final localizations = AppLocalizations.of(context)!;
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
                          child: Text(localizations.urban,
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
                          child: Text(localizations.rural,
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

// ... The rest of the helper widgets (_BuildTextField, _BuildStyledButton, etc.) do not need changes
// as they receive their text from the main build method.

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
    final isNumeric = widget.hintText.contains(AppLocalizations.of(context)!.pincode) ||
        widget.hintText.contains(AppLocalizations.of(context)!.roofArea) ||
        widget.hintText.contains(AppLocalizations.of(context)!.openArea) ||
        widget.hintText.contains(AppLocalizations.of(context)!.noOfDwellers);

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
              keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
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