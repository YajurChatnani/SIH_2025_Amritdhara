// lib/screens/user_input_screen.dart
import 'package:flutter/material.dart';

class UserInputScreen extends StatefulWidget {
  const UserInputScreen({super.key});

  @override
  State<UserInputScreen> createState() => _UserInputScreenState();
}

class _UserInputScreenState extends State<UserInputScreen> {
  final _pinCodeController = TextEditingController();
  final _addressController = TextEditingController();
  final _roofAreaController = TextEditingController();

  String? _roofMaterial = 'Concrete';
  String? _locationType = 'Urban';

  @override
  void dispose() {
    _pinCodeController.dispose();
    _addressController.dispose();
    _roofAreaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final innerFieldColor = Colors.blue.shade50.withOpacity(0.7);

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
          'USER INPUT',
          style: TextStyle(
            color: Color(0xFF012A4A),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 20,
            decoration: TextDecoration.underline,
            decorationColor: Color(0xFF012A4A),
            decorationThickness: 2,
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
              Color(0xFFE0F2F7),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: kToolbarHeight + MediaQuery.of(context).padding.top + 10),

                _buildSectionCard(
                  title: 'Location',
                  children: [
                    _buildTextField('PIN Code', _pinCodeController, innerFieldColor),
                    const SizedBox(height: 16),
                    _buildTextField('Address', _addressController, innerFieldColor),
                    const SizedBox(height: 16),
                    _buildStyledButton(
                      text: 'Use location',
                      icon: Icons.location_on_outlined,
                      color: innerFieldColor,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                _buildSectionCard(
                  title: 'Roof Details',
                  children: [
                    _buildTextField('Roof Area', _roofAreaController, innerFieldColor, suffixText: 'm²'),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: innerFieldColor,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _roofMaterial,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                          dropdownColor: Colors.blue.shade50,
                          onChanged: (String? newValue) {
                            setState(() {
                              _roofMaterial = newValue;
                            });
                          },
                          items: <String>['Concrete', 'Tin', 'Tiles', 'Other']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: const TextStyle(color: Colors.black54, fontSize: 16)),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                _buildSectionCard(
                  title: 'Location Type',
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Urban'),
                            value: 'Urban',
                            groupValue: _locationType,
                            onChanged: (String? value) {
                              setState(() {
                                _locationType = value;
                              });
                            },
                            activeColor: const Color(0xFF42A5F5),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Rural'),
                            value: 'Rural',
                            groupValue: _locationType,
                            onChanged: (String? value) {
                              setState(() {
                                _locationType = value;
                              });
                            },
                            activeColor: const Color(0xFF42A5F5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                Center(
                  child: _buildStyledButton(
                    text: 'SUBMIT',
                    isSubmitButton: true,
                    onTap: () {
                      print('Submit tapped');
                      print('PIN Code: ${_pinCodeController.text}');
                      print('Address: ${_addressController.text}');
                      print('Roof Area: ${_roofAreaController.text}');
                      print('Roof Material: $_roofMaterial');
                      print('Location Type: $_locationType');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper for the outer white cards
  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF012A4A)),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ],
    );
  }

  // Helper for text fields inside the cards
  Widget _buildTextField(String hintText, TextEditingController controller, Color backgroundColor, {String? suffixText}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  hintText,
                  style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              if (suffixText != null) Text(suffixText, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
            style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
            keyboardType: hintText.contains('PIN Code') || hintText.contains('Roof Area') ? TextInputType.number : TextInputType.text,
          ),
          DottedLine(color: Colors.grey.shade700),
        ],
      ),
    );
  }

  // Helper for the "Use Location" and "Submit" buttons
  Widget _buildStyledButton({required String text, IconData? icon, Color? color, required VoidCallback onTap, bool isSubmitButton = false}) {
    return Container(
      decoration: BoxDecoration(
        color: isSubmitButton ? const Color(0xFF64B5F6) : color,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          if (isSubmitButton)
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(25.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) const Icon(Icons.location_on_outlined, color: Colors.black87),
                if (icon != null) const SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    color: isSubmitButton ? Colors.white : Colors.black87,
                    fontWeight: isSubmitButton ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter for the dotted line
class DottedLine extends StatelessWidget {
  const DottedLine({super.key, this.height = 1, this.color = Colors.grey});
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            );
          }),
        );
      },
    );
  }
}