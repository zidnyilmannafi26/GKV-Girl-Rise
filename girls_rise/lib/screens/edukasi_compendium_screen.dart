import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/audio_service.dart';

class EdukasiCompendiumScreen extends StatefulWidget {
  const EdukasiCompendiumScreen({super.key});

  @override
  State<EdukasiCompendiumScreen> createState() =>
      _EdukasiCompendiumScreenState();
}

class _EdukasiCompendiumScreenState extends State<EdukasiCompendiumScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        AudioService.instance.playImportantClickSfx();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    const double designWidth = 874.0;
    const double designHeight = 402.0;

    final double scaleX = screenSize.width / designWidth;
    final double scaleY = screenSize.height / designHeight;
    final double scale = min(scaleX, scaleY);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Stack(
        children: [
          // Background framing
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [const Color(0xFF3A2E2A), const Color(0xFF1A1412)],
                  radius: 1.2,
                ),
              ),
            ),
          ),

          // Main Journal Box
          Center(
            child: Container(
              width: 730 * scale,
              height: 340 * scale,
              padding: EdgeInsets.all(22 * scale),
              decoration: BoxDecoration(
                color: const Color(0xFFFDF7F0),
                borderRadius: BorderRadius.circular(24 * scale),
                border: Border.all(
                  color: const Color(0xFF765E54),
                  width: 2.5 * scale,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 24 * scale,
                    offset: Offset(0, 12 * scale),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8 * scale),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF765E54,
                          ).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12 * scale),
                        ),
                        child: Icon(
                          Icons.auto_stories_rounded,
                          color: const Color(0xFF765E54),
                          size: 26 * scale,
                        ),
                      ),
                      SizedBox(width: 12 * scale),
                      Text(
                        'POJOK EDUKASI',
                        style: GoogleFonts.cinzel(
                          fontSize: 21 * scale,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF5A3831),
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16 * scale),

                  // Tab Bar
                  Container(
                    height: 52 * scale,
                    padding: EdgeInsets.all(5 * scale),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBE0D5),
                      borderRadius: BorderRadius.circular(16 * scale),
                      border: Border.all(
                        color: const Color(0xFFC4B0A3),
                        width: 1.2 * scale,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4 * scale,
                          offset: Offset(0, 2 * scale),
                        ),
                      ],
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF765E54), Color(0xFF5A3831)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12 * scale),
                        border: Border.all(
                          color: const Color(0xFFF7D070).withValues(alpha: 0.7),
                          width: 1.2 * scale,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF5A3831,
                            ).withValues(alpha: 0.35),
                            blurRadius: 6 * scale,
                            offset: Offset(0, 2 * scale),
                          ),
                        ],
                      ),
                      labelColor: const Color(0xFFFDF7F0),
                      unselectedLabelColor: const Color(0xFF765E54),
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 13.5 * scale,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                      unselectedLabelStyle: GoogleFonts.poppins(
                        fontSize: 12.5 * scale,
                        fontWeight: FontWeight.w500,
                      ),
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: '⚖️ Fakta & Hukum'),
                        Tab(text: '🌱 Resiliensi Mental'),
                        Tab(text: '📞 Hotline Bantuan'),
                      ],
                    ),
                  ),
                  SizedBox(height: 16 * scale),

                  // Tab Views
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildArticleTab(
                          scale,
                          title: 'Realitas Pernikahan Dini & Undang-Undang',
                          content:
                              'Di Indonesia, Undang-Undang No. 16 Tahun 2019 menegaskan bahwa batas usia minimal perkawinan bagi perempuan dan laki-laki adalah 19 tahun.\n\n'
                              'Pernikahan di bawah umur memiliki risiko tinggi terhadap kesehatan reproduksi, komplikasi kehamilan, dan sering kali memutus hak anak atas pendidikan formal. '
                              'Tanpa ijazah dan keterampilan yang memadai, perempuan rentan mengalami ketergantungan finansial dan terjebak dalam lingkaran kemiskinan.\n\n'
                              '💡 Ingat: Masa depanmu berharga. Kamu berhak mengejar cita-cita sebelum mengambil keputusan besar dalam hidup.',
                        ),
                        _buildArticleTab(
                          scale,
                          title: 'Pentingnya Pendidikan & Ketahanan Mental',
                          content:
                              'Resiliensi atau ketahanan mental adalah kemampuan seseorang untuk bangkit kembali setelah menghadapi masa-masa sulit atau tekanan sosial yang berat.\n\n'
                              'Dalam Girl Rise, parameter Pendidikan dan Ekonomi saling terhubung erat dengan Kesehatan Mental. Ketika kamu mandiri secara intelektual dan finansial, '
                              'kamu memiliki suara yang lebih kuat dalam keluarga dan masyarakat untuk menolak paksaan atau relasi yang toksik.\n\n'
                              '💡 Ingat: Menjaga batasan diri (personal boundaries) dan fokus pada pengembangan diri adalah langkah awal kepemimpinan perempuan.',
                        ),
                        _buildHelplineTab(scale),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Pill-shaped Back Button (top left)
          Positioned(
            top: 13,
            left: 13,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                AudioService.instance.playImportantClickSfx();
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF1E9),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF9C6C69),
                      width: 1.5,
                    ),
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
                    color: Color(0xFF5A3831),
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleTab(
    double scale, {
    required String title,
    required String content,
  }) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: 16 * scale,
        vertical: 8 * scale,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.lora(
              fontSize: 16 * scale,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5A3831),
            ),
          ),
          SizedBox(height: 10 * scale),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 12.5 * scale,
              height: 1.6,
              color: const Color(0xFF3D2B24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelplineTab(double scale) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: 16 * scale,
        vertical: 4 * scale,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Layanan Konseling & Bantuan Darurat Nyata',
            style: GoogleFonts.lora(
              fontSize: 16 * scale,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5A3831),
            ),
          ),
          SizedBox(height: 6 * scale),
          Text(
            'Jika kamu atau kerabatmu mengalami pemaksaan pernikahan, kekerasan, atau krisis mental, jangan ragu menghubungi kontak resmi di bawah ini:',
            style: GoogleFonts.poppins(
              fontSize: 12 * scale,
              color: const Color(0xFF765E54),
            ),
          ),
          SizedBox(height: 12 * scale),
          _buildHelplineCard(
            scale,
            name: 'Komnas Perempuan (SAPA 129)',
            desc:
                'Layanan Pengaduan Sahabat Perempuan & Anak untuk kekerasan berbasis gender.',
            phone: 'Hotline: 129 / WhatsApp: 08111-129-129',
          ),
          SizedBox(height: 10 * scale),
          _buildHelplineCard(
            scale,
            name: 'TePSA Kementerian Sosial',
            desc: 'Telepon Pelayanan Sosial Anak & Perlindungan Hak Remaja.',
            phone: 'Hotline: 1500-771',
          ),
        ],
      ),
    );
  }

  Widget _buildHelplineCard(
    double scale, {
    required String name,
    required String desc,
    required String phone,
  }) {
    return Container(
      padding: EdgeInsets.all(12 * scale),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12 * scale),
        border: Border.all(color: const Color(0xFFD8C7B5), width: 1.2 * scale),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10 * scale),
            decoration: BoxDecoration(
              color: const Color(0xFF765E54).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.phone_in_talk_rounded,
              color: const Color(0xFF765E54),
              size: 22 * scale,
            ),
          ),
          SizedBox(width: 14 * scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 13 * scale,
                    color: const Color(0xFF5A3831),
                  ),
                ),
                SizedBox(height: 2 * scale),
                Text(
                  desc,
                  style: GoogleFonts.poppins(
                    fontSize: 11 * scale,
                    color: const Color(0xFF5A3831).withValues(alpha: 0.8),
                  ),
                ),
                SizedBox(height: 4 * scale),
                Text(
                  phone,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 11.5 * scale,
                    color: const Color(0xFFDB2B2C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
