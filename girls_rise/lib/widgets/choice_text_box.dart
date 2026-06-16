import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/dialogue_text_box.dart';

class ChoiceTextBox extends StatelessWidget {
  final double scale;
  final String headerTabAsset;
  final String choice1Text;
  final String choice2Text;
  final String choice3Text;
  final VoidCallback onChoice1Tap;
  final VoidCallback onChoice2Tap;
  final VoidCallback onChoice3Tap;

  const ChoiceTextBox({
    required this.scale,
    required this.headerTabAsset,
    required this.choice1Text,
    required this.choice2Text,
    required this.choice3Text,
    required this.onChoice1Tap,
    required this.onChoice2Tap,
    required this.onChoice3Tap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DialogueTextBox(
      scale: scale,
      width: 700.0,
      height: 141.0,
      headerTabAsset: headerTabAsset,
      headerTabWidth: 184.0,
      headerTabHeight: 49.0,
      headerTabLeft: 24.0,
      headerTabTop: -44.0,
      contentPadding: EdgeInsets.fromLTRB(
        15.0 * scale,
        4.0 * scale,
        15.0 * scale,
        4.0 * scale,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceButton(
                text: choice1Text,
                scale: scale,
                onTap: onChoice1Tap,
              ),
              SizedBox(width: 16.0 * scale),
              ChoiceButton(
                text: choice3Text,
                scale: scale,
                onTap: onChoice3Tap,
              ),
            ],
          ),
          SizedBox(height: 10.0 * scale),
          ChoiceButton(
            text: choice2Text,
            scale: scale,
            onTap: onChoice2Tap,
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                'assets/text_Box/form 4.svg',
                width: 273.0 * widget.scale,
                height: 61.0 * widget.scale,
                fit: BoxFit.fill,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.0 * widget.scale,
                  vertical: 6.0 * widget.scale,
                ),
                child: Text(
                  widget.text,
                  style: GoogleFonts.lora(
                    fontSize: 10.5 * widget.scale,
                    color: const Color(0xFF765E54),
                    fontWeight: FontWeight.w500,
                    height: 1.3,
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
