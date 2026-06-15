import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'scenario_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.home.png',
              fit: BoxFit.cover,
            ),
          ),
          
          // Left Character
          Positioned(
            left: 50,
            bottom: 0,
            child: Image.asset(
              'assets/images/cewe.bingung.png',
              height: MediaQuery.of(context).size.height * 0.8,
              fit: BoxFit.contain,
            ),
          ),
          
          // Right Character
          Positioned(
            right: 50,
            bottom: 0,
            child: Image.asset(
              'assets/images/cowo.natap.kiri.png',
              height: MediaQuery.of(context).size.height * 0.8,
              fit: BoxFit.contain,
            ),
          ),
          
          // History Button
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.history, color: Colors.white, size: 32),
                onPressed: () {
                  // TODO: Navigate to history screen
                },
              ),
            ),
          ),
          
          // Center Content (Title & Tap to Start)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                // Title
                Text(
                  'Girl Rise',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withValues(alpha: 0.5),
                        offset: const Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 3),
                // Tap to Start Button
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        settings: const RouteSettings(name: '/selection'),
                        builder: (context) => const ScenarioSelectionScreen(),
                      ),
                    );
                  },
                  child: FadeTransition(
                    opacity: _animation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Text(
                        'TAP TO START',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
