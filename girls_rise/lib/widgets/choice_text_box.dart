import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/dialogue_text_box.dart';

class ChoiceTextBox extends StatelessWidget {
  final double scale;
  final String headerTabAsset;
  final String choice1Text;
  final String? choice2Text;
  final String? choice3Text;
  final VoidCallback onChoice1Tap;
  final VoidCallback? onChoice2Tap;
  final VoidCallback? onChoice3Tap;

  const ChoiceTextBox({
    required this.scale,
    required this.headerTabAsset,
    required this.choice1Text,
    this.choice2Text,
    this.choice3Text,
    required this.onChoice1Tap,
    this.onChoice2Tap,
    this.onChoice3Tap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final showChoice2 = choice2Text != null && onChoice2Tap != null && choice2Text!.isNotEmpty;
    final showChoice3 = choice3Text != null && onChoice3Tap != null && choice3Text!.isNotEmpty;

    Widget content;
    if (showChoice2 && !showChoice3) {
      content = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ChoiceButton(
            text: choice1Text,
            scale: scale,
            onTap: onChoice1Tap,
          ),
          SizedBox(width: 24.0 * scale),
          ChoiceButton(
            text: choice2Text!,
            scale: scale,
            onTap: onChoice2Tap!,
          ),
        ],
      );
    } else {
      content = Column(
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
              if (showChoice3) ...[
                SizedBox(width: 16.0 * scale),
                ChoiceButton(
                  text: choice3Text!,
                  scale: scale,
                  onTap: onChoice3Tap!,
                ),
              ],
            ],
          ),
          if (showChoice2) ...[
            SizedBox(height: 10.0 * scale),
            ChoiceButton(
              text: choice2Text!,
              scale: scale,
              onTap: onChoice2Tap!,
            ),
          ],
        ],
      );
    }

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
      child: content,
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
              Container(
                width: 273.0 * widget.scale,
                height: 61.0 * widget.scale,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF7F0).withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12.0 * widget.scale),
                  border: Border.all(
                    color: const Color(0xFF765E54).withValues(alpha: 0.3),
                    width: 1.5 * widget.scale,
                  ),
                ),
              ),
              SizedBox(
                width: 273.0 * widget.scale,
                child: Padding(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
