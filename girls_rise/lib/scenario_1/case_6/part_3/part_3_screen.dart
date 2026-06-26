import 'package:girls_rise/widgets/game_back_button.dart';
import 'package:girls_rise/utils/fade_page_route.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/choice_text_box.dart';
import '../part_3_choose_1/part_3_choose_1_screen.dart';
import '../part_3_choose_2/part_3_choose_2_screen.dart';

class Part3Screen extends StatelessWidget {
  const Part3Screen({super.key});

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
              'assets/images/bg1.6.png',
              fit: BoxFit.cover,
            ),
          ),

          // Karakter 1 (cewe.senang) - kiri
          Positioned(
            left: offsetX + 180.0 * scale,
            bottom: 55.0 * scale,
            height: 318.0 * scale,
            child: Image.asset(
              'assets/images/cewe.senang.png',
              fit: BoxFit.contain,
            ),
          ),

          // Karakter 2 (cowo.senang) - kanan
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
              choice1Text: 'Menuruti Keinginan Arga',
              choice2Text: 'Menolak dengan tegas dan menjaga batasan',
              onChoice1Tap: () {
                Navigator.of(context).push(
                  FadePageRoute(page: const Part3Choose1Screen())
                );
              },
              onChoice2Tap: () {
                Navigator.of(context).push(
                  FadePageRoute(page: const Part3Choose2Screen())
                );
              },
            ),
          ),

          const GameBackButton(type: BackButtonType.normalBack),
        ],
      ),
    );
  }
}
