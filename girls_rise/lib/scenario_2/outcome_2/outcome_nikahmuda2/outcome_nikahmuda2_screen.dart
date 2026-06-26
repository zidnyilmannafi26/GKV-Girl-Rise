import 'dart:math';
import 'package:flutter/material.dart';
import 'package:girls_rise/services/game_state_manager.dart';
import 'package:girls_rise/utils/fade_page_route.dart';
import 'package:girls_rise/widgets/dialogue_text_box.dart';
import 'package:girls_rise/widgets/game_back_button.dart';
import 'package:girls_rise/widgets/outcome_stat_panel.dart';
import 'final_reflection_nikahmuda2_screen.dart';

class OutcomeNikahMuda2Screen extends StatefulWidget {
  const OutcomeNikahMuda2Screen({super.key});

  @override
  State<OutcomeNikahMuda2Screen> createState() => _OutcomeNikahMuda2ScreenState();
}

class _OutcomeNikahMuda2ScreenState extends State<OutcomeNikahMuda2Screen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bgCharAnim;
  late Animation<double> _textAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    _bgCharAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOutQuart),
    );

    _textAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.30, 1.0, curve: Curves.easeOutQuart),
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
      FadePageRoute(page: const FinalReflectionNikahMuda2Screen()),
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
                    opacity: _bgCharAnim,
                    child: ClipRect(
                      child: Image.asset(
                        'assets/images/bg.sc2.ot1.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // Character (Lifted slightly for better split-screen proportion)
                Positioned(
                  left: offsetX,
                  bottom: offsetY - 10.0 * scale,
                  width: leftSectionWidth,
                  height: 360.0 * scale,
                  child: FadeTransition(
                    opacity: _bgCharAnim,
                    child: IgnorePointer(
                      child: Center(
                        child: Image.asset(
                          'assets/images/cewe.nangis.mataterbuka.png',
                          fit: BoxFit.contain,
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
                    opacity: _bgCharAnim,
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
                            opacity: _textAnim,
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

                // === RIGHT SECTION (1/3 WIDTH) ===
                Positioned(
                  left: offsetX + leftSectionWidth,
                  top: offsetY,
                  width: rightSectionWidth,
                  height: 402.0 * scale,
                  child: FadeTransition(
                    opacity: _bgCharAnim,
                    child: OutcomeStatPanel(
                      isNikahMuda: true,
                      stats: GameStateManager.instance.stats,
                      scale: scale,
                      scenarioNumber: 2,
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
