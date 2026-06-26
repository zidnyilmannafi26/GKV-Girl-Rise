import 'package:girls_rise/widgets/game_back_button.dart';
import 'package:girls_rise/utils/fade_page_route.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/reflection_text_box.dart';
import 'package:girls_rise/models/game_stats.dart';
import '../../case_5/part_1/part_1_screen.dart';

class Part3Choose1Screen extends StatefulWidget {
  const Part3Choose1Screen({super.key});

  @override
  State<Part3Choose1Screen> createState() => _Part3Choose1ScreenState();
}

class _Part3Choose1ScreenState extends State<Part3Choose1Screen> {
  void _nextStep() {
    Navigator.of(context).push(
      FadePageRoute(page: const Part1Screen())
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
                'assets/images/bg1.3.png',
                fit: BoxFit.cover,
              ),
            ),

            // Karakter di kanan reflection frame digeser agak ke kiri
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
                quoteText: 'Memblokir nomor teman cowokmu demi menenangkan pacar',
                reflectionText: 'Hubunganmu dan Arga aman kembali, namun kamu mulai dikucilkan dari kelompok belajar di kelas karena dinilai tidak profesional.',
                statChanges: const [
                  StatDelta(StatType.relasi, 20),
                  StatDelta(StatType.mental, -20),
                  StatDelta(StatType.pendidikan, -20),
                  StatDelta(StatType.ekonomi, 0),
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
