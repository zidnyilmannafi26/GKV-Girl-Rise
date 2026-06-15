import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../scenario_1/scenario_1_screen.dart';
import '../scenario_2/intro/scenario_2_intro_screen.dart';

class ScenarioSelectionScreen extends StatelessWidget {
  const ScenarioSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image (fully bright, no dark overlay)
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.home.png',
              fit: BoxFit.cover,
            ),
          ),
          
          // Pill-shaped Back Button (top left)
          Positioned(
            top: 25,
            left: 25,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF7F0), // cream background
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFB59D93), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '← BACK',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF765E54), // brown text
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ),

          // Gift & Log Icons (top right)
          Positioned(
            top: 25,
            right: 25,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Gift Icon
                IconButton(
                  icon: const Icon(
                    Icons.card_giftcard_outlined,
                    color: Colors.white70,
                    size: 32,
                  ),
                  onPressed: () {
                    // TODO: Action for gift/store
                  },
                ),
                const SizedBox(width: 16),
                // Log Icon
                GestureDetector(
                  onTap: () {
                    // TODO: Action for logs
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.description_outlined,
                        color: Colors.white70,
                        size: 30,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '.LOG',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Center Cards (Landscape layout, taking ~72% height)
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Scenario 1 Card
                InteractiveScenarioCard(
                  imagePath: 'assets/images/Scenario_1.png',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Scenario1Screen(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 30),
                // Scenario 2 Card
                InteractiveScenarioCard(
                  imagePath: 'assets/images/Scenario_2.png',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Scenario2IntroScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InteractiveScenarioCard extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;

  const InteractiveScenarioCard({
    required this.imagePath,
    required this.onTap,
    super.key,
  });

  @override
  State<InteractiveScenarioCard> createState() => _InteractiveScenarioCardState();
}

class _InteractiveScenarioCardState extends State<InteractiveScenarioCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Determine dynamic scale
    double scale = 1.0;
    if (_isPressed) {
      scale = 0.95;
    } else if (_isHovered) {
      scale = 1.05;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.72,
            child: Image.asset(
              widget.imagePath,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
