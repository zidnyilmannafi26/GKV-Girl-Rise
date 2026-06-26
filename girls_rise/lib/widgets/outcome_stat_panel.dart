import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/game_stats.dart';

class OutcomeStatPanel extends StatefulWidget {
  final bool isNikahMuda;
  final List<StatItem> stats;
  final double scale;

  const OutcomeStatPanel({
    super.key,
    required this.isNikahMuda,
    required this.stats,
    required this.scale,
  });

  @override
  State<OutcomeStatPanel> createState() => _OutcomeStatPanelState();
}

class _OutcomeStatPanelState extends State<OutcomeStatPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static String _cap(String str) {
    if (str.isEmpty) return str;
    return str[0].toUpperCase() + str.substring(1);
  }

  static String _getEducationText(int val, bool capitalize) {
    String str;
    if (val <= 0) {
      str = "sekolah dan karier impianmu terhenti sepenuhnya";
    } else if (val <= 25) {
      str = "pendidikanmu terbengkalai jauh";
    } else if (val <= 50) {
      str = "nilai akademismu menurun drastis";
    } else if (val <= 75) {
      str = "sekolahmu bertahan walau berat";
    } else if (val <= 100) {
      str = "akademismu tetap stabil terjaga";
    } else {
      str = "karier dan prestasi sekolahmu luar biasa";
    }
    return capitalize ? _cap(str) : str;
  }

  static String _getEconomyText(int val, bool capitalize) {
    String str;
    if (val <= 0) {
      str = "finansialmu hancur total";
    } else if (val <= 25) {
      str = "keuanganmu sangat tidak stabil";
    } else if (val <= 50) {
      str = "keuanganmu pas-pasan dan kurang";
    } else if (val <= 75) {
      str = "kondisi ekonomimu cukup aman";
    } else if (val <= 100) {
      str = "keuanganmu sudah stabil dan mandiri";
    } else {
      str = "keuangan dan tabunganmu sangat baik";
    }
    return capitalize ? _cap(str) : str;
  }

  static String _getRelationText(int val, bool capitalize) {
    String str;
    if (val <= 0) {
      str = "hubungan sosialmu menjadi toxic";
    } else if (val <= 25) {
      str = "kamu merasa kesepian";
    } else if (val <= 50) {
      str = "ikatan pertemananmu mulai merenggang";
    } else if (val <= 75) {
      str = "lingkungan sekitarmu cukup suportif";
    } else if (val <= 100) {
      str = "hubungan dengan orang sekitarmu sangat sehat";
    } else {
      str = "relasimu sangat luas dan positif";
    }
    return capitalize ? _cap(str) : str;
  }

  static String _getMentalText(int val, bool capitalize) {
    String str;
    if (val <= 0) {
      str = "mentalmu hancur dan kamu trauma berat";
    } else if (val <= 25) {
      str = "stres berat menemanimu setiap hari";
    } else if (val <= 50) {
      str = "kamu cemas dan lelah secara emosional";
    } else if (val <= 75) {
      str = "kondisi mentalmu cukup stabil";
    } else if (val <= 100) {
      str = "kondisi mentalmu aman dan baik";
    } else {
      str = "kesehatan mentalmu sangat baik";
    }
    return capitalize ? _cap(str) : str;
  }

  String _generateExplanation() {
    final map = {for (var s in widget.stats) s.type: s.value};
    final edu = map[StatType.pendidikan] ?? 50;
    final eko = map[StatType.ekonomi] ?? 50;
    final rel = map[StatType.relasi] ?? 50;
    final men = map[StatType.mental] ?? 50;

    final prefix = widget.isNikahMuda
        ? "Kamu menjalin hubungan pernikahan dini. "
        : "Kamu tumbuh menjadi wanita mandiri yang sukses. ";

    final s1Part1 = _getEducationText(edu, true);
    final conj1 = eko <= 50 ? "namun" : "dan";
    final s1Part2 = _getEconomyText(eko, false);
    final sentence1 = "$s1Part1, $conj1 $s1Part2.";

    const trans = "Di sisi lain, ";
    final s2Part1 = _getRelationText(rel, false);
    final conj2 = men <= 50 ? "padahal" : "serta";
    final s2Part2 = _getMentalText(men, false);
    final sentence2 = "$trans$s2Part1, $conj2 $s2Part2.";

    return "$prefix$sentence1 $sentence2";
  }

  Color _getBarColor(int val) {
    if (val > 75) return const Color(0xFF4CAF50); // Green
    if (val >= 26) return const Color(0xFFFFA726); // Orange/Yellow
    return const Color(0xFFE53935); // Red
  }

  Widget _buildStatBar(StatItem item) {
    final double s = widget.scale;
    final double normalized = ((item.value + 50) / 200).clamp(0.0, 1.0);
    final Color barColor = _getBarColor(item.value);

    // Zoom into authentic game SVG icon coordinate area (approx 7,4 18x18)
    final String iconOnlySvg = item.type.iconSvg.replaceFirst(
      'width="141" height="26" viewBox="0 0 141 26"',
      'width="20" height="20" viewBox="7 4 18 18"',
    );

    return Padding(
      padding: EdgeInsets.only(bottom: 12.0 * s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.string(
                    iconOnlySvg,
                    width: 17.0 * s,
                    height: 17.0 * s,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF765E54),
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 8.0 * s),
                  Text(
                    item.type.title,
                    style: GoogleFonts.poppins(
                      fontSize: 13.0 * s,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF765E54),
                    ),
                  ),
                ],
              ),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, _) {
                  final int displayVal = (item.value * _animation.value).round();
                  return Text(
                    '$displayVal%',
                    style: GoogleFonts.poppins(
                      fontSize: 12.0 * s,
                      fontWeight: FontWeight.bold,
                      color: barColor,
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 5.0 * s),
          Container(
            height: 10.0 * s,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF765E54).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(5.0 * s),
            ),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, _) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: normalized * _animation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(5.0 * s),
                      boxShadow: [
                        BoxShadow(
                          color: barColor.withValues(alpha: 0.3),
                          blurRadius: 4.0,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double s = widget.scale;
    final Color bgColor = widget.isNikahMuda
        ? const Color(0xFFEDE4DB) // Melancholic warm tone
        : const Color(0xFFFDF7F0); // Triumphant bright ivory

    // Order stats logically: Pendidikan, Ekonomi, Relasi, Mental
    final orderedTypes = [
      StatType.pendidikan,
      StatType.ekonomi,
      StatType.relasi,
      StatType.mental,
    ];
    final statMap = {for (var item in widget.stats) item.type: item};
    final orderedStats = orderedTypes
        .map((t) => statMap[t] ?? StatItem(type: t, value: 50, initialRank: 0))
        .toList();

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: bgColor,
      padding: EdgeInsets.symmetric(horizontal: 24.0 * s, vertical: 32.0 * s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HASIL AKUMULASI',
            style: GoogleFonts.poppins(
              fontSize: 15.0 * s,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: const Color(0xFF765E54),
            ),
          ),
          SizedBox(height: 16.0 * s),
          ...orderedStats.map((item) => _buildStatBar(item)),
          SizedBox(height: 16.0 * s),
          Divider(color: const Color(0xFFB59D93).withValues(alpha: 0.5), thickness: 1),
          SizedBox(height: 16.0 * s),
          Expanded(
            child: SingleChildScrollView(
              child: FadeTransition(
                opacity: _animation,
                child: Text(
                  _generateExplanation(),
                  style: GoogleFonts.lora(
                    fontSize: 13.5 * s,
                    height: 1.6,
                    color: const Color(0xFF765E54),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
