// lib/screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- CHANGED: Converted to StatefulWidget for full interactivity ---
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // --- NEW: State variables for chat functionality ---
  final TextEditingController _textController = TextEditingController();
  final List<String> _messages = [];
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    // Trigger entry animation
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _animate = true);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // --- NEW: Function to handle sending a message ---
  void _sendMessage() {
    if (_textController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(_textController.text.trim());
      });
      _textController.clear();
      // Add haptic feedback if you like
      // HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA0D2EB), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // --- Top Bar ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
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
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.black54),
                      iconSize: 32,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // --- NEW: This section conditionally shows the welcome view or the chat list ---
              Expanded(
                child: _messages.isEmpty
                    ? _buildWelcomeView() // Show this if no messages are sent
                    : _buildChatListView(), // Show this after the first message
              ),

              // --- UPGRADED: Bottom Input Bar ---
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: InputDecoration(
                          hintText: 'Ask anything...',
                          hintStyle: GoogleFonts.poppins(color: Colors.grey[700]),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: const BorderSide(color: Colors.black, width: 2.0)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: const BorderSide(color: Colors.black, width: 2.0)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.5)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // --- NEW: Send Button ---
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF42A5F5), Color(0xFF1976D2)]),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: _sendMessage,
                        splashRadius: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- NEW: Helper widget for the welcome view with animations ---
  Widget _buildWelcomeView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        _AnimatedSection(delay: 200, animate: _animate, child: Image.asset('assets/images/chatlogo.png', height: 120)),
        const SizedBox(height: 30),
        _AnimatedSection(
          delay: 400,
          animate: _animate,
          child: Text(
            'Hello, John',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: const Color(0xFF012A4A)),
          ),
        ),
        const SizedBox(height: 8),
        _AnimatedSection(
          delay: 500,
          animate: _animate,
          child: Text(
            'What can I help with?',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 22, color: Colors.black54),
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }

  // --- NEW: Helper widget to display the list of messages ---
  Widget _buildChatListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      reverse: true, // To show latest messages at the bottom
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        // Simple UI for a user message
        return Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _messages.reversed.toList()[index],
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}

// --- NEW: Animation widget for 3D entry effect ---
class _AnimatedSection extends StatefulWidget {
  final int delay;
  final bool animate;
  final Widget child;

  const _AnimatedSection({required this.delay, required this.animate, required this.child});

  @override
  State<_AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<_AnimatedSection> {
  bool _show = false;

  @override
  void initState() {
    super.initState();
    // Use the animate flag from the parent to trigger the show animation
    if (widget.animate) {
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (mounted) setState(() => _show = true);
      });
    }
  }

  // This handles cases where the parent animate flag changes
  @override
  void didUpdateWidget(covariant _AnimatedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !_show) {
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (mounted) setState(() => _show = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      opacity: _show ? 1.0 : 0.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        transform: _show
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