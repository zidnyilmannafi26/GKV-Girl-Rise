import 'package:girls_rise/utils/fade_page_route.dart';
import 'package:girls_rise/widgets/game_back_button.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:girls_rise/widgets/reflection_text_box.dart';
import 'package:girls_rise/models/game_stats.dart';
import '../../case_4/part_1/part_1_screen.dart';

import 'package:girls_rise/widgets/dynamic_character.dart';
import 'package:girls_rise/services/story_controller.dart';

class Part4Choose2Screen extends StatefulWidget {
  const Part4Choose2Screen({super.key});

  @override
  State<Part4Choose2Screen> createState() => _Part4Choose2ScreenState();
}

class _Part4Choose2ScreenState extends State<Part4Choose2Screen> {
  void _nextStep() {
    if (StoryController.instance.interceptTap()) return;
    Navigator.of(context).push(
      FadePageRoute(page: const Part1Screen()),
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
                'assets/images/bg2.1.png',
                fit: BoxFit.cover,
              ),
            ),

            // Character (Right side)
            Positioned(
              left: offsetX + 450.0 * scale,
              bottom: -40.0 * scale,
              height: 358.0 * scale,
              child: DynamicCharacter(
                'assets/images/cewe.bingung.png',
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
                quoteText: 'Memilih diam dan mendengarkan saja.',
                reflectionText: 'Kamu hanya menunduk dan mengehela napas gusar. Semakin lama kamu diam, semakin sulit rasanya untuk menyampaikan apa yang sebenarnya kamu inginkan.',
                statChanges: const [
                  StatDelta(StatType.pendidikan, -10),
                  StatDelta(StatType.mental, -10),
                  StatDelta(StatType.relasi, 10),
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
