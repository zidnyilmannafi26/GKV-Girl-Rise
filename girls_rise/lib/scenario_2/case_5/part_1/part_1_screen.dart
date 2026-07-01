import 'package:girls_rise/utils/fade_page_route.dart';
import 'package:girls_rise/widgets/game_back_button.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/dialogue_text_box.dart';
import '../part_2/part_2_screen.dart';

import 'package:girls_rise/widgets/dynamic_character.dart';
import 'package:girls_rise/services/story_controller.dart';
import 'package:girls_rise/services/game_state_manager.dart';

class Part1Screen extends StatefulWidget {
  const Part1Screen({super.key});

  @override
  State<Part1Screen> createState() => _Part1ScreenState();
}

class _Part1ScreenState extends State<Part1Screen> {
  void _handleTap() {
    if (StoryController.instance.interceptTap()) return;
    Navigator.of(context).push(
      FadePageRoute(page: const Part2Screen()),
    );
  }

  Widget _buildDialogueContent(double scale) {
    final prev = GameStateManager.instance.getChoice('s2_case4');
    String text = 'Dua bulan berlalu, keadaan di rumah semakin sulit. Ayahmu mulai jarang bekerja sejak kondisi kesehatannya menurun. Sementara itu, biaya hidup terus berjalan, dan adikmu akan segera masuk sekolah dalam waktu dekat. Malam itu, setelah makan malam selesai, ayah memanggilmu untuk duduk di ruang tengah. Wajah kedua orang tuamu terlihat lebih lelah dari biasanya.';
    if (prev == 1) {
      text = 'Setelah kamu bercerita kepada teman tentang keadaan di rumah, dua bulan berlalu dan situasi justru semakin sulit. Ayahmu mulai jarang bekerja karena kesehatannya menurun. Malam itu, ayah memanggilmu untuk duduk di ruang tengah. Wajah kedua orang tuamu terlihat lebih lelah dari biasanya.';
    } else if (prev == 3) {
      text = 'Setelah kamu menceritakan semuanya kepada guru BK, dua bulan berlalu dan keadaan rumah tetap sulit. Ayahmu jarang bekerja karena sakit, biaya hidup terus berjalan. Malam itu, ayah memanggilmu. Wajah kedua orang tuamu terlihat sangat lelah.';
    }
    return RichText(
      text: TextSpan(
        style: GoogleFonts.lora(
          fontSize: 15.0 * scale,
          height: 1.5,
          color: const Color(0xFF765E54),
        ),
        text: text,
      ),
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

            // Bapak (Father)
            Positioned(
              left: offsetX + 293.0 * scale,
              bottom: 55.0 * scale,
              height: 318.0 * scale,
              child: DynamicCharacter(
                'assets/images/bapak.png',
                fit: BoxFit.contain,
              ),
            ),

            // Ibu (Mother)
            Positioned(
              left: offsetX + 438.99 * scale,
              bottom: 55.0 * scale,
              height: 318.0 * scale,
              child: DynamicCharacter(
                'assets/images/ibu.png',
                fit: BoxFit.contain,
              ),
            ),

            // Dialogue Text Box (includes background framing and header tab overlay)
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

            const GameBackButton(type: BackButtonType.scenarioRoot),
          ],
        ),
      ),
    );
  }
}
