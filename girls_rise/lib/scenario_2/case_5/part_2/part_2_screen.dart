import 'package:girls_rise/utils/fade_page_route.dart';
import 'package:girls_rise/widgets/game_back_button.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/dialogue_text_box.dart';
import '../part_2_1/part_2_1_screen.dart';

import 'package:girls_rise/widgets/dynamic_character.dart';
import 'package:girls_rise/services/story_controller.dart';

class Part2Screen extends StatefulWidget {
  const Part2Screen({super.key});

  @override
  State<Part2Screen> createState() => _Part2ScreenState();
}

class _Part2ScreenState extends State<Part2Screen> {
  void _handleTap() {
    if (StoryController.instance.interceptTap()) return;
    Navigator.of(context).push(
      FadePageRoute(page: const Part21Screen()),
    );
  }

  Widget _buildDialogueLine(String speaker, String text, double scale) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.lora(
          fontSize: 15.0 * scale,
          height: 1.5,
          color: const Color(0xFF765E54),
        ),
        children: [
          TextSpan(
            text: '$speaker: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: text),
        ],
      ),
    );
  }

  Widget _buildDialogueContent(double scale) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDialogueLine(
          'Ayah',
          'Ayah udah nggak sekuat dulu… Sebentar lagi adikmu juga mulai masuk sekolah. Biayanya pasti tambah banyak. Ayah cuma mikir… mungkin kamu bisa mulai ngalah sedikit demi keluarga.',
          scale,
        ),
        SizedBox(height: 12.0 * scale),
        _buildDialogueLine(
          'Ibu',
          'Kami cuma nggak mau kamu ikut susah terus.',
          scale,
        ),
      ],
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
    final double offsetX = (screenWidth - activeCanvasWidth) / 2;

    return Scaffold(
      body: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg2.5.png',
                fit: BoxFit.cover,
              ),
            ),

            // Bapak Marah
            Positioned(
              left: offsetX + 284.0 * scale,
              bottom: 55.0 * scale,
              height: 318.0 * scale,
              child: DynamicCharacter(
                'assets/images/bapak.marah.png',
                fit: BoxFit.contain,
              ),
            ),

            // Ibu Marah Bawah
            Positioned(
              left: offsetX + 425.662 * scale,
              bottom: 55.0 * scale,
              height: 318.0 * scale,
              child: DynamicCharacter(
                'assets/images/ibu.marah.bawah.png',
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
                headerTabAsset: 'assets/text_Box/Persimpangan masa depan.svg',
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
                      child: _buildDialogueContent(scale),
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
