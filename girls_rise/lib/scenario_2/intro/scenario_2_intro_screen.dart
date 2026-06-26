import 'package:girls_rise/utils/fade_page_route.dart';
import 'package:girls_rise/widgets/game_back_button.dart';
import 'package:girls_rise/widgets/dialogue_text_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/game_state_manager.dart';
import '../../services/audio_service.dart';
import '../case_1/part_1/part_1_screen.dart';

import 'package:girls_rise/widgets/dynamic_character.dart';
import 'package:girls_rise/services/story_controller.dart';

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
    if (StoryController.instance.interceptTap()) return;
    AudioService.instance.playTransitionSfx();
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    } else {
      Navigator.of(context).push(
        FadePageRoute(page: const Part1Screen()),
      );
    }
  }

  Widget _buildDialogueLine(String speaker, String text, double scale) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.lora(
          fontSize: 14.5 * scale,
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

    // Active canvas offsets to center the game canvas on the screen
    final double activeCanvasWidth = designWidth * scale;
    final double offsetX = (screenWidth - activeCanvasWidth) / 2;

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

            // 1. Bapak (Father)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 550),
              curve: Curves.easeOutCubic,
              left: _currentStep == 2
                  ? offsetX - 350.0 * scale
                  : (_currentStep == 1 ? offsetX + 250.0 * scale : offsetX + 230.0 * scale),
              bottom: 55.0 * scale,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 450),
                opacity: _currentStep == 2 ? 0.0 : 1.0,
                child: SizedBox(
                  width: 250.0 * scale,
                  height: charHeight,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 350),
                        opacity: _currentStep == 0 ? 1.0 : 0.0,
                        child: DynamicCharacter('assets/images/bapak.png', fit: BoxFit.contain),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 350),
                        opacity: (_currentStep == 1 || _currentStep == 2) ? 1.0 : 0.0,
                        child: DynamicCharacter('assets/images/bapak.marah.png', fit: BoxFit.contain),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2. Ibu (Mother)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 550),
              curve: Curves.easeOutCubic,
              left: _currentStep == 2
                  ? offsetX + 950.0 * scale
                  : (_currentStep == 1 ? offsetX + 430.0 * scale : offsetX + 450.0 * scale),
              bottom: 55.0 * scale,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 450),
                opacity: _currentStep == 2 ? 0.0 : 1.0,
                child: SizedBox(
                  width: 250.0 * scale,
                  height: charHeight,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 350),
                        opacity: _currentStep == 0 ? 1.0 : 0.0,
                        child: DynamicCharacter('assets/images/ibu.png', fit: BoxFit.contain),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 350),
                        opacity: (_currentStep == 1 || _currentStep == 2) ? 1.0 : 0.0,
                        child: DynamicCharacter('assets/images/ibu.marah.png', fit: BoxFit.contain),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 3. Cewe (Daughter)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 650),
              curve: Curves.easeOutCubic,
              left: offsetX + 340.0 * scale,
              bottom: _currentStep == 2 ? 55.0 * scale : 35.0 * scale,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _currentStep == 2 ? 1.0 : 0.0,
                child: SizedBox(
                  width: 250.0 * scale,
                  height: charHeight,
                  child: DynamicCharacter(
                    'assets/images/cewe.bingung.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Dialogue Text Box (includes background framing and header tab overlay)
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
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: SizedBox(
                        key: ValueKey<int>(_currentStep),
                        width: double.infinity,
                        child: _buildStoryContent(scale, key: ValueKey<int>(_currentStep)),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            _currentStep == 0
                ? const GameBackButton(type: BackButtonType.scenarioRoot)
                : GameBackButton(
                    type: BackButtonType.normalBack,
                    customOnBack: () {
                      AudioService.instance.playTransitionSfx();
                      setState(() {
                        _currentStep--;
                      });
                    },
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
