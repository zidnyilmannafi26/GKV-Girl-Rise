import 'package:girls_rise/widgets/game_back_button.dart';
import 'package:girls_rise/utils/fade_page_route.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:girls_rise/widgets/reflection_text_box.dart';
import 'package:girls_rise/models/game_stats.dart';
import 'package:girls_rise/services/game_state_manager.dart';
import '../../outcome_1/outcome_putus/outcome_putus_screen.dart';

import 'package:girls_rise/widgets/dynamic_character.dart';
import 'package:girls_rise/services/story_controller.dart';

class Part3Choose2Screen extends StatefulWidget {
  const Part3Choose2Screen({super.key});

  @override
  State<Part3Choose2Screen> createState() => _Part3Choose2ScreenState();
}

class _Part3Choose2ScreenState extends State<Part3Choose2Screen> {
  void _nextStep() {
    if (StoryController.instance.interceptTap()) return;
    GameStateManager.instance.setEndingMode(true);
    Navigator.of(context).push(
      FadePageRoute(page: const OutcomePutusScreen()),
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
                'assets/images/bg1.6.png',
                fit: BoxFit.cover,
              ),
            ),

            // Karakter 2 (cewe.senang) - di kiri menempel
            Positioned(
              left: offsetX + 415.0 * scale,
              bottom: -40.0 * scale,
              height: 358.0 * scale,
              child: DynamicCharacter(
                'assets/images/cewe.senang.png',
                fit: BoxFit.contain,
              ),
            ),

            // Karakter 1 (cowo.marah) - di kanan
            Positioned(
              left: offsetX + 535.0 * scale,
              bottom: -40.0 * scale,
              height: 358.0 * scale,
              child: DynamicCharacter(
                'assets/images/cowo.marah.png',
                fit: BoxFit.contain,
              ),
            ),

            // Reflection Text Box (Left side) - Tanpa Teks Refleksi bawah
            Positioned(
              left: offsetX + 100.0 * scale,
              top: offsetY + 126.9 * scale,
              width: 303.5 * scale,
              height: 225.9 * scale,
              child: ReflectionTextBox(
                scale: scale,
                headerTabAsset: 'assets/text_Box/REFLECTION.svg',
                quoteText: 'Menolak dengan tegas dan menjaga batasan',
                reflectionText: 'Kamu mempertahankan hargadirimu dan menyadari nilai dirimu lebih penting daripada sebuah hubungan toksik. Kamu merasa lega dan fokus belajar pun meningkat pesat.',
                statChanges: const [
                  StatDelta(StatType.relasi, -50),
                  StatDelta(StatType.pendidikan, 50),
                  StatDelta(StatType.mental, 50),
                  StatDelta(StatType.ekonomi, 50),
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
