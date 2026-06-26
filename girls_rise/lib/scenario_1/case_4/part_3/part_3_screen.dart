import 'package:girls_rise/widgets/game_back_button.dart';
import 'package:girls_rise/utils/fade_page_route.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/choice_text_box.dart';
import '../part_3_choose_1/part_3_choose_1_screen.dart';
import '../part_3_choose_2/part_3_choose_2_screen.dart';
import '../part_3_choose_3/part_3_choose_3_screen.dart';

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
              'assets/images/bg1.3.png',
              fit: BoxFit.cover,
            ),
          ),

          // Karakter di tengah
          Positioned(
            left: 0,
            right: 0,
            bottom: 55.0 * scale,
            height: 318.0 * scale,
            child: Image.asset(
              'assets/images/cewe.nangis.mataterbuka.png',
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
              choice1Text: 'Memblokir nomor teman cowokmu demi menenangkan pacar',
              choice2Text: 'Meminta maaf dan berbohong di kemudian hari jika ada kerja kelompok',
              choice3Text: 'Tegas menjelaskan bahwa itu hanya urusan sekolah',
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
              onChoice3Tap: () {
                Navigator.of(context).push(
                  FadePageRoute(page: const Part3Choose3Screen())
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
