import 'package:girls_rise/widgets/game_back_button.dart';
import 'package:girls_rise/utils/fade_page_route.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/dialogue_text_box.dart';
import '../part_3/part_3_screen.dart';

import 'package:girls_rise/widgets/dynamic_character.dart';
import 'package:girls_rise/services/story_controller.dart';

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
    final double offsetX = (screenWidth - activeCanvasWidth) / 2;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (StoryController.instance.interceptTap()) return;
          Navigator.of(context).push(
            FadePageRoute(page: const Part3Screen())
          );
        },
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg1.1.png',
                fit: BoxFit.cover,
              ),
            ),

            // Karakter 1 (cewe)
            Positioned(
              left: offsetX + 270.0 * scale,
              bottom: 55.0 * scale,
              height: 318.0 * scale,
              child: DynamicCharacter(
                'assets/images/cewe.bingung.png',
                fit: BoxFit.contain,
              ),
            ),

            // Karakter 2 (cowo)
            Positioned(
              left: offsetX + 430.0 * scale,
              bottom: 55.0 * scale,
              height: 318.0 * scale,
              child: DynamicCharacter(
                'assets/images/cowo.senang.png',
                fit: BoxFit.contain,
              ),
            ),

            // Dialogue Text Box
            Positioned(
              left: offsetX + 87.0 * scale,
              bottom: 0,
              width: 700.0 * scale,
              height: 141.0 * scale,
              child: DialogueTextBox(
                scale: scale,
                width: 700.0,
                height: 141.0,
                headerTabAsset: 'assets/text_Box/Ajakan Menikah Muda.svg',
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
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Arga:',
                            style: GoogleFonts.lora(
                              fontSize: 14.5 * scale,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF765E54),
                            ),
                          ),
                          SizedBox(height: 4.0 * scale),
                          Text(
                            'Kita udah hampir 4 tahun bareng. Aku capek cuma pacaran terus. Kalau kamu serius sama aku... Nikah aja sama aku. Aku takut suatu hari kamu ninggalin aku.',
                            style: GoogleFonts.lora(
                              fontSize: 14.5 * scale,
                              height: 1.5,
                              color: const Color(0xFF765E54),
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const GameBackButton(type: BackButtonType.normalBack),
          ],
        ),
      ),
    );
  }
}
