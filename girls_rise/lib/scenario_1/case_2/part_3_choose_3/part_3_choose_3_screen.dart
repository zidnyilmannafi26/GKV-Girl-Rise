import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/reflection_text_box.dart';
import 'package:girls_rise/models/game_stats.dart';
import '../../case_3/part_1/part_1_screen.dart';

class Part3Choose3Screen extends StatefulWidget {
  const Part3Choose3Screen({super.key});

  @override
  State<Part3Choose3Screen> createState() => _Part3Choose3ScreenState();
}

class _Part3Choose3ScreenState extends State<Part3Choose3Screen> {
  void _nextStep() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Part1Screen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Design canvas dimensions (874 x 402)
    const double designWidth = 874.0;
    const double designHeight = 402.0;

    final double scaleX = screenWidth / designWidth;
    final double scaleY = screenHeight / designHeight;
    final double scale = min(scaleX, scaleY);
    final double activeCanvasWidth = designWidth * scale;
    final double activeCanvasHeight = designHeight * scale;
    final double offsetX = (screenWidth - activeCanvasWidth) / 2;
    final double offsetY = (screenHeight - activeCanvasHeight) / 2;

    return Scaffold(
      body: GestureDetector(
        onTap: _nextStep,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg1.2.png',
                fit: BoxFit.cover,
              ),
            ),

            // Karakter di tengah area kanan
            Positioned(
              left: offsetX + 530.0 * scale,
              bottom: -45.0 * scale,
              height: 360.0 * scale,
              child: Image.asset(
                'assets/images/cewe.nangis.png',
                fit: BoxFit.contain,
              ),
            ),

            // Reflection Text Box (Left side)
            Positioned(
              left: offsetX + 100.0 * scale,
              top: offsetY + 126.9 * scale,
              width: 303.5 * scale,
              height: 225.9 * scale,
              child: ReflectionTextBox(
                scale: scale,
                headerTabAsset: 'assets/text_Box/REFLECTION.svg',
                quoteText: 'Menjelaskan kalau sekolah juga penting.',
                reflectionText: 'Arga langsung mematikan telepon sepihak. Kamu berhasil menyelesaikan tugas, namun kamu merasa cemas karena merasa hubungan kalian akan hancur.',
                statChanges: const [
                  StatDelta(StatType.mental, 20),
                  StatDelta(StatType.pendidikan, 20),
                  StatDelta(StatType.relasi, -10),
                  StatDelta(StatType.ekonomi, 0),
                ],
              ),
            ),

            // Pill-shaped Back Button (top left)
            Positioned(
              top: 25,
              left: 25,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF7F0),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFB59D93), width: 1.5),
                  ),
                  child: Text(
                    '← BACK',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF765E54),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      letterSpacing: 1.0,
                    ),
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
