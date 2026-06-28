import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/audio_service.dart';
import '../services/game_state_manager.dart';
import 'global_front_dialog.dart';

class GameQolOverlay extends StatelessWidget {
  const GameQolOverlay({super.key});

  void _showDialogueLog(BuildContext context, double scale) {
    AudioService.instance.playImportantClickSfx();
    final logs = GameStateManager.instance.dialogueHistory;

    GlobalFrontDialogController.show(
      barrierDismissible: true,
      builder: (close) {
        return Container(
          width: 520.0 * scale,
          height: 320.0 * scale,
          padding: EdgeInsets.all(24.0 * scale),
          decoration: BoxDecoration(
            color: const Color(0xFFFDF7F0),
            borderRadius: BorderRadius.circular(20.0 * scale),
            border: Border.all(color: const Color(0xFF765E54), width: 2.0 * scale),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 16.0,
                offset: const Offset(0, 8.0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.history_rounded, color: const Color(0xFF765E54), size: 22 * scale),
                      SizedBox(width: 8 * scale),
                      Text(
                        'Riwayat Percakapan',
                        style: GoogleFonts.lora(
                          fontSize: 18 * scale,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF5A3831),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: const Color(0xFF765E54), size: 22 * scale),
                    onPressed: () {
                      AudioService.instance.playImportantClickSfx();
                      close();
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              Divider(color: const Color(0xFFB59D93), thickness: 1.0 * scale, height: 24 * scale),
              Expanded(
                child: logs.isEmpty
                    ? Center(
                        child: Text(
                          'Belum ada percakapan yang tercatat.',
                          style: GoogleFonts.poppins(
                            fontSize: 13 * scale,
                            fontStyle: FontStyle.italic,
                            color: const Color(0xFF9C8881),
                          ),
                        ),
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: logs.length,
                        separatorBuilder: (context, index) => SizedBox(height: 12 * scale),
                        itemBuilder: (context, index) {
                          final log = logs[index];
                          final isSpeaker = log.contains(':');
                          final parts = isSpeaker ? log.split(':') : [log];

                          return Container(
                            padding: EdgeInsets.all(12 * scale),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(10 * scale),
                              border: Border.all(color: const Color(0xFFE5D7CD)),
                            ),
                            child: isSpeaker && parts.length >= 2
                                ? RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${parts[0]}:',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF765E54),
                                            fontSize: 12 * scale,
                                          ),
                                        ),
                                        TextSpan(
                                          text: parts.sublist(1).join(':'),
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF3D2B24),
                                            fontSize: 12 * scale,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Text(
                                    log,
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF3D2B24),
                                      fontSize: 12 * scale,
                                      height: 1.4,
                                    ),
                                  ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: GameStateManager.instance,
      builder: (context, _) {
        if (!GameStateManager.instance.isScenarioActive ||
            GameStateManager.instance.isEndingMode) {
          return const SizedBox.shrink();
        }

        final Size screenSize = MediaQuery.of(context).size;
        const double designWidth = 874.0;
        const double designHeight = 402.0;

        final double scaleX = screenSize.width / designWidth;
        final double scaleY = screenSize.height / designHeight;
        final double scale = min(scaleX, scaleY);

        final double activeCanvasWidth = designWidth * scale;
        final double activeCanvasHeight = designHeight * scale;
        final double offsetX = max(0.0, (screenSize.width - activeCanvasWidth) / 2);
        final double offsetY = max(0.0, (screenSize.height - activeCanvasHeight) / 2);

        return Positioned(
          top: offsetY + 18.0 * scale,
          right: offsetX + 195.0 * scale, // Placed to the left of GameStatsOverlay
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Log Button
              GestureDetector(
                onTap: () => _showDialogueLog(context, scale),
                child: Container(
                  width: 32 * scale,
                  height: 32 * scale,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF7F0),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF765E54), width: 1.5 * scale),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: const Color(0xFF765E54),
                    size: 16 * scale,
                  ),
                ),
              ),
              SizedBox(width: 8 * scale),
              // Mute Button
              ListenableBuilder(
                listenable: AudioService.instance,
                builder: (context, _) {
                  final isMuted = AudioService.instance.isMuted;
                  return GestureDetector(
                    onTap: () => AudioService.instance.toggleMute(),
                    child: Container(
                      width: 32 * scale,
                      height: 32 * scale,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF7F0),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF765E54), width: 1.5 * scale),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                        color: isMuted ? const Color(0xFFDB2B2C) : const Color(0xFF765E54),
                        size: 16 * scale,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
