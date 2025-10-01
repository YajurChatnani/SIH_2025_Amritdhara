import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart'; // IMPORT ADDED
import '../services/gemini_api.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

// A simple model for messages
class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _animate = false;
  bool _isTyping = false; // NEW: for "Dhara is typing..."

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _animate = true);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_textController.text.trim().isNotEmpty) {
      final userMessage = _textController.text.trim();

      setState(() {
        _messages.add(ChatMessage(text: userMessage, isUser: true));
        _isTyping = true; // show typing when user sends msg
      });

      _textController.clear();


      GeminiApi.getResponse(userMessage).then((apiResponse) {
        setState(() {
          _isTyping = false;
          _messages.add(ChatMessage(text: apiResponse, isUser: false));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
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
                    IconButton(
                      icon:
                      const Icon(Icons.info_outline, color: Colors.black54),
                      iconSize: 32,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _messages.isEmpty
                    ? _buildWelcomeView(localizations)
                    : _buildChatListView(),
              ),
              if (_isTyping) _buildTypingIndicator(), // show typing
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: InputDecoration(
                          hintText: localizations.askAnything,
                          hintStyle: GoogleFonts.poppins(color: Colors.grey[700]),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2.0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2.5)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Color(0xFF42A5F5), Color(0xFF1976D2)]),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.blue.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4))
                        ],
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

  Widget _buildWelcomeView(AppLocalizations localizations) {
    const userName = 'John';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        _AnimatedSection(
            delay: 200,
            animate: _animate,
            child: Image.asset('assets/images/chatlogo.png', height: 120)),
        const SizedBox(height: 30),
        _AnimatedSection(
          delay: 400,
          animate: _animate,
          child: Text(
            localizations.helloUser(userName),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF012A4A)),
          ),
        ),
        const SizedBox(height: 8),
        _AnimatedSection(
          delay: 500,
          animate: _animate,
          child: Text(
            localizations.whatCanIHelpWith,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 22, color: Colors.black54),
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }

  Widget _buildChatListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      reverse: true,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages.reversed.toList()[index];
        final isUser = message.isUser;

        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFF1976D2) : Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 8),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 14,
            backgroundColor: Colors.blueGrey,
            child: Icon(Icons.person, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 8),
          AnimatedDots(),
        ],
      ),
    );
  }
}

class AnimatedDots extends StatefulWidget {
  @override
  State<AnimatedDots> createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<AnimatedDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        int dotCount = 3;
        int currentDot =
            (_controller.value * dotCount).floor() % (dotCount + 1);

        return Text(
          "Dhara is typing${"." * currentDot}",
          style: const TextStyle(color: Colors.black54, fontSize: 14),
        );
      },
    );
  }
}

class _AnimatedSection extends StatefulWidget {
  final int delay;
  final bool animate;
  final Widget child;

  const _AnimatedSection(
      {required this.delay, required this.animate, required this.child});

  @override
  State<_AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<_AnimatedSection> {
  bool _show = false;

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (mounted) setState(() => _show = true);
      });
    }
  }

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
