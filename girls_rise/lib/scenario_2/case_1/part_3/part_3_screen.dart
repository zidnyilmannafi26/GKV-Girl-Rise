import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../part_4_choose_1/part_4_choose_1_screen.dart';
import '../part_4_choose_2/part_4_choose_2_screen.dart';
import '../part_4_choose_3/part_4_choose_3_screen.dart';

class Part3Screen extends StatefulWidget {
  const Part3Screen({super.key});

  @override
  State<Part3Screen> createState() => _Part3ScreenState();
}

class _Part3ScreenState extends State<Part3Screen> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Design canvas dimensions (874 x 402)
    const double designWidth = 874.0;
    const double designHeight = 402.0;

    // Aspect-ratio locked containment scaling
    final double scaleX = screenWidth / designWidth;
    final double scaleY = screenHeight / designHeight;
    final double scale = min(scaleX, scaleY);
    final double activeCanvasWidth = designWidth * scale;
    final double activeCanvasHeight = designHeight * scale;
    final double offsetX = (screenWidth - activeCanvasWidth) / 2;
    final double offsetY = (screenHeight - activeCanvasHeight) / 2;

    return Scaffold(
      body: Stack(
        children: [
          // 2. Background Image: bg2.1.png
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg2.1.png',
              fit: BoxFit.cover,
            ),
          ),

          // Centered active viewport containment area
          // 3. Character in the center (Enlarged)
          Positioned(
            left: offsetX + 287.0 * scale,
            bottom: offsetY + 50.0 * scale,
            width: 300.0 * scale,
            height: 350.0 * scale,
            child: Image.asset(
              'assets/images/extracted_intro3.png',
              fit: BoxFit.contain,
            ),
          ),

          // Textbox Container
          Positioned(
            left: offsetX + 87.0 * scale,
            top: offsetY + 261.0 * scale,
            width: 700.0 * scale,
            height: 141.0 * scale,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Background Framing SVG
                Positioned(
                  left: -700.0 * scale * (99.25 / 478.40),
                  top: -141.0 * scale * (103.62 / 229.59),
                  width: 700.0 * scale * (628.0 / 478.40),
                  height: 141.0 * scale * (372.0 / 229.59),
                  child: IgnorePointer(
                    child: SvgPicture.asset(
                      'assets/text_Box/form 3.svg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

                // 5. Interactive Choices (Inside the textbox container)
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 20.0 * scale,
                      bottom: 10.0 * scale,
                      left: 40.0 * scale,
                      right: 40.0 * scale,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ChoiceButton(
                          text: 'Aku masih pengen sekolah dan ngejar cita-cita.',
                          scale: scale,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const Part4Choose1Screen(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 8.0 * scale),
                        ChoiceButton(
                          text: 'Gimana kalo aku kerja aja? Tapi tetap sambil sekolah.',
                          scale: scale,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const Part4Choose2Screen(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 8.0 * scale),
                        ChoiceButton(
                          text: 'Aku lagi banyak tugas, kita obrolin lagi besok ya.',
                          scale: scale,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const Part4Choose3Screen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 4. Dialogue Header Tab SVG (Placed after Textbox so it renders on top)
          Positioned(
            left: offsetX + 111.0 * scale,
            top: offsetY + 217.0 * scale,
            width: 184.0 * scale,
            height: 49.0 * scale,
            child: IgnorePointer(
              child: SvgPicture.asset(
                'assets/text_Box/OUTCOME.svg',
                fit: BoxFit.contain,
              ),
            ),
          ),

          // 6. Back Button (pill-shaped at top-left)
          Positioned(
            top: 25,
            left: 25,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
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
        ],
      ),
    );
  }
}

class ChoiceButton extends StatefulWidget {
  final String text;
  final double scale;
  final VoidCallback onTap;

  const ChoiceButton({
    required this.text,
    required this.scale,
    required this.onTap,
    super.key,
  });

  @override
  State<ChoiceButton> createState() => _ChoiceButtonState();
}

class _ChoiceButtonState extends State<ChoiceButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    double buttonScale = 1.0;
    if (_isPressed) {
      buttonScale = 0.98;
    } else if (_isHovered) {
      buttonScale = 1.02;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () async {
          setState(() {
            _isPressed = true;
          });
          // Small delay so that user can see the scale down animation
          await Future.delayed(const Duration(milliseconds: 100));
          if (mounted) {
            setState(() {
              _isPressed = false;
            });
            widget.onTap();
          }
        },
        child: AnimatedScale(
          scale: buttonScale,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          child: Container(
            height: 28.0 * widget.scale,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFDF7F0),
              borderRadius: BorderRadius.circular(8 * widget.scale),
              border: Border.all(
                color: const Color(0xFFB59D93),
                width: 1.2 * widget.scale,
              ),
            ),
            child: Text(
              widget.text,
              style: GoogleFonts.poppins(
                fontSize: 12.0 * widget.scale,
                color: const Color(0xFF765E54),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
