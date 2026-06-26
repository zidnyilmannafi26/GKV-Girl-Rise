import 'package:girls_rise/widgets/game_back_button.dart';
import 'package:girls_rise/utils/fade_page_route.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/reflection_text_box.dart';
import 'package:girls_rise/models/game_stats.dart';
import '../../../screens/home_screen.dart';

class Part3Choose1Screen extends StatefulWidget {
  const Part3Choose1Screen({super.key});

  @override
  State<Part3Choose1Screen> createState() => _Part3Choose1ScreenState();
}

class _Part3Choose1ScreenState extends State<Part3Choose1Screen> {
  void _nextStep() {
    Navigator.of(context).pushAndRemoveUntil(
      FadePageRoute(page: const HomeScreen()),
      (route) => false,
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
                'assets/images/bg1.6.png',
                fit: BoxFit.cover,
              ),
            ),

            // Karakter 2 (cewe.bingung) - di kiri menempel
            Positioned(
              left: offsetX + 415.0 * scale,
              bottom: 0,
              height: 318.0 * scale,
              child: Image.asset(
                'assets/images/cewe.bingung.png',
                fit: BoxFit.contain,
              ),
            ),

            // Karakter 1 (cowo.senang) - di kanan
            Positioned(
              left: offsetX + 535.0 * scale,
              bottom: 0,
              height: 318.0 * scale,
              child: Image.asset(
                'assets/images/cowo.senang.png',
                fit: BoxFit.contain,
              ),
            ),

            // Reflection Text Box (Left side) - Tanpa Teks Refleksi bawah
            Positioned(
              left: offsetX + 100.0 * scale,
              top: offsetY + 126.9 * scale,
              width: 303.5 * scale,
              height: 225.9 * scale,
              child: ReflectionTextBox(
                scale: scale,
                headerTabAsset: 'assets/text_Box/REFLECTION.svg',
                quoteText: 'Menuruti Keinginan Arga',
                reflectionText: 'Kamu merasa bersalah dan melanggar prinsipmu sendiri. Rasa hormat pada diri sendiri menurun drastis, dan kamu terus kepikiran hingga tidak fokus belajar.',
                statChanges: const [
                  StatDelta(StatType.relasi, 50),
                  StatDelta(StatType.pendidikan, -50),
                  StatDelta(StatType.mental, -50),
                  StatDelta(StatType.ekonomi, -50),
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
