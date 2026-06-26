import 'package:girls_rise/widgets/game_back_button.dart';
import 'package:girls_rise/utils/fade_page_route.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/choice_text_box.dart';
import '../part_4_choose_1/part_4_choose_1_screen.dart';
import '../part_4_choose_2/part_4_choose_2_screen.dart';

class Part4Screen extends StatelessWidget {
  const Part4Screen({super.key});

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
              'assets/images/bg1.1.png',
              fit: BoxFit.cover,
            ),
          ),

          // Character (Center)
          Positioned(
            left: 0,
            right: 0,
            bottom: 55.0 * scale,
            height: 318.0 * scale,
            child: Image.asset(
              'assets/images/cewe.bingung.png',
              fit: BoxFit.contain,
            ),
          ),

          // Choice Text Box
          Positioned(
            left: offsetX + 87.0 * scale,
            bottom: 0,
            width: 700.0 * scale,
            height: 141.0 * scale,
            child: ChoiceTextBox(
              scale: scale,
              headerTabAsset: 'assets/text_Box/DECISION.svg',
              choice1Text: 'Apa Bisa ditunda dulu? Aku masih pengen lulus SMA dan kuliah',
              choice2Text: 'Mungkin bisa kita obrolin lebih jelas dulu? Aku masih belum yakin.',
              onChoice1Tap: () {
                Navigator.of(context).push(
                  FadePageRoute(page: const Part4Choose1Screen())
                );
              },
              onChoice2Tap: () {
                Navigator.of(context).push(
                  FadePageRoute(page: const Part4Choose2Screen())
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
