import 'package:girls_rise/widgets/game_back_button.dart';
import 'package:girls_rise/utils/fade_page_route.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/reflection_text_box.dart';
import 'package:girls_rise/models/game_stats.dart';
import '../../case_6/part_1/part_1_screen.dart';

class Part2Choose3Screen extends StatefulWidget {
  const Part2Choose3Screen({super.key});

  @override
  State<Part2Choose3Screen> createState() => _Part2Choose3ScreenState();
}

class _Part2Choose3ScreenState extends State<Part2Choose3Screen> {
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
                'assets/images/bg1.5.png',
                fit: BoxFit.cover,
              ),
            ),

            // Karakter 2 (cewe.bingung) - di kiri
            Positioned(
              left: offsetX + 415.0 * scale,
              bottom: 0,
              height: 318.0 * scale,
              child: Image.asset(
                'assets/images/cewe.bingung.png',
                fit: BoxFit.contain,
              ),
            ),

            // Karakter 1 (cowo.natap.kiri) - di kanan
            Positioned(
              left: offsetX + 535.0 * scale,
              bottom: 0,
              height: 318.0 * scale,
              child: Image.asset(
                'assets/images/cowo.natap.kiri.png',
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
                quoteText: 'Datang sebentar untuk merayakan lalu pulang cepat untuk belajar',
                reflectionText: 'Kamu datang ke lokasi untuk menjaga perasaannya, namun hanya bertahan satu jam lalu pamit pulang. Arga agak cemberut, dan waktu belajarmu di rumah tetap terpotong.',
                statChanges: const [
                  StatDelta(StatType.mental, 10),
                  StatDelta(StatType.pendidikan, 10),
                  StatDelta(StatType.relasi, 10),
                  StatDelta(StatType.ekonomi, -10),
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
