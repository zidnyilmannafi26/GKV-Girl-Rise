import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/dialogue_text_box.dart';

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
    return DialogueTextBox(
      scale: scale,
      width: 303.5,
      height: 225.9,
      headerTabAsset: headerTabAsset,
      headerTabWidth: 255.0,
      headerTabHeight: 52.0,
      headerTabLeft: 18.0,
      headerTabTop: -47.0,
      contentPadding: EdgeInsets.fromLTRB(
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
    );
  }
}
