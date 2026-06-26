import 'package:girls_rise/widgets/game_back_button.dart';
import 'package:girls_rise/utils/fade_page_route.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/reflection_text_box.dart';
import 'package:girls_rise/models/game_stats.dart';
import '../../case_4/part_1/part_1_screen.dart';

class Part2Choose2Screen extends StatefulWidget {
  const Part2Choose2Screen({super.key});

  @override
  State<Part2Choose2Screen> createState() => _Part2Choose2ScreenState();
}

class _Part2Choose2ScreenState extends State<Part2Choose2Screen> {
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

            // Karakter utama (cewe.senyum)
            Positioned(
              left: offsetX + 480.0 * scale,
              bottom: 0,
              height: 318.0 * scale,
              child: Image.asset(
                'assets/images/cewe.senyum.png',
                fit: BoxFit.contain,
              ),
            ),

            // Karakter bayangan cewe.bingung dengan Opacity 60% persis di samping kanan menempel sedikit
            Positioned(
              left: offsetX + 590.0 * scale,
              bottom: 0,
              height: 318.0 * scale,
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  'assets/images/cewe.bingung.png',
                  fit: BoxFit.contain,
                ),
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
                quoteText: 'Diam dan Curhat ke teman saja',
                reflectionText: 'Kamu hanya tersenyum pada Ibu lalu mengetik pesan panjang ke sahabatmu. Temanmu mendengarkan, tapi dia sendiri bingung harus memberi solusi apa.',
                statChanges: const [
                  StatDelta(StatType.mental, 10),
                  StatDelta(StatType.relasi, 10),
                  StatDelta(StatType.pendidikan, 0),
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
