import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/dialogue_text_box.dart';
import '../part_2/part_2_screen.dart';

class Part1Screen extends StatefulWidget {
  const Part1Screen({super.key});

  @override
  State<Part1Screen> createState() => _Part1ScreenState();
}

class _Part1ScreenState extends State<Part1Screen> {
  int _currentStep = 0;

  void _handleTap() {
    if (_currentStep < 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const Part2Screen(),
        ),
      );
    }
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
    if (_currentStep == 0) {
      return _buildDialogueLine(
        'Ibu',
        '“Nak… akhir-akhir ini Ayah dan Ibu lagi kepikiran soal masa depan kamu.”',
        scale,
      );
    } else {
      return _buildDialogueLine(
        'Ayah',
        '“Kemarin Ayah ketemu teman kerja lama. Dia cerita kalau anaknya sekarang sudah kerja tetap… orangnya juga baik. Dia sempat tanya… kamu sudah punya rencana setelah lulus belum.”',
        scale,
      );
    }
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

            // Bapak (Father)
            Positioned(
              left: offsetX + 293.0 * scale,
              bottom: offsetY + 59.0 * scale,
              height: 318.0 * scale,
              child: Image.asset(
                'assets/images/bapak.png',
                fit: BoxFit.contain,
              ),
            ),

            // Ibu (Mother)
            Positioned(
              left: offsetX + 438.99 * scale,
              bottom: offsetY + 59.0 * scale,
              height: 318.0 * scale,
              child: Image.asset(
                'assets/images/ibu.png',
                fit: BoxFit.contain,
              ),
            ),

            // Dialogue Text Box (includes background framing and header tab overlay)
            Positioned(
              left: offsetX + 87.0 * scale,
              top: offsetY + 261.0 * scale,
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
                  30.0 * scale,
                  35.0 * scale,
                  20.0 * scale,
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: SizedBox(
                        key: ValueKey<int>(_currentStep),
                        width: double.infinity,
                        child: _buildDialogueContent(scale),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Pill-shaped Back Button (top left)
            Positioned(
              top: 25,
              left: 25,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF7F0),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFB59D93), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '← BACK',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF765E54),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
