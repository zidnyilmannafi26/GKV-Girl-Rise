import 'package:girls_rise/widgets/game_back_button.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/dialogue_text_box.dart';
import '../part_3/part_3_screen.dart';

class Part2Screen extends StatefulWidget {
  const Part2Screen({super.key});

  @override
  State<Part2Screen> createState() => _Part2ScreenState();
}

class _Part2ScreenState extends State<Part2Screen> {
  void _handleTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Part3Screen(),
      ),
    );
  }

  Widget _buildDialogueContent(double scale) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.lora(
          fontSize: 15.0 * scale,
          height: 1.5,
          color: const Color(0xFF765E54),
        ),
        text: 'Teman-temanmu mulai membicarakan kampus impian mereka seolah hal itu mudah dicapai. Kamu menatap brosur di meja depan kelas. Untuk sesaat, harapan kecil mulai muncul… tetapi bayangan percakapan dengan orang tuamu kembali terlintas di pikiran. Apa yang akan kamu lakukan?',
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
    final double activeCanvasHeight = designHeight * scale;
    final double offsetX = (screenWidth - activeCanvasWidth) / 2;
    final double offsetY = (screenHeight - activeCanvasHeight) / 2;

    return Scaffold(
      body: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            // Background image
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
              child: Image.asset(
                'assets/images/cewe.bingung.png',
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
                headerTabAsset: 'assets/text_Box/Mimpi vs Realitas.svg',
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
