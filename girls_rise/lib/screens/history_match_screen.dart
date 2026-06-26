import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/match_record.dart';
import '../scenario_1/outcome_1/outcome_nikahmuda/outcome_nikahmuda_screen.dart';
import '../scenario_1/outcome_1/outcome_putus/outcome_putus_screen.dart';
import '../scenario_2/outcome_2/outcome_nikahmuda2/outcome_nikahmuda2_screen.dart';
import '../scenario_2/outcome_2/outcome_tidaknikah/outcome_tidaknikah_screen.dart';
import '../services/game_state_manager.dart';
import '../services/history_service.dart';
import '../utils/fade_page_route.dart';
import '../widgets/game_back_button.dart';

class HistoryMatchScreen extends StatefulWidget {
  const HistoryMatchScreen({super.key});

  @override
  State<HistoryMatchScreen> createState() => _HistoryMatchScreenState();
}

class _HistoryMatchScreenState extends State<HistoryMatchScreen> {
  late Future<List<MatchRecord>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _historyFuture = HistoryService.instance.getHistory();
    });
  }

  void _onTapRecord(MatchRecord record) {
    GameStateManager.instance.startHistoryPreview(record.stats);

    Widget targetScreen;
    switch (record.outcomeId) {
      case 'outcome_nikahmuda':
        targetScreen = const OutcomeNikahMudaScreen();
        break;
      case 'outcome_putus':
        targetScreen = const OutcomePutusScreen();
        break;
      case 'outcome_nikahmuda2':
        targetScreen = const OutcomeNikahMuda2Screen();
        break;
      case 'outcome_tidaknikah':
        targetScreen = const OutcomeTidakNikahScreen();
        break;
      default:
        targetScreen = const OutcomeNikahMudaScreen();
    }

    Navigator.of(context).push(FadePageRoute(page: targetScreen)).then((_) {
      if (mounted) {
        GameStateManager.instance.endScenario();
      }
    });
  }

  Future<void> _confirmReset() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFAF1E9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Hapus Seluruh Riwayat?',
          style: GoogleFonts.lora(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5A3831),
          ),
        ),
        content: Text(
          'Semua catatan permainan yang sudah Anda selesaikan akan dihapus permanen dari memori HP.',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: const Color(0xFF765E54),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF765E54),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC84B31),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Hapus',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await HistoryService.instance.clearHistory();
      _loadHistory();
    }
  }

  String _formatDateTime(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    final monthStr = months[dt.month - 1];
    final hStr = dt.hour.toString().padLeft(2, '0');
    final mStr = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} $monthStr • $hStr:$mStr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
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
              // Full background bg.home.png
              Positioned(
                left: offsetX,
                top: offsetY,
                width: 874.0 * scale,
                height: 402.0 * scale,
                child: Image.asset(
                  'assets/images/bg.home.png',
                  fit: BoxFit.cover,
                ),
              ),

              // Glassy overlay for readability
              Positioned(
                left: offsetX,
                top: offsetY,
                width: 874.0 * scale,
                height: 402.0 * scale,
                child: Container(
                  color: const Color(0xFF1E1E1E).withValues(alpha: 0.65),
                ),
              ),

              // Main Window Canvas
              Positioned(
                left: offsetX + 40 * scale,
                right: offsetX + 40 * scale,
                top: offsetY + 25 * scale,
                bottom: offsetY,
                child: Column(
                  children: [
                    // Header Title Centered & Delete Button on Right
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history_edu_rounded,
                              color: const Color(0xFFFAF1E9),
                              size: 26 * scale,
                            ),
                            SizedBox(width: 10 * scale),
                            Text(
                              'RIWAYAT PERMAINAN',
                              style: GoogleFonts.lora(
                                fontSize: 18 * scale,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFFAF1E9),
                                letterSpacing: 2.0,
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: const Color(0xFFFFB4B4),
                              size: 26 * scale,
                            ),
                            tooltip: 'Reset History',
                            onPressed: _confirmReset,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16 * scale),

                    // List View flush to bottom
                    Expanded(
                      child: FutureBuilder<List<MatchRecord>>(
                        future: _historyFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFFAF1E9),
                              ),
                            );
                          }

                          final records = snapshot.data ?? [];
                          if (records.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.sports_esports_outlined,
                                    size: 48 * scale,
                                    color: Colors.white38,
                                  ),
                                  SizedBox(height: 12 * scale),
                                  Text(
                                    'Belum ada skenario yang dimainkan.',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14 * scale,
                                      color: Colors.white60,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          // Newest at top
                          final reversedRecords = records.reversed.toList();

                          return ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: reversedRecords.length,
                            separatorBuilder: (_, _) =>
                                SizedBox(height: 12 * scale),
                            itemBuilder: (context, index) {
                              final record = reversedRecords[index];
                              final bool isRed = record.isNikahMuda;

                              // Pastel Red vs Pastel Blue background
                              final Color cardBg = isRed
                                  ? const Color(0xFFFFDADE)
                                  : const Color(0xFFD8EEFF);
                              final Color borderColor = isRed
                                  ? const Color(0xFFD97782)
                                  : const Color(0xFF77A8D9);

                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _onTapRecord(record),
                                  borderRadius:
                                      BorderRadius.circular(16 * scale),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20 * scale,
                                      vertical: 14 * scale,
                                    ),
                                    decoration: BoxDecoration(
                                      color: cardBg,
                                      borderRadius:
                                          BorderRadius.circular(16 * scale),
                                      border: Border.all(
                                        color: borderColor,
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.2),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              isRed ? '💍' : '🎓',
                                              style: TextStyle(
                                                fontSize: 22 * scale,
                                              ),
                                            ),
                                            SizedBox(width: 14 * scale),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Permainan ${record.matchNumber}  •  Skenario ${record.scenarioId}',
                                                  style: GoogleFonts.lora(
                                                    fontSize: 15 * scale,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color(
                                                      0xFF5A3831,
                                                    ), // Deep brown
                                                  ),
                                                ),
                                                SizedBox(height: 2 * scale),
                                                Text(
                                                  isRed
                                                      ? 'Ending: Menikah Muda'
                                                      : 'Ending: Mandiri Berdaya',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11.5 * scale,
                                                    fontWeight: FontWeight.w600,
                                                    color: isRed
                                                        ? const Color(
                                                            0xFF9C3440,
                                                          )
                                                        : const Color(
                                                            0xFF2A5E9C,
                                                          ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              _formatDateTime(record.timestamp),
                                              style: GoogleFonts.poppins(
                                                fontSize: 11 * scale,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xFF765E54),
                                              ),
                                            ),
                                            SizedBox(width: 8 * scale),
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 14 * scale,
                                              color: const Color(0xFF765E54),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Standard Game Back Button
              const GameBackButton(type: BackButtonType.normalBack),
            ],
          );
        },
      ),
    );
  }
}
