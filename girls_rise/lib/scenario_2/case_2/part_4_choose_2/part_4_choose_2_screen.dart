import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/reflection_text_box.dart';

class Part4Choose2Screen extends StatefulWidget {
  const Part4Choose2Screen({super.key});

  @override
  State<Part4Choose2Screen> createState() => _Part4Choose2ScreenState();
}

class _Part4Choose2ScreenState extends State<Part4Choose2Screen> {
  void _nextStep() {
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFDF7F0),
        title: Text(
          'Skenario 2 Selesai',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF765E54),
          ),
        ),
        content: Text(
          'Cerita Skenario 2 bagian ini telah selesai. Pilihlah skenario lain untuk melihat akhir cerita yang berbeda!',
          style: GoogleFonts.poppins(color: const Color(0xFF765E54)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.settings.name == '/selection');
            },
            child: Text(
              'OK',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: const Color(0xFFB59D93),
              ),
            ),
          ),
        ],
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
                'assets/images/bg2.2.png',
                fit: BoxFit.cover,
              ),
            ),

            // Character (Right side)
            Positioned(
              right: offsetX - 20.0 * scale,
              bottom: -20.0 * scale, // slightly lifted for extracted_intro3 as it's not full body
              height: 440.0 * scale,
              child: Image.asset(
                'assets/images/extracted_intro3.png',
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
                quoteText: 'Hanya melihat brosur dari jauh tanpa mengambilnya.',
                reflectionText: 'Kamu tetap duduk di kursi sambil memperhatikan teman-teman lain maju ke depan. Dalam hati, kamu ingin mencoba… tetapi keraguan membuat langkahmu terasa berat.',
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
