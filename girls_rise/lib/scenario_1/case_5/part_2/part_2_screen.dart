import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/choice_text_box.dart';
import '../part_2_choose_1/part_2_choose_1_screen.dart';
import '../part_2_choose_2/part_2_choose_2_screen.dart';
import '../part_2_choose_3/part_2_choose_3_screen.dart';

class Part2Screen extends StatelessWidget {
  const Part2Screen({super.key});

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
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg1.5.png',
              fit: BoxFit.cover,
            ),
          ),

          // Karakter 2 (cewe.bingung) - kiri
          Positioned(
            left: offsetX + 180.0 * scale,
            bottom: 55.0 * scale,
            height: 318.0 * scale,
            child: Image.asset(
              'assets/images/cewe.bingung.png',
              fit: BoxFit.contain,
            ),
          ),

          // Karakter 1 (cowo.senang) - kanan
          Positioned(
            left: offsetX + 430.0 * scale,
            bottom: 55.0 * scale,
            height: 318.0 * scale,
            child: Image.asset(
              'assets/images/cowo.senang.png',
              fit: BoxFit.contain,
            ),
          ),

          // Choice Text Box (Centered at bottom)
          Positioned(
            left: offsetX + (designWidth - 763.4) / 2 * scale,
            bottom: 0,
            width: 763.4 * scale,
            height: 145.0 * scale,
            child: ChoiceTextBox(
              scale: scale,
              headerTabAsset: 'assets/text_Box/DECISION.svg',
              choice1Text: 'Ikut Arga ke club malam demi merayakan momen keberhasilannya',
              choice2Text: 'Menolak dan tetap di rumah untuk belajar presentasi',
              choice3Text: 'Datang sebentar untuk merayakan lalu pulang cepat untuk belajar',
              onChoice1Tap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Part2Choose1Screen(),
                  ),
                );
              },
              onChoice2Tap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Part2Choose2Screen(),
                  ),
                );
              },
              onChoice3Tap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Part2Choose3Screen(),
                  ),
                );
              },
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
    );
  }
}
