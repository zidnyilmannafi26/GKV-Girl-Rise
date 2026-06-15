import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ReflectionTextBox extends StatelessWidget {
  final double scale;
  final String headerTabAsset;
  final String quoteText;
  final String reflectionText;

  const ReflectionTextBox({
    required this.scale,
    required this.headerTabAsset,
    required this.quoteText,
    required this.reflectionText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double textboxWidth = 303.5 * scale;
    final double textboxHeight = 225.9 * scale;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Textbox SVG with offset (form 3.svg)
        Positioned(
          left: -textboxWidth * (99.25 / 478.40),
          top: -textboxHeight * (103.62 / 229.59),
          width: textboxWidth * (628.0 / 478.40),
          height: textboxHeight * (372.0 / 229.59),
          child: IgnorePointer(
            child: SvgPicture.asset(
              'assets/text_Box/form 3.svg',
              fit: BoxFit.fill,
            ),
          ),
        ),

        // Text Content
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              15.0 * scale,
              22.0 * scale,
              15.0 * scale,
              20.0 * scale,
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Small Dialogue Quote Box (form 4.svg)
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/text_Box/form 4.svg',
                          width: 273.0 * scale,
                          height: 61.0 * scale,
                          fit: BoxFit.fill,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0 * scale, vertical: 8.0 * scale),
                          child: Text(
                            quoteText,
                            style: GoogleFonts.lora(
                              fontSize: 13.5 * scale,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF765E54),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.0 * scale),
                    // Reflection Text
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0 * scale),
                      child: Text(
                        reflectionText,
                        style: GoogleFonts.lora(
                          fontSize: 14.5 * scale,
                          height: 1.45,
                          color: const Color(0xFF765E54),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Dialogue Header Tab SVG (Positioned on top of the textbox relative to its top-left corner)
        Positioned(
          left: 18.0 * scale,
          top: -47.0 * scale,
          width: 255.0 * scale,
          height: 52.0 * scale,
          child: IgnorePointer(
            child: SvgPicture.asset(
              headerTabAsset,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
