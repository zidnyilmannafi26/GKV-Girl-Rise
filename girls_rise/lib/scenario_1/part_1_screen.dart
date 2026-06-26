import 'package:girls_rise/widgets/game_back_button.dart';
import 'package:girls_rise/utils/fade_page_route.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/dialogue_text_box.dart';
import '../services/game_state_manager.dart';
import 'part_2_screen.dart';

import 'package:girls_rise/widgets/dynamic_character.dart';
import 'package:girls_rise/services/story_controller.dart';

class Part1Screen extends StatefulWidget {
  const Part1Screen({super.key});

  @override
  State<Part1Screen> createState() => _Part1ScreenState();
}

class _Part1ScreenState extends State<Part1Screen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GameStateManager.instance.startScenario(1);
    });
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
        onTap: () {
          if (StoryController.instance.interceptTap()) return;
          Navigator.of(context).push(
            FadePageRoute(page: const Part2Screen())
          );
        },
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg.story1.png',
                fit: BoxFit.cover,
              ),
            ),

            // Character
            Positioned(
              left: offsetX + 150.0 * scale,
              bottom: 55.0 * scale,
              height: 318.0 * scale,
              child: DynamicCharacter(
                'assets/images/cewe.cowo.sedih.png',
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
                headerTabAsset: 'assets/text_Box/STORY.svg',
                headerTabWidth: 140.0,
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
                      'Kamu adalah siswi SMA kelas 11 berusia 16 tahun. Sudah hampir 4 tahun kamu berpacaran dengan Arga, tetangga dekat rumahmu yang usianya sedikit lebih tua. Sejak kecil kalian tidak pernah terpisahkan, dan banyak orang bilang hubungan kalian terlihat sangat sempurna. Arga sering menjemputmu pulang sekolah, mengingatkanmu makan, menghiburmu saat sedih, bahkan mengenal keluargamu dengan baik. Kamu merasa dialah orang yang paling mengerti dirimu. Namun, segalanya mulai berubah sejak Arga lulus SMA dan masuk ke dunia perkuliahan.\n\nPerbedaan dunia kalian perlahan mulai menciptakan celah. Di saat kamu masih sibuk dengan urusan sekolah, Arga yang kini dikelilingi lingkungan mahasiswa mulai menuntut komitmen yang jauh lebih serius karena merasa hubungan kalian sudah sangat matang. Perlahan, perhatian manisnya berubah menjadi kalimat-kalimat penuh desakan yang membuatmu bingung',
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

            const GameBackButton(type: BackButtonType.scenarioRoot),
          ],
        ),
      ),
    );
  }
}
