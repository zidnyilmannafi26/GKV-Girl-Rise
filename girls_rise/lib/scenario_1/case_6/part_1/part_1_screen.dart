import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/dialogue_text_box.dart';
import '../part_2/part_2_screen.dart';

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
    final double activeCanvasHeight = designHeight * scale;
    final double offsetX = (screenWidth - activeCanvasWidth) / 2;
    final double offsetY = (screenHeight - activeCanvasHeight) / 2;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const Part2Screen(),
            ),
          );
        },
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

            // Karakter 1 (cewe.senang) - kiri
            Positioned(
              left: offsetX + 180.0 * scale,
              bottom: 55.0 * scale,
              height: 318.0 * scale,
              child: Image.asset(
                'assets/images/cewe.senang.png',
                fit: BoxFit.contain,
              ),
            ),

            // Karakter 2 (cowo.natap.kiri) - kanan
            Positioned(
              left: offsetX + 430.0 * scale,
              bottom: 55.0 * scale,
              height: 318.0 * scale,
              child: Image.asset(
                'assets/images/cowo.natap.kiri.png',
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
                headerTabAsset: 'assets/text_Box/Batas Pembuktian.svg',
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
                      'Hari ini adalah hari ulang tahunmu. Arga mengajakmu makan malam romantis, menjemputmu dengan mobil mewah nya lalu memberikan kotak kado berisi barang mewah berupa smartphone impian yang selama ini sangat kamu inginkan. Sambil menggenggam tanganmu di tempat sepi, ia berbisik..',
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
