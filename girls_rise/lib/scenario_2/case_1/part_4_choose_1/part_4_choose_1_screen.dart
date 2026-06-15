import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Part4Choose1Screen extends StatefulWidget {
  const Part4Choose1Screen({super.key});

  @override
  State<Part4Choose1Screen> createState() => _Part4Choose1ScreenState();
}

class _Part4Choose1ScreenState extends State<Part4Choose1Screen> {
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

  Widget _buildTextContent(double scale) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Small Dialogue Quote Box (form 4.svg)
          Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                'assets/text_Box/form 4.svg',
                width: 273.0 * scale,
                height: 61.0 * scale,
                fit: BoxFit.fill,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0 * scale, vertical: 8.0 * scale),
                child: Text(
                  '“Aku masih pengen sekolah dan ngejar cita-cita.”',
                  style: GoogleFonts.lora(
                    fontSize: 11.5 * scale,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF765E54),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.0 * scale),
          // Reflection Text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0 * scale),
            child: Text(
              'Orangtuamu mungkin merasa bingung dan makin khawatir soal kondisi ekonomi, tapi kamu masih mencoba mempertahankan mimpimu sendiri.',
              style: GoogleFonts.lora(
                fontSize: 12.0 * scale,
                height: 1.4,
                color: const Color(0xFF765E54),
              ),
              textAlign: TextAlign.center,
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

    final double textboxWidth = 303.5 * scale;
    final double textboxHeight = 225.9 * scale;

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

             // Character (Right side - Enlarged and anchored to bottom-right edge)
            Positioned(
              right: offsetX - 20.0 * scale,
              bottom: -70.0 * scale,
              width: 440.0 * scale,
              height: 440.0 * scale,
              child: Image.asset(
                'assets/images/ibu.bapak.marah.png',
                fit: BoxFit.contain,
              ),
            ),

            // Textbox (Left side)
            Positioned(
              left: offsetX + 100.0 * scale,
              top: offsetY + 126.9 * scale,
              width: textboxWidth,
              height: textboxHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Textbox SVG with offset
                  Positioned(
                    left: -textboxWidth * (99.25 / 478.40),
                    top: -textboxHeight * (103.62 / 229.59),
                    width: textboxWidth * (628.0 / 478.40),
                    height: textboxHeight * (372.0 / 229.59),
                    child: IgnorePointer(
                      child: SvgPicture.asset(
                        'assets/text_Box/form 3.svg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),

                  // Text Content
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        15.0 * scale,
                        35.0 * scale,
                        15.0 * scale,
                        20.0 * scale,
                      ),
                      child: SingleChildScrollView(
                        child: _buildTextContent(scale),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Dialogue Header Tab SVG (Placed after Textbox so it renders on top)
            Positioned(
              left: offsetX + 118.0 * scale,
              top: offsetY + 79.9 * scale,
              width: 255.0 * scale,
              height: 52.0 * scale,
              child: IgnorePointer(
                child: SvgPicture.asset(
                  'assets/text_Box/REFLECTION.svg',
                  fit: BoxFit.contain,
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
