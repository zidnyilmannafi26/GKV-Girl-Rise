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
          'Ibu',
          '“Ayah sama Ibu cuma berpikir… mungkin kalau ada yang bisa jaga dan tanggung jawab sama kamu… hidup kamu bisa lebih aman.”',
          scale,
        ),
        SizedBox(height: 12.0 * scale),
        _buildDialogueLine(
          'Ayah',
          '“Menurut kamu gimana, Nak?”',
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
                'assets/images/bg2.1.png',
                fit: BoxFit.cover,
              ),
            ),

            // Bapak Marah (Angry Father)
            Positioned(
              left: offsetX + 284.0 * scale,
              bottom: 55.0 * scale,
              height: 318.0 * scale,
              child: Image.asset(
                'assets/images/bapak.marah.png',
                fit: BoxFit.contain,
              ),
            ),

            // Ibu Marah Bawah (Angry Mother Lower)
            Positioned(
              left: offsetX + 425.662 * scale,
              bottom: 55.0 * scale,
              height: 318.0 * scale,
              child: Image.asset(
                'assets/images/ibu.marah.bawah.png',
                fit: BoxFit.contain,
              ),
            ),

            // Textbox Container
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
                headerTabAsset: 'assets/text_Box/Obrolan tak terduga.svg',
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
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: SizedBox(
                        key: const ValueKey<String>('part_2_dialogue'),
                        width: double.infinity,
                        child: _buildDialogueContent(scale),
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
