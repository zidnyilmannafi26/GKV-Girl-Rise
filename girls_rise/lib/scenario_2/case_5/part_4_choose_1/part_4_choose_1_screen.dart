import 'package:girls_rise/widgets/game_back_button.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/reflection_text_box.dart';
import 'package:girls_rise/models/game_stats.dart';
import 'package:girls_rise/screens/home_screen.dart';

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
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
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
                'assets/images/bg2.5.png',
                fit: BoxFit.cover,
              ),
            ),

            // Character (Right side)
            Positioned(
              right: offsetX + 75.0 * scale,
              bottom: 0,
              height: 318.0 * scale,
              child: Image.asset(
                'assets/images/cewe.nangis.mataterbuka.png',
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
                quoteText: 'Mengiyakan keputusan keluarga.',
                reflectionText: 'Dengan berat hati, kamu menerima keputusan orang tuamu demi meringankan beban mereka. Langkah ini terasa sangat berat, karena kamu sadar bahwa impianmu untuk bersekolah harus dikesampingkan demi kelangsungan hidup keluarga.',
                statChanges: const [
                  StatDelta(StatType.pendidikan, -50),
                  StatDelta(StatType.mental, -50),
                  StatDelta(StatType.relasi, 50),
                  StatDelta(StatType.ekonomi, 30),
                ],
              ),
            ),

            const GameBackButton(type: BackButtonType.hidden),
          ],
        ),
      ),
    );
  }
}
