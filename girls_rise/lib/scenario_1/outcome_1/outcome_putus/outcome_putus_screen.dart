import 'dart:math';
import 'package:flutter/material.dart';
import 'package:girls_rise/services/game_state_manager.dart';
import 'package:girls_rise/utils/fade_page_route.dart';
import 'package:girls_rise/widgets/dialogue_text_box.dart';
import 'package:girls_rise/widgets/game_back_button.dart';
import 'package:girls_rise/widgets/outcome_stat_panel.dart';
import 'final_reflection_putus_screen.dart';

class OutcomePutusScreen extends StatelessWidget {
  const OutcomePutusScreen({super.key});

  void _nextStep(BuildContext context) {
    Navigator.of(context).push(
      FadePageRoute(page: const FinalReflectionPutusScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scale = min(
            constraints.maxWidth / 874.0,
            constraints.maxHeight / 402.0,
          );
          final offsetX = (constraints.maxWidth - 874.0 * scale) / 2;
          final offsetY = (constraints.maxHeight - 402.0 * scale) / 2;

          final double leftSectionWidth = 582.66 * scale;
          final double rightSectionWidth = 291.34 * scale;

          return GestureDetector(
            onTap: () => _nextStep(context),
            behavior: HitTestBehavior.translucent,
            child: Stack(
              children: [
                // === LEFT SECTION (2/3 WIDTH) ===
                // Background
                Positioned(
                  left: offsetX,
                  top: offsetY,
                  width: leftSectionWidth,
                  height: 402.0 * scale,
                  child: ClipRect(
                    child: Image.asset(
                      'assets/images/bg.sc1.ot2.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Character (Full body anatomy - lifted slightly for better split proportion)
                Positioned(
                  left: offsetX,
                  bottom: offsetY + 18.0 * scale,
                  width: leftSectionWidth,
                  height: 318.0 * scale,
                  child: IgnorePointer(
                    child: Center(
                      child: Image.asset(
                        'assets/images/cewe.senang.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                // Dialogue Text Box (bottom of left section - scrollable text)
                Positioned(
                  left: offsetX + 21.33 * scale,
                  bottom: offsetY,
                  width: 540.0 * scale,
                  height: 141.0 * scale,
                  child: DialogueTextBox(
                    scale: scale,
                    width: 540.0,
                    height: 141.0,
                    headerTabAsset: 'assets/text_Box/OUTCOME.svg',
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: GestureDetector(
                        onTap: () => _nextStep(context),
                        behavior: HitTestBehavior.translucent,
                        child: Text(
                          'Hubungan 4 tahun kalian berakhir dengan sangat menyakitkan malam itu juga. Namun, kamu sadar bahwa ini adalah hubungan yang toxic, keberanianmu menolak berhasil menyelamatkan masa depanmu. Lima tahun kemudian, kamu sukses menyelesaikan pendidikan tinggi di universitas terbaik dengan predikat Cum Laude. Kamu menjelma menjadi wanita karir mandiri yang sukses dan berdaya penuh atas kehidupannya sendiri.',
                          style: TextStyle(
                            fontFamily: 'Lora',
                            color: const Color(0xFF765E54),
                            fontSize: 13.5 * scale,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // === RIGHT SECTION (1/3 WIDTH) ===
                Positioned(
                  left: offsetX + leftSectionWidth,
                  top: offsetY,
                  width: rightSectionWidth,
                  height: 402.0 * scale,
                  child: OutcomeStatPanel(
                    isNikahMuda: false,
                    stats: GameStateManager.instance.stats,
                    scale: scale,
                  ),
                ),

                // Hidden Back Button to enforce forward-only story progression
                const GameBackButton(type: BackButtonType.hidden),
              ],
            ),
          );
        },
      ),
    );
  }
}
