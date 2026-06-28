import 'dart:math';
import 'package:flutter/material.dart';
import 'package:girls_rise/services/game_state_manager.dart';
import 'package:girls_rise/services/history_service.dart';
import 'package:girls_rise/utils/fade_page_route.dart';
import 'package:girls_rise/widgets/dialogue_text_box.dart';
import 'package:girls_rise/widgets/game_back_button.dart';
import 'package:girls_rise/widgets/outcome_stat_panel.dart';
import 'final_reflection_putus_screen.dart';

import 'package:girls_rise/widgets/dynamic_character.dart';

class OutcomePutusScreen extends StatefulWidget {
  const OutcomePutusScreen({super.key});

  @override
  State<OutcomePutusScreen> createState() => _OutcomePutusScreenState();
}

class _OutcomePutusScreenState extends State<OutcomePutusScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bgFadeAnim;
  late Animation<double> _bgScaleAnim;
  late Animation<double> _charFadeAnim;
  late Animation<Offset> _charSlideAnim;
  late Animation<double> _panelFadeAnim;
  late Animation<Offset> _panelSlideAnim;
  late Animation<double> _boxFadeAnim;
  late Animation<Offset> _boxSlideAnim;
  late Animation<double> _textFadeAnim;

  @override
  void initState() {
    super.initState();
    if (!GameStateManager.instance.isPreviewingHistory) {
      HistoryService.instance.recordMatch(
        scenarioId: 1,
        outcomeId: 'outcome_putus',
        stats: GameStateManager.instance.stats,
      );
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    );

    // 1. Background & Right Stat Panel appear immediately together (0.0 .. 0.35)
    _bgFadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic),
    );
    _bgScaleAnim = Tween<double>(begin: 1.05, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
      ),
    );

    _panelFadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic),
    );
    _panelSlideAnim = Tween<Offset>(
      begin: const Offset(0.05, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
      ),
    );

    // 2. Dialogue Box anchors first to cover bottom space (0.15 .. 0.50)
    _boxFadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 0.50, curve: Curves.easeOutCubic),
    );
    _boxSlideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.50, curve: Curves.easeOutCubic),
      ),
    );

    // 3. Character emerges smoothly behind the already-forming box (0.30 .. 0.65)
    _charFadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.30, 0.65, curve: Curves.easeOutCubic),
    );
    _charSlideAnim = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.30, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    // 4. Narrative Text Soft Fade inside the box (0.45 .. 0.85)
    _textFadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 0.85, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                  child: FadeTransition(
                    opacity: _bgFadeAnim,
                    child: ScaleTransition(
                      scale: _bgScaleAnim,
                      child: ClipRect(
                        child: Image.asset(
                          'assets/images/bg.sc1.ot2.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),

                // Character (Full body anatomy - lifted slightly for better split proportion)
                Positioned(
                  left: offsetX,
                  bottom: offsetY + 18.0 * scale,
                  width: leftSectionWidth,
                  height: 318.0 * scale,
                  child: FadeTransition(
                    opacity: _charFadeAnim,
                    child: SlideTransition(
                      position: _charSlideAnim,
                      child: IgnorePointer(
                        child: Center(
                          child: DynamicCharacter(
                            'assets/images/cewe.senang.png',
                            fit: BoxFit.contain,
                          ),
                        ),
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
                  child: FadeTransition(
                    opacity: _boxFadeAnim,
                    child: SlideTransition(
                      position: _boxSlideAnim,
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
                            child: FadeTransition(
                              opacity: _textFadeAnim,
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
                    ),
                  ),
                ),

                // === RIGHT SECTION (1/3 WIDTH) ===
                Positioned(
                  left: offsetX + leftSectionWidth,
                  top: offsetY,
                  width: rightSectionWidth,
                  height: 402.0 * scale,
                  child: FadeTransition(
                    opacity: _panelFadeAnim,
                    child: SlideTransition(
                      position: _panelSlideAnim,
                      child: OutcomeStatPanel(
                        isNikahMuda: false,
                        stats: GameStateManager.instance.stats,
                        scale: scale,
                      ),
                    ),
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
