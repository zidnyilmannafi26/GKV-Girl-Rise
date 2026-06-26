import 'package:girls_rise/widgets/game_back_button.dart';
import 'package:girls_rise/utils/fade_page_route.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/reflection_text_box.dart';
import 'package:girls_rise/models/game_stats.dart';
import '../../case_2/part_1/part_1_screen.dart';

class Part4Choose2Screen extends StatefulWidget {
  const Part4Choose2Screen({super.key});

  @override
  State<Part4Choose2Screen> createState() => _Part4Choose2ScreenState();
}

class _Part4Choose2ScreenState extends State<Part4Choose2Screen> {
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
                'assets/images/bg1.1.png',
                fit: BoxFit.cover,
              ),
            ),

            // Karakter 1 (cewe) - kanan tapi digeser ke kiri
            Positioned(
              left: offsetX + 415.0 * scale,
              bottom: 0,
              height: 318.0 * scale,
              child: Image.asset(
                'assets/images/cewe.bingung.png',
                fit: BoxFit.contain,
              ),
            ),

            // Karakter 2 (cowo)
            Positioned(
              left: offsetX + 535.0 * scale,
              bottom: 0,
              height: 318.0 * scale,
              child: Image.asset(
                'assets/images/cowo.marah.png',
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
                quoteText: 'Mungkin bisa kita obrolin lebih jelas dulu? Aku masih belum yakin.',
                reflectionText: 'Kalian mulai membicarakan masa depan. Namun, kamu menyadari bahwa ia lebih fokus pada perasaannya sendiri daripada kesiapan kalian berdua. Arga memotong: Diskusi apa lagi? Kesiapan itu dibangun bareng setelah nikah!',
                statChanges: const [
                  StatDelta(StatType.relasi, -10),
                  StatDelta(StatType.mental, 10),
                  StatDelta(StatType.pendidikan, 10),
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
