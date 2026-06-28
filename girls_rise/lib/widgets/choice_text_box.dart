import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/dialogue_text_box.dart';
import '../services/audio_service.dart';

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
      showNextHint: false,
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

class _ChoiceButtonState extends State<ChoiceButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double buttonScale = 1.0;
    Color bgColor = const Color(0xFFFDF7F0).withValues(alpha: 0.85);
    Color borderColor = const Color(0xFF765E54).withValues(alpha: 0.3);

    if (_isPressed) {
      buttonScale = 0.94;
      bgColor = const Color(0xFFFFE8C5);
      borderColor = const Color(0xFF765E54);
    } else if (_isHovered) {
      buttonScale = 1.03;
      bgColor = const Color(0xFFFFF4E0);
      borderColor = const Color(0xFFB8860B);
    }

    final buttonContent = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 273.0 * widget.scale,
      height: 61.0 * widget.scale,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14.0 * widget.scale),
        border: Border.all(
          color: borderColor,
          width: (_isHovered || _isPressed ? 2.0 : 1.5) * widget.scale,
        ),
        boxShadow: [
          if (_isHovered || _isPressed)
            BoxShadow(
              color: const Color(0xFFB8860B).withValues(alpha: 0.25),
              blurRadius: 12.0 * widget.scale,
              offset: Offset(0, 4.0 * widget.scale),
            )
          else
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 6.0 * widget.scale,
              offset: Offset(0, 2.0 * widget.scale),
            ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12.0 * widget.scale,
          vertical: 6.0 * widget.scale,
        ),
        child: Text(
          widget.text,
          style: GoogleFonts.lora(
            fontSize: 10.8 * widget.scale,
            color: const Color(0xFF5A433B),
            fontWeight: _isHovered || _isPressed ? FontWeight.w700 : FontWeight.w600,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () async {
          AudioService.instance.playImportantClickSfx();
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
          duration: const Duration(milliseconds: 110),
          curve: Curves.easeOutBack,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14.0 * widget.scale),
            child: AnimatedBuilder(
              animation: _shimmerController,
              builder: (context, child) {
                final double progress = _shimmerController.value;
                if (progress > 0.3) return child!;
                final double sweepAlign = -1.5 + (progress / 0.3) * 3.0;

                return Stack(
                  children: [
                    child!,
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Align(
                          alignment: Alignment(sweepAlign, 0),
                          child: Transform.rotate(
                            angle: 0.45,
                            child: Container(
                              width: 35.0 * widget.scale,
                              height: 120.0 * widget.scale,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withValues(alpha: 0.0),
                                    Colors.white.withValues(alpha: 0.38),
                                    Colors.white.withValues(alpha: 0.0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              child: buttonContent,
            ),
          ),
        ),
      ),
    );
  }
}
