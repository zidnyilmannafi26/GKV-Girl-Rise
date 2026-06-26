import 'package:girls_rise/utils/fade_page_route.dart';
import 'package:girls_rise/widgets/game_back_button.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/reflection_text_box.dart';
import 'package:girls_rise/models/game_stats.dart';
import '../../case_2/part_1/part_1_screen.dart';

class Part4Choose3Screen extends StatefulWidget {
  const Part4Choose3Screen({super.key});

  @override
  State<Part4Choose3Screen> createState() => _Part4Choose3ScreenState();
}

class _Part4Choose3ScreenState extends State<Part4Choose3Screen> {
  void _nextStep() {
    Navigator.of(context).push(
      FadePageRoute(page: const Part1Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Design canvas dimensions (874 x 402)
    const double designWidth = 874.0;
    const double designHeight = 402.0;

    // Aspect-ratio locked containment scaling
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
                'assets/images/bg2.1.png',
                fit: BoxFit.cover,
              ),
            ),

            // Character (Right side - Enlarged and anchored to bottom-right edge)
            Positioned(
              left: offsetX + 450.0 * scale,
              bottom: 0,
                            height: 318.0 * scale,
              child: Image.asset(
                'assets/images/ibu.bapak.biasa.png',
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
                quoteText: '“Aku lagi banyak tugas, kita obrolin lagi besok ya.”',
                reflectionText: 'Kamu mencoba mengalihkan pembicaraan dan kembali ke kamar. Namun malam itu, tugas sekolah terasa jauh lebih berat karena pikiranmu yang penuh.',
                statChanges: const [
                  StatDelta(StatType.mental, -10),
                  StatDelta(StatType.pendidikan, 10),
                  StatDelta(StatType.ekonomi, 0),
                  StatDelta(StatType.relasi, -10),
                ],
              ),
            ),

            const GameBackButton(type: BackButtonType.hidden),
          ],
        ),
      ),
    );
  }
}
