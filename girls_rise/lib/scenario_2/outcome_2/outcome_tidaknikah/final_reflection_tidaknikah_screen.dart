import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/scenario_2/intro/scenario_2_intro_screen.dart';
import 'package:girls_rise/screens/home_screen.dart';
import 'package:girls_rise/services/game_state_manager.dart';
import 'package:girls_rise/utils/fade_page_route.dart';
import 'package:girls_rise/widgets/game_back_button.dart';

class FinalReflectionTidakNikahScreen extends StatefulWidget {
  const FinalReflectionTidakNikahScreen({super.key});

  @override
  State<FinalReflectionTidakNikahScreen> createState() =>
      _FinalReflectionTidakNikahScreenState();
}

class _FinalReflectionTidakNikahScreenState extends State<FinalReflectionTidakNikahScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _step1Anim;
  late Animation<double> _step2Anim;
  late Animation<double> _step3Anim;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6500),
    );

    _step1Anim = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.25, curve: Curves.easeOutQuart),
    );
    _step2Anim = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.40, 0.65, curve: Curves.easeOutQuart),
    );
    _step3Anim = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.80, 1.0, curve: Curves.easeOutQuart),
    );

    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  void _restartScenario() {
    GameStateManager.instance.startScenario(2);
    Navigator.of(context).pushAndRemoveUntil(
      FadePageRoute(page: const Scenario2IntroScreen()),
      (route) => route.isFirst,
    );
  }

  void _gotoHome() {
    GameStateManager.instance.resetScenario();
    Navigator.of(context).pushAndRemoveUntil(
      FadePageRoute(page: const HomeScreen()),
      (route) => false,
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

          return Stack(
            children: [
              // Full Screen Background
              Positioned(
                left: offsetX,
                top: offsetY,
                width: 874.0 * scale,
                height: 402.0 * scale,
                child: Image.asset(
                  'assets/images/bg.sc2.ot2.png',
                  fit: BoxFit.cover,
                ),
              ),

              // Glassmorphism Central Modal Box
              Positioned(
                left: offsetX + 67.0 * scale,
                top: offsetY + 36.0 * scale,
                width: 740.0 * scale,
                height: 330.0 * scale,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0 * scale),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF7F0).withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(20.0 * scale),
                        border: Border.all(
                          color: const Color(0xFFB59D93),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 20.0,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      padding: EdgeInsets.fromLTRB(
                        32.0 * scale,
                        32.0 * scale,
                        32.0 * scale,
                        20.0 * scale,
                      ),
                      child: Column(
                        children: [
                          // Text Box 1
                          FadeTransition(
                            opacity: _step1Anim,
                            child: Text(
                              'Setiap keputusan membutuhkan keberanian. Hari ini kamu memilih memperjuangkan pendidikan dan membangun karier impianmu. Perjalananmu mungkin tidak mudah dan penuh pengorbanan. Namun, setiap langkah mandiri yang kamu ambil hari ini telah membuka masa depan yang jauh lebih cerah bagi dirimu dan keluargamu.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lora(
                                fontSize: 13.0 * scale,
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF765E54),
                              ),
                            ),
                          ),

                          SizedBox(height: 12.0 * scale),

                          // Decorative Gold Divider
                          FadeTransition(
                            opacity: _step2Anim,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: const Color(0xFFB59D93).withValues(alpha: 0.6),
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12.0 * scale),
                                  child: Text('✨', style: TextStyle(fontSize: 14.0 * scale)),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: const Color(0xFFB59D93).withValues(alpha: 0.6),
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 12.0 * scale),

                          // Text Box 2
                          FadeTransition(
                            opacity: _step2Anim,
                            child: Text(
                              'Tidak semua pilihan membawa hasil yang mudah. Namun, ketegasanmu hari ini membuktikan bahwa kamu berhak menentukan arah hidupmu sendiri. Teruslah melangkah dengan bangga.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lora(
                                fontSize: 13.0 * scale,
                                height: 1.5,
                                fontStyle: FontStyle.italic,
                                color: const Color(0xFF765E54),
                              ),
                            ),
                          ),

                          const Spacer(),

                          // Endgame Navigation Buttons
                          FadeTransition(
                            opacity: _step3Anim,
                            child: GameStateManager.instance.isPreviewingHistory
                                ? Center(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        GameStateManager.instance.endScenario();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(Icons.arrow_back_rounded, size: 18 * scale),
                                      label: Text(
                                        '← Kembali ke Riwayat',
                                        style: GoogleFonts.poppins(
                                          fontSize: 13 * scale,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF765E54),
                                        foregroundColor: const Color(0xFFFDF7F0),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 24 * scale,
                                          vertical: 12 * scale,
                                        ),
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25 * scale),
                                        ),
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Restart Button
                                      ElevatedButton.icon(
                                        onPressed: _restartScenario,
                                        icon: Icon(Icons.refresh_rounded, size: 18 * scale),
                                        label: Text(
                                          'Ulangi Skenario 2',
                                          style: GoogleFonts.poppins(
                                            fontSize: 13 * scale,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF765E54),
                                          foregroundColor: const Color(0xFFFDF7F0),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20 * scale,
                                            vertical: 12 * scale,
                                          ),
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25 * scale),
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: 20.0 * scale),

                                      // Main Menu Button
                                      OutlinedButton.icon(
                                        onPressed: _gotoHome,
                                        icon: Icon(Icons.home_rounded, size: 18 * scale),
                                        label: Text(
                                          'Menu Utama',
                                          style: GoogleFonts.poppins(
                                            fontSize: 13 * scale,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: const Color(0xFF765E54),
                                          side: const BorderSide(color: Color(0xFF765E54), width: 1.5),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20 * scale,
                                            vertical: 12 * scale,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25 * scale),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Native Header Tab: FINAL REFLECTION
              Positioned(
                left: offsetX + 67.0 * scale + 30.0 * scale,
                top: offsetY + 36.0 * scale - 14.0 * scale,
                child: FadeTransition(
                  opacity: _step1Anim,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0 * scale,
                      vertical: 6.0 * scale,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF765E54),
                      borderRadius: BorderRadius.circular(8.0 * scale),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 4.0,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Text(
                      'FINAL REFLECTION',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFFDF7F0),
                        fontSize: 11.5 * scale,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

              // Hidden back button to prevent accidental exiting
              const GameBackButton(type: BackButtonType.hidden),
            ],
          );
        },
      ),
    );
  }
}
