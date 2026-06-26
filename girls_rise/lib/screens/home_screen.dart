import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'scenario_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController? _idleController;
  Animation<double>? _pulseScaleAnim;
  Animation<double>? _glowAlphaAnim;

  AnimationController? _startController;
  Animation<double>? _screenZoomAnim;
  Animation<double>? _buttonTapScaleAnim;

  bool _isStarting = false;

  void _ensureControllers() {
    if (_idleController != null && _startController != null) return;

    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseScaleAnim = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _idleController!, curve: Curves.easeInOut),
    );
    _glowAlphaAnim = Tween<double>(begin: 0.15, end: 0.45).animate(
      CurvedAnimation(parent: _idleController!, curve: Curves.easeInOut),
    );

    _startController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _buttonTapScaleAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.92,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.92,
          end: 1.3,
        ).chain(CurveTween(curve: Curves.easeInQuad)),
        weight: 70,
      ),
    ]).animate(_startController!);

    _screenZoomAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _startController!, curve: Curves.easeInQuad),
    );
  }

  @override
  void initState() {
    super.initState();
    _ensureControllers();
  }

  @override
  void dispose() {
    _idleController?.dispose();
    _startController?.dispose();
    super.dispose();
  }

  void _onStartTapped() {
    _ensureControllers();
    if (_isStarting) return;
    setState(() => _isStarting = true);

    _startController!.forward().then((_) {
      Navigator.of(context)
          .push(
            PageRouteBuilder(
              settings: const RouteSettings(name: '/selection'),
              transitionDuration: const Duration(milliseconds: 650),
              reverseTransitionDuration: const Duration(milliseconds: 450),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const ScenarioSelectionScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    final curvedAnim = CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutExpo,
                    );
                    return ScaleTransition(
                      scale: Tween<double>(
                        begin: 1.18,
                        end: 1.0,
                      ).animate(curvedAnim),
                      child: FadeTransition(opacity: curvedAnim, child: child),
                    );
                  },
            ),
          )
          .then((_) {
            if (mounted) {
              setState(() => _isStarting = false);
              _startController?.reset();
            }
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    _ensureControllers();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: AnimatedBuilder(
        animation: _startController!,
        builder: (context, child) {
          return Transform.scale(
            scale: _isStarting ? _screenZoomAnim!.value : 1.0,
            child: Opacity(
              opacity: _isStarting
                  ? (1.0 - (_startController!.value * 0.5)).clamp(0.0, 1.0)
                  : 1.0,
              child: child,
            ),
          );
        },
        child: Stack(
          children: [
            // Background (Forcefully overflowed by 30px to eliminate any top/bottom letterbox gaps)
            Positioned(
              top: -30,
              bottom: -30,
              left: -30,
              right: -30,
              child: Image.asset(
                'assets/images/bg.home.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),

            // Left Character
            Positioned(
              left: screenWidth * 0.04,
              bottom: -15,
              height: screenHeight * 0.85,
              child: Image.asset(
                'assets/images/cewe.bingung.png',
                fit: BoxFit.contain,
              ),
            ),

            // Right Character
            Positioned(
              right: screenWidth * 0.04,
              bottom: -15,
              height: screenHeight * 0.85,
              child: Image.asset(
                'assets/images/cowo.natap.kiri.png',
                fit: BoxFit.contain,
              ),
            ),

            // Center Content (Title & Signature Girl Rise Tap to Start Button)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),
                  // Main Game Title
                  Image.asset(
                    'assets/images/judul utama.png',
                    height: min(screenHeight * 0.45, 210.0),
                    fit: BoxFit.contain,
                  ),
                  const Spacer(flex: 3),

                  // Signature Girl Rise "TAP TO START" Button (#FAF1E9 Cream & #9C6C69 Mauve Brown)
                  GestureDetector(
                    onTap: _onStartTapped,
                    child: AnimatedBuilder(
                      animation: Listenable.merge([
                        _idleController!,
                        _startController!,
                      ]),
                      builder: (context, _) {
                        final double buttonScale = _isStarting
                            ? _buttonTapScaleAnim!.value
                            : _pulseScaleAnim!.value;
                        final double glowVal = _glowAlphaAnim!.value;

                        return Transform.scale(
                          scale: buttonScale,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 46,
                              vertical: 18,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFFAF1E9,
                              ), // Girl Rise Signature Cream
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: const Color(
                                  0xFF9C6C69,
                                ), // Girl Rise Mauve Brown
                                width: 2.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF9C6C69).withValues(
                                    alpha: _isStarting ? 0.75 : glowVal,
                                  ),
                                  blurRadius: _isStarting ? 28 : 18,
                                  spreadRadius: _isStarting ? 5 : 1,
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.auto_awesome,
                                  color: Color(
                                    0xFFB59D93,
                                  ), // Soft Mauve Gold accent
                                  size: 24,
                                ),
                                const SizedBox(width: 14),
                                Text(
                                  'Tap to Start',
                                  style: GoogleFonts.lora(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w700,
                                    color: const Color.fromARGB(
                                      156,
                                      108,
                                      105,
                                      100,
                                    ), // Deep Maroon Brown
                                    letterSpacing: 3.5,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Color(0xFF5A3831),
                                  size: 32,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

