import 'dart:math';
import 'package:flutter/material.dart';
import 'package:girls_rise/services/game_state_manager.dart';
import 'package:girls_rise/services/history_service.dart';
import 'package:girls_rise/utils/fade_page_route.dart';
import 'package:girls_rise/widgets/dialogue_text_box.dart';
import 'package:girls_rise/widgets/game_back_button.dart';
import 'package:girls_rise/widgets/outcome_stat_panel.dart';
import 'final_reflection_nikahmuda_screen.dart';

import 'package:girls_rise/widgets/dynamic_character.dart';

class OutcomeNikahMudaScreen extends StatefulWidget {
  const OutcomeNikahMudaScreen({super.key});

  @override
  State<OutcomeNikahMudaScreen> createState() => _OutcomeNikahMudaScreenState();
}

class _OutcomeNikahMudaScreenState extends State<OutcomeNikahMudaScreen>
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
        outcomeId: 'outcome_nikahmuda',
        stats: GameStateManager.instance.stats,
      );
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    );

    // 1. Background Cinematic Zoom (0.0 .. 0.35)
    _bgFadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );
    _bgScaleAnim = Tween<double>(begin: 1.08, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
      ),
    );

    // 2. Character Rise (0.15 .. 0.55)
    _charFadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 0.55, curve: Curves.easeOut),
    );
    _charSlideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.55, curve: Curves.easeOutQuart),
      ),
    );

    // 3. Right Stat Panel Slide-In (0.25 .. 0.65)
    _panelFadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.65, curve: Curves.easeOut),
    );
    _panelSlideAnim = Tween<Offset>(
      begin: const Offset(0.08, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.65, curve: Curves.easeOutQuart),
      ),
    );

    // 4. Dialogue Box Spring-Up (0.35 .. 0.75)
    _boxFadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.75, curve: Curves.easeOut),
    );
    _boxSlideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOutBack),
      ),
    );

    // 5. Narrative Text Soft Fade (0.50 .. 1.0)
    _textFadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.50, 1.0, curve: Curves.easeOutQuart),
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
      FadePageRoute(page: const FinalReflectionNikahMudaScreen()),
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
                          'assets/images/bg.sc1.ot1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),

                // Character (Thigh cropped anatomy - lifted slightly for better split-screen proportion)
                Positioned(
                  left: offsetX,
                  bottom: offsetY - 10.0 * scale,
                  width: leftSectionWidth,
                  height: 360.0 * scale,
                  child: FadeTransition(
                    opacity: _charFadeAnim,
                    child: SlideTransition(
                      position: _charSlideAnim,
                      child: IgnorePointer(
                        child: Center(
                          child: DynamicCharacter(
                            'assets/images/cewe.nangis.mataterbuka.png',
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
                                'Beberapa minggu kemudian, kamu terlambat datang bulan dan dinyatakan positif hamil. Impian besarmu terhenti seketika. Kamu harus keluar dari sekolah akibat sanksi, menahan cemoohan lingkungan, dan terjebak dalam lingkaran pernikahan dini tanpa kesiapan mental serta ekonomi yang matang.',
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
                        isNikahMuda: true,
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
