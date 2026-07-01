import 'package:girls_rise/widgets/game_back_button.dart';
import 'package:girls_rise/utils/fade_page_route.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:girls_rise/widgets/choice_text_box.dart';
import '../part_2_choose_1/part_2_choose_1_screen.dart';
import '../part_2_choose_2/part_2_choose_2_screen.dart';
import '../part_2_choose_3/part_2_choose_3_screen.dart';

import 'package:girls_rise/widgets/dynamic_character.dart';
import 'package:girls_rise/services/game_state_manager.dart';

class Part2Screen extends StatelessWidget {
  const Part2Screen({super.key});

  String _getChoice1Text() {
    final prev = GameStateManager.instance.getChoice('s1_case2');
    if (prev == 1) return 'Jujur kepada Ibu bahwa kamu terbebani tuntutan waktu dari Arga';
    return 'Jujur kepada Ibu tentang masalahmu';
  }

  String _getChoice2Text() {
    final prev = GameStateManager.instance.getChoice('s1_case2');
    if (prev == 2) return 'Diam dan memendam rasa stres ini lalu curhat ke teman saja';
    return 'Diam dan curhat ke teman saja';
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
    final double offsetX = (screenWidth - activeCanvasWidth) / 2;

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

          // Karakter 1 (ibu) - kiri tengah
          Positioned(
            left: offsetX + 180.0 * scale,
            bottom: 55.0 * scale,
            height: 318.0 * scale,
            child: DynamicCharacter(
              'assets/images/ibu.marah.png',
              fit: BoxFit.contain,
            ),
          ),

          // Karakter 2 (cewe) - kanan tengah
          Positioned(
            left: offsetX + 430.0 * scale,
            bottom: 55.0 * scale,
            height: 318.0 * scale,
            child: DynamicCharacter(
              'assets/images/cewe.bingung.png',
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
              choice1Text: _getChoice1Text(),
              choice2Text: _getChoice2Text(),
              choice3Text: 'Berbohong bahwa semua baik-baik saja',
              onChoice1Tap: () {
                Navigator.of(context).push(
                  FadePageRoute(page: const Part2Choose1Screen())
                );
              },
              onChoice2Tap: () {
                Navigator.of(context).push(
                  FadePageRoute(page: const Part2Choose2Screen())
                );
              },
              onChoice3Tap: () {
                Navigator.of(context).push(
                  FadePageRoute(page: const Part2Choose3Screen())
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
