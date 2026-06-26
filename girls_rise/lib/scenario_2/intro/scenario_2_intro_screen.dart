import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/game_state_manager.dart';
import '../case_1/part_1/part_1_screen.dart';

class Scenario2IntroScreen extends StatefulWidget {
  const Scenario2IntroScreen({super.key});

  @override
  State<Scenario2IntroScreen> createState() => _Scenario2IntroScreenState();
}

class _Scenario2IntroScreenState extends State<Scenario2IntroScreen> {
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GameStateManager.instance.startScenario(2);
    });
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const Part1Screen(),
        ),
      );
    }
  }

  Widget _buildDialogueLine(String speaker, String text, double scale) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.lora(
          fontSize: 16.0 * scale,
          height: 1.5,
          color: const Color(0xFF765E54),
        ),
        children: [
          TextSpan(
            text: '$speaker: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: text),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Design canvas dimensions from Figma (Story Intro (3).svg)
    const double designWidth = 874.0;
    const double designHeight = 402.0;

    // Calculate containment scale factor (maintains aspect ratio of the active layout area)
    final double scaleX = screenWidth / designWidth;
    final double scaleY = screenHeight / designHeight;
    final double scale = scaleX < scaleY ? scaleX : scaleY;

    // Actual dimensions of the textbox relative to the design
    final double boxWidth = 488.0 * scale;
    final double boxHeight = 255.0 * scale;

    // Active canvas offsets to center the game canvas on the screen
    final double activeCanvasWidth = designWidth * scale;
    final double activeCanvasHeight = designHeight * scale;
    final double offsetX = (screenWidth - activeCanvasWidth) / 2;
    final double offsetY = (screenHeight - activeCanvasHeight) / 2;

    // Determine horizontal box position based on current step
    final double boxLeft = _currentStep == 0
        ? offsetX + 297.0 * scale
        : (_currentStep == 1 ? offsetX + ((designWidth - 488.0) / 2) * scale : offsetX + 297.0 * scale);

    final double boxTop = offsetY + 83.0 * scale;

    // STORY header tab dimensions and positions
    final double tabWidth = 140.0 * scale;
    final double tabHeight = 44.0 * scale;
    final double tabLeft = boxLeft + 24.0 * scale;
    final double tabTop = boxTop - 28.0 * scale;

    // Character heights based on design proportions
    final double charHeight = 318.0 * scale;

    return Scaffold(
      body: GestureDetector(
        onTap: _nextStep,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg.story2.png',
                fit: BoxFit.cover,
              ),
            ),

            // Characters

            // 1. Bapak (Father)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOutCubic,
              left: _currentStep == 0
                  ? offsetX + 40.0 * scale
                  : (_currentStep == 1 ? offsetX + 15.0 * scale : -350.0 * scale),
              bottom: 55.0 * scale,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _currentStep == 2 ? 0.0 : 1.0,
                child: SizedBox(
                  height: charHeight,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: Image.asset(
                      _currentStep == 0
                          ? 'assets/images/bapak.png'
                          : 'assets/images/bapak.marah.png',
                      key: ValueKey<String>(_currentStep == 0 ? 'bapak_normal' : 'bapak_marah'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),

            // 2. Ibu (Mother)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOutCubic,
              left: _currentStep == 0
                  ? offsetX + 130.0 * scale
                  : (_currentStep == 1 ? offsetX + (designWidth - 200.0) * scale : screenWidth + 100.0 * scale),
              bottom: 55.0 * scale,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _currentStep == 2 ? 0.0 : 1.0,
                child: SizedBox(
                  height: charHeight,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: Image.asset(
                      _currentStep == 0
                          ? 'assets/images/ibu.png'
                          : 'assets/images/ibu.marah.png',
                      key: ValueKey<String>(_currentStep == 0 ? 'ibu_normal' : 'ibu_marah'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),

            // 3. Cewe (Daughter)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOutCubic,
              left: _currentStep == 2 ? offsetX + 96.0 * scale : -350.0 * scale,
              bottom: 55.0 * scale,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _currentStep == 2 ? 1.0 : 0.0,
                child: SizedBox(
                  height: charHeight,
                  child: Image.asset(
                    'assets/images/cewe.bingung.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Story Box Container
            AnimatedPositioned(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOutCubic,
              left: boxLeft,
              top: boxTop,
              width: boxWidth,
              height: boxHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Background Native Box (Replaces heavy SVG)
                  Positioned(
                    left: 0,
                    top: 0,
                    width: boxWidth,
                    height: boxHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF7F0).withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(16.0 * scale),
                        border: Border.all(
                          color: const Color(0xFF765E54).withValues(alpha: 0.5),
                          width: 2.0 * scale,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 8.0,
                            offset: const Offset(2.0, 4.0),
                          )
                        ],
                      ),
                    ),
                  ),

                  // Content Padding and Scroll View
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        41.0 * scale,
                        30.0 * scale,
                        35.0 * scale,
                        70.0 * scale,
                      ),
                      child: Center(
                        child: SingleChildScrollView(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child: _buildStoryContent(scale, key: ValueKey<int>(_currentStep)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Overlapping "STORY" Header Tab (Native text instead of SVG)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOutCubic,
              left: tabLeft,
              top: tabTop,
              width: tabWidth,
              height: tabHeight,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF765E54),
                  borderRadius: BorderRadius.circular(12.0 * scale),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4.0,
                      offset: const Offset(0, 2.0),
                    )
                  ],
                ),
                child: Text(
                  'STORY',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0 * scale,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFDF7F0),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            // Pill-shaped Back Button (top left)
            Positioned(
              top: 25,
              left: 25,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF7F0), // cream background
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFB59D93), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '← BACK',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF765E54), // brown text
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

  Widget _buildStoryContent(double scale, {required Key key}) {
    switch (_currentStep) {
      case 0:
        return Text(
          'Kamu adalah siswa SMA kelas 11, usia 16 tahun. Kondisi ekonomi keluargamu sedang tidak stabil. Kamu memiliki dua adik yang masih kecil. Orang tuamu sering membicarakan masa depan dengan nada khawatir. Belakangan ini, mereka mulai menyarankan bahwa menikah bisa menjadi jalan untuk meringankan beban keluarga.',
          key: key,
          style: GoogleFonts.lora(
            fontSize: 16.0 * scale,
            height: 1.6,
            color: const Color(0xFF765E54),
          ),
          textAlign: TextAlign.center,
        );
      case 1:
        return Column(
          key: key,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDialogueLine('Ibu', '"Uang sekolah bulan depan gimana ya..."', scale),
            SizedBox(height: 14.0 * scale),
            _buildDialogueLine('Ayah', '"Ayah juga lagi bingung. Pendapatan sekarang makin nggak cukup."', scale),
            SizedBox(height: 14.0 * scale),
            _buildDialogueLine('Ibu', '"Kasihan dia... sebenernya pengen terus sekolah. Tapi kasihan juga adik-adipnya"', scale),
            SizedBox(height: 14.0 * scale),
            _buildDialogueLine('Ayah', '"Kadang Ayah kepikiran... kalau ada yang mau serius sama dia, mungkin hidupnya bisa lebih terjamin."', scale),
          ],
        );
      case 2:
      default:
        return Text(
          'Kamu tahu semua ini bukan karena orang tuamu tidak peduli. Justru karena mereka terlalu memikirkan bagaimana keluarga ini bisa bertahan, sampai akhirnya masa depanmu ikut dipertaruhkan. Namun semakin sering pembicaraan itu muncul, semakin kamu merasa cita-cita yang dulu begitu dekat perlahan berubah menjadi sesuatu yang dianggap terlalu mahal untuk dipertahankan. Kamu mulai bertanya... apakah bermimpi setinggi itu memang salah, ketika keadaan keluarga sedang seberat ini?',
          key: key,
          style: GoogleFonts.lora(
            fontSize: 16.0 * scale,
            height: 1.6,
            color: const Color(0xFF765E54),
          ),
          textAlign: TextAlign.center,
        );
    }
  }
}
