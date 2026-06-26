import 'package:girls_rise/widgets/game_back_button.dart';
import 'package:girls_rise/utils/fade_page_route.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/dialogue_text_box.dart';
import '../part_2/part_2_screen.dart';

import 'package:girls_rise/widgets/dynamic_character.dart';
import 'package:girls_rise/services/story_controller.dart';

class Part1Screen extends StatelessWidget {
  const Part1Screen({super.key});

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
      body: GestureDetector(
        onTap: () {
          if (StoryController.instance.interceptTap()) return;
          Navigator.of(context).push(
            FadePageRoute(page: const Part2Screen())
          );
        },
        behavior: HitTestBehavior.translucent,
        child: Stack(
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
              child: DynamicCharacter(
                'assets/images/cewe.bingung.png',
                fit: BoxFit.contain,
              ),
            ),

            // Karakter 1 (cowo.senang) - kanan
            Positioned(
              left: offsetX + 430.0 * scale,
              bottom: 55.0 * scale,
              height: 318.0 * scale,
              child: DynamicCharacter(
                'assets/images/cowo.senang.png',
                fit: BoxFit.contain,
              ),
            ),

            // Dialogue Text Box (Centered at bottom)
            Positioned(
              left: offsetX + (designWidth - 763.4) / 2 * scale,
              bottom: 0,
              width: 763.4 * scale,
              height: 145.0 * scale,
              child: DialogueTextBox(
                scale: scale,
                width: 763.4,
                height: 145.0,
                headerTabAsset: 'assets/text_Box/Ajakan Pesta.svg',
                headerTabWidth: 327.0,
                headerTabHeight: 49.0,
                headerTabLeft: 24.0,
                headerTabTop: -44.0,
                contentPadding: EdgeInsets.fromLTRB(
                  41.0 * scale,
                  15.0 * scale,
                  35.0 * scale,
                  35.0 * scale,
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Text(
                      'Arga berhasil diterima magang di perusahaan terbaik yang sejak lama ia impikan. Malam ini, ia mengajakmu dan teman-teman kuliahnya untuk party dan merayakan keberhasilannya di sebuah club malam. Di sisi lain, kamu harus mempersiapkan materi belajar untuk membawakan presentasi penting besok pagi di kelasmu.',
                      style: GoogleFonts.lora(
                        fontSize: 14.5 * scale,
                        height: 1.5,
                        color: const Color(0xFF765E54),
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ),
            ),

            const GameBackButton(type: BackButtonType.scenarioRoot),
          ],
        ),
      ),
    );
  }
}
