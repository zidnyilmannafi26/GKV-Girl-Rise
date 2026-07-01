import 'package:girls_rise/utils/fade_page_route.dart';
import 'package:girls_rise/widgets/game_back_button.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:girls_rise/widgets/reflection_text_box.dart';
import 'package:girls_rise/models/game_stats.dart';
import 'package:girls_rise/services/game_state_manager.dart';
import 'package:girls_rise/scenario_2/outcome_2/outcome_nikahmuda2/outcome_nikahmuda2_screen.dart';

import 'package:girls_rise/widgets/dynamic_character.dart';
import 'package:girls_rise/services/story_controller.dart';

class Part4Choose1Screen extends StatefulWidget {
  const Part4Choose1Screen({super.key});

  @override
  State<Part4Choose1Screen> createState() => _Part4Choose1ScreenState();
}

class _Part4Choose1ScreenState extends State<Part4Choose1Screen> {
  void _nextStep() {
    if (StoryController.instance.interceptTap()) return;
    GameStateManager.instance.setEndingMode(true);
    Navigator.of(context).push(
      FadePageRoute(page: const OutcomeNikahMuda2Screen()),
    );
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
                'assets/images/bg2.5.png',
                fit: BoxFit.cover,
              ),
            ),

            // Character (Right side)
            Positioned(
              left: offsetX + 450.0 * scale,
              bottom: -45.0 * scale,
              height: 360.0 * scale,
              child: DynamicCharacter(
                'assets/images/cewe.nangis.mataterbuka.png',
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
                quoteText: 'Mengiyakan keputusan keluarga.',
                reflectionText: 'Dengan berat hati, kamu menerima keputusan orang tuamu demi meringankan beban mereka. Langkah ini terasa sangat berat, karena kamu sadar bahwa impianmu untuk bersekolah harus dikesampingkan demi kelangsungan hidup keluarga.',
                statChanges: const [
                  StatDelta(StatType.pendidikan, -20),
                  StatDelta(StatType.mental, -20),
                  StatDelta(StatType.relasi, 20),
                  StatDelta(StatType.ekonomi, 20),
                ],
                caseId: 's2_case5',
                choiceIndex: 1,
              ),
            ),

            const GameBackButton(type: BackButtonType.hidden),
          ],
        ),
      ),
    );
  }
}
