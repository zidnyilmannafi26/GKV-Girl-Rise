import 'package:girls_rise/widgets/game_back_button.dart';
import 'package:girls_rise/utils/fade_page_route.dart';
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
  void _nextStep() {
    if (StoryController.instance.interceptTap()) return;
    Navigator.of(context).push(
      FadePageRoute(page: const Part2Screen())
    );
  }

  String _getDynamicText() {
    final prev = GameStateManager.instance.getChoice('s1_case2');
    if (prev == 1) {
      return 'Setelah kamu meninggalkan tugas demi menemani Arga malam itu, nilaimu mulai anjlok dan kamu terlihat sering melamun karena lelah. Malam hari, Ibumu masuk ke kamar dan bertanya lembut: Akhir-akhir ini kamu sering melamun, Nak. Nilai sekolahmu juga turun. Ada sesuatu yang mengganggu pikiran kamu?';
    } else if (prev == 2) {
      return 'Setelah sempat diam mengulur waktu saat ditelepon Arga, hubungan kalian malah dipenuhi ketegangan yang membuatmu stres. Malam hari, Ibumu masuk ke kamar dan bertanya lembut: Akhir-akhir ini kamu sering melamun, Nak. Nilai sekolahmu juga turun. Ada sesuatu yang mengganggu pikiran kamu?';
    } else if (prev == 3) {
      return 'Setelah kamu bersikap tegas bahwa tugas sekolah itu penting, Arga merajuk berkepanjangan dan membebanimu secara emosional. Malam hari, Ibumu masuk ke kamar dan melihatmu murung: Akhir-akhir ini kamu sering melamun, Nak. Ada sesuatu yang mengganggu pikiran kamu?';
    }
    return 'Akibat tekanan hubungan yang makin intens, nilaimu di sekolah mulai menurun dan kamu sering terlihat melamun di rumah. Malam hari, Ibumu masuk ke kamar dan bertanya lembut: Akhir-akhir ini kamu sering melamun, Nak. Nilai sekolahmu juga turun. Ada sesuatu yang mengganggu pikiran kamu?';
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
        onTap: _nextStep,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg1.3.png',
                fit: BoxFit.cover,
              ),
            ),

            // Karakter 1 (ibu) - kiri tengah
            Positioned(
              left: offsetX + 180.0 * scale,
              bottom: 55.0 * scale,
              height: 318.0 * scale,
              child: DynamicCharacter(
                'assets/images/ibu.marah.png',
                fit: BoxFit.contain,
              ),
            ),

            // Karakter 2 (cewe) - kanan tengah
            Positioned(
              left: offsetX + 430.0 * scale,
              bottom: 55.0 * scale,
              height: 318.0 * scale,
              child: DynamicCharacter(
                'assets/images/cewe.bingung.png',
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
                headerTabAsset: 'assets/text_Box/Kekhawatiran Orang Tua.svg',
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
                      _getDynamicText(),
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
