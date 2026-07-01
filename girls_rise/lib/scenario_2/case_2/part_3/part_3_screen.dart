import 'package:girls_rise/utils/fade_page_route.dart';
import 'package:girls_rise/widgets/game_back_button.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:girls_rise/widgets/choice_text_box.dart';

import '../part_4_choose_1/part_4_choose_1_screen.dart';
import '../part_4_choose_2/part_4_choose_2_screen.dart';
import '../part_4_choose_3/part_4_choose_3_screen.dart';

import 'package:girls_rise/widgets/dynamic_character.dart';
import 'package:girls_rise/services/game_state_manager.dart';

class Part3Screen extends StatelessWidget {
  const Part3Screen({super.key});

  String _getChoice1Text() {
    final prev = GameStateManager.instance.getChoice('s2_case1');
    if (prev == 1) return 'Mengambil brosur beasiswa dengan antusias demi mengejar mimpimu';
    if (prev == 2) return 'Mengambil brosur beasiswa agar kamu tidak perlu bekerja paruh waktu';
    return 'Mengambil brosur beasiswa dan bertanya lebih lanjut.';
  }

  String _getChoice2Text() {
    final prev = GameStateManager.instance.getChoice('s2_case1');
    if (prev == 1) return 'Hanya melihat brosur dari jauh karena masih cemas akan biaya';
    if (prev == 2) return 'Hanya melihat brosur dari jauh karena merasa harus tetap bekerja';
    return 'Hanya melihat brosur dari jauh tanpa mengambilnya.';
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Design canvas dimensions (874 x 402)
    const double designWidth = 874.0;
    const double designHeight = 402.0;

    // Aspect-ratio locked containment scaling
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
              'assets/images/bg2.2.png',
              fit: BoxFit.cover,
            ),
          ),

          // Character
          Positioned(
            left: 0,
            right: 0,
            bottom: 55.0 * scale,
            height: 318.0 * scale,
            child: DynamicCharacter(
              'assets/images/cewe.bingung.png',
              fit: BoxFit.contain,
            ),
          ),

          // Choice Text Box (outcome & options)
          Positioned(
            left: offsetX + 87.0 * scale,
            bottom: 0,
            width: 700.0 * scale,
            height: 141.0 * scale,
            child: ChoiceTextBox(
              scale: scale,
              headerTabAsset: 'assets/text_Box/OUTCOME.svg',
              choice1Text: _getChoice1Text(),
              choice2Text: _getChoice2Text(),
              choice3Text: 'Keluar kelas sebelum sosialisasi selesai.',
              onChoice1Tap: () {
                Navigator.of(context).push(
                  FadePageRoute(page: const Part4Choose1Screen()),
                );
              },
              onChoice2Tap: () {
                Navigator.of(context).push(
                  FadePageRoute(page: const Part4Choose2Screen()),
                );
              },
              onChoice3Tap: () {
                Navigator.of(context).push(
                  FadePageRoute(page: const Part4Choose3Screen()),
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
