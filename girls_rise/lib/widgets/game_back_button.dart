import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/game_state_manager.dart';
import '../screens/scenario_selection_screen.dart';
import '../utils/fade_page_route.dart';

enum BackButtonType {
  scenarioRoot, // Part 1 (Arrow icon only, triggers Exit Dialog & Reset)
  normalBack,   // Part >1 & Choice (Capsule button, normal pop)
  hidden,       // Reflection screen (Hidden, blocks OS swipe back)
}

class GameBackButton extends StatelessWidget {
  final BackButtonType type;
  final VoidCallback? customOnBack;

  const GameBackButton({
    required this.type,
    this.customOnBack,
    super.key,
  });

  Future<void> _showExitConfirmDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        final double width = MediaQuery.of(dialogContext).size.width;
        final double scale = (width / 874.0).clamp(0.85, 1.25);

        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 420.0 * scale,
            padding: EdgeInsets.all(26.0 * scale),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF7F0),
              borderRadius: BorderRadius.circular(24.0 * scale),
              border: Border.all(color: const Color(0xFF765E54), width: 2.0 * scale),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64.0 * scale,
                  height: 64.0 * scale,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDB2B2C).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: const Color(0xFFDB2B2C),
                    size: 38.0 * scale,
                  ),
                ),
                SizedBox(height: 18.0 * scale),
                Text(
                  'Keluar dari Skenario?',
                  style: GoogleFonts.lora(
                    fontSize: 21.0 * scale,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF5A3831),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.0 * scale),
                Text(
                  'Progresmu pada skenario ini akan diulang dari awal. Apakah kamu yakin ingin kembali ke Menu Pemilihan Skenario?',
                  style: GoogleFonts.poppins(
                    fontSize: 13.0 * scale,
                    color: const Color(0xFF765E54),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 26.0 * scale),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 13.0 * scale),
                          side: const BorderSide(color: Color(0xFF9C6C69), width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0 * scale),
                          ),
                        ),
                        child: Text(
                          'Lanjutkan',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF765E54),
                            fontWeight: FontWeight.w600,
                            fontSize: 13.0 * scale,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 14.0 * scale),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDB2B2C),
                          padding: EdgeInsets.symmetric(vertical: 13.0 * scale),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0 * scale),
                          ),
                        ),
                        child: Text(
                          'Keluar & Reset',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.0 * scale,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmed == true && context.mounted) {
      GameStateManager.instance.resetScenario();
      Navigator.of(context).pushAndRemoveUntil(
        FadePageRoute(page: const ScenarioSelectionScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (type == BackButtonType.hidden) {
      return Positioned(
        top: 0,
        left: 0,
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {},
          child: const SizedBox.shrink(),
        ),
      );
    }

    if (type == BackButtonType.scenarioRoot) {
      return Positioned(
        top: 25,
        left: 25,
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            _showExitConfirmDialog(context);
          },
          child: GestureDetector(
            onTap: () => _showExitConfirmDialog(context),
            child: Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFDF7F0),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFB59D93), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF765E54),
                size: 22,
              ),
            ),
          ),
        ),
      );
    }

    // normalBack
    return Positioned(
      top: 25,
      left: 25,
      child: PopScope(
        canPop: true,
        child: GestureDetector(
          onTap: customOnBack ?? () => Navigator.of(context).pop(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF7F0),
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
                color: const Color(0xFF765E54),
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
