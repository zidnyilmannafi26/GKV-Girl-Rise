import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/audio_service.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _opacityAnim;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _opacityAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOutCubic,
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.45, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  void _navigateToHome() {
    if (_navigated || !mounted) return;
    _navigated = true;
    AudioService.instance.playImportantClickSfx();
    AudioService.instance.startBgm();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 900),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnim = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return ScaleTransition(
            scale: Tween<double>(begin: 1.12, end: 1.0).animate(curvedAnim),
            child: FadeTransition(opacity: curvedAnim, child: child),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    const double designWidth = 874.0;
    const double designHeight = 402.0;

    final double scaleX = screenSize.width / designWidth;
    final double scaleY = screenSize.height / designHeight;
    final double scale = min(scaleX, scaleY);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1412),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _navigateToHome,
        child: Stack(
          children: [
            // Ambient Background Image with dark vignette
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg.home.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF3A2E2A).withValues(alpha: 0.85),
                      const Color(0xFF1A1412).withValues(alpha: 0.95),
                    ],
                    radius: 1.3,
                  ),
                ),
              ),
            ),

            // Main Content Box
            Center(
              child: AnimatedBuilder(
                animation: _opacityAnim,
                builder: (context, child) {
                  return Opacity(opacity: _opacityAnim.value, child: child);
                },
                child: Container(
                  width: 620 * scale,
                  padding: EdgeInsets.symmetric(
                    horizontal: 38 * scale,
                    vertical: 28 * scale,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF7F0),
                    borderRadius: BorderRadius.circular(24 * scale),
                    border: Border.all(
                      color: const Color(0xFF765E54),
                      width: 2.5 * scale,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.55),
                        blurRadius: 30 * scale,
                        offset: Offset(0, 15 * scale),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Studio Title Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8 * scale),
                            decoration: BoxDecoration(
                              color: const Color(0xFF765E54).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12 * scale),
                            ),
                            child: Icon(
                              Icons.auto_awesome_rounded,
                              color: const Color(0xFF765E54),
                              size: 26 * scale,
                            ),
                          ),
                          SizedBox(width: 14 * scale),
                          Text(
                            'GIRL RISE STUDIO',
                            style: GoogleFonts.cinzel(
                              fontSize: 23 * scale,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF5A3831),
                              letterSpacing: 3.5,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16 * scale),
                      Divider(
                        color: const Color(0xFF765E54).withValues(alpha: 0.25),
                        thickness: 1.5 * scale,
                      ),
                      SizedBox(height: 16 * scale),

                      // Content Warning Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: const Color(0xFFDB2B2C),
                            size: 20 * scale,
                          ),
                          SizedBox(width: 8 * scale),
                          Text(
                            'PERINGATAN KONTEN & EMPATI',
                            style: GoogleFonts.poppins(
                              fontSize: 13.5 * scale,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFDB2B2C),
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14 * scale),

                      // Warning Text
                      Text(
                        'Game naratif ini mengangkat realitas sosial tentang pernikahan dini, dilema ekonomi, dan perjuangan pendidikan perempuan. Pilihan yang kamu ambil akan membentuk masa depan dan resiliensi mental karaktermu.\n\nLuangkan waktu untuk merenung di setiap keputusan.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lora(
                          fontSize: 13.8 * scale,
                          height: 1.65,
                          color: const Color(0xFF3D2B24),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 28 * scale),

                      // Pulsing CTA Button
                      AnimatedBuilder(
                        animation: _pulseAnim,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 0.97 + (_pulseAnim.value * 0.03),
                            child: Opacity(
                              opacity: 0.75 + (_pulseAnim.value * 0.25),
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24 * scale,
                            vertical: 11 * scale,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF765E54),
                            borderRadius: BorderRadius.circular(30 * scale),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF765E54).withValues(alpha: 0.35),
                                blurRadius: 10 * scale,
                                offset: Offset(0, 4 * scale),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.touch_app_rounded,
                                color: const Color(0xFFFDF7F0),
                                size: 16 * scale,
                              ),
                              SizedBox(width: 8 * scale),
                              Text(
                                'KETUK DI MANA SAJA UNTUK MELANJUTKAN',
                                style: GoogleFonts.poppins(
                                  fontSize: 12 * scale,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFFDF7F0),
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
