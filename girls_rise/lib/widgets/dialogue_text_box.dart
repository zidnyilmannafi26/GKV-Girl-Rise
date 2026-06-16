import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DialogueTextBox extends StatefulWidget {
  final double scale;
  final double width;
  final double height;
  final Widget child;
  final EdgeInsetsGeometry? contentPadding;
  
  // Header Tab parameters
  final String? headerTabAsset;
  final double headerTabWidth;
  final double headerTabHeight;
  final double headerTabLeft;
  final double headerTabTop;

  const DialogueTextBox({
    required this.scale,
    required this.width,
    required this.height,
    required this.child,
    this.contentPadding,
    this.headerTabAsset,
    this.headerTabWidth = 184.0,
    this.headerTabHeight = 49.0,
    this.headerTabLeft = 24.0,
    this.headerTabTop = -44.0,
    super.key,
  });

  @override
  State<DialogueTextBox> createState() => _DialogueTextBoxState();
}

class _DialogueTextBoxState extends State<DialogueTextBox> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _bounceAnim = Tween<double>(begin: 0, end: 4.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double boxWidth = widget.width * widget.scale;
    final double boxHeight = widget.height * widget.scale;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background Framing SVG (form 3.svg)
        Positioned(
          left: -boxWidth * (99.25 / 478.40),
          top: -boxHeight * (103.62 / 229.59),
          width: boxWidth * (628.0 / 478.40),
          height: boxHeight * (372.0 / 229.59),
          child: IgnorePointer(
            child: SvgPicture.asset(
              'assets/text_Box/form 3.svg',
              fit: BoxFit.fill,
            ),
          ),
        ),

        // Content
        Positioned.fill(
          child: Padding(
            padding: widget.contentPadding ?? EdgeInsets.fromLTRB(
              41.0 * widget.scale,
              30.0 * widget.scale,
              35.0 * widget.scale,
              25.0 * widget.scale, // increased bottom padding to avoid overlapping the indicator
            ),
            child: widget.child,
          ),
        ),

        // Scroll/Continue Indicator (Bouncing Triangle)
        Positioned(
          bottom: 10.0 * widget.scale,
          right: 35.0 * widget.scale,
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _bounceAnim,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _bounceAnim.value),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: const Color(0xFF765E54),
                    size: 26.0 * widget.scale,
                  ),
                );
              },
            ),
          ),
        ),

        // Optional Dialogue Header Tab SVG
        if (widget.headerTabAsset != null)
          Positioned(
            left: widget.headerTabLeft * widget.scale,
            top: widget.headerTabTop * widget.scale,
            width: widget.headerTabWidth * widget.scale,
            height: widget.headerTabHeight * widget.scale,
            child: IgnorePointer(
              child: SvgPicture.asset(
                widget.headerTabAsset!,
                fit: BoxFit.contain,
              ),
            ),
          ),
      ],
    );
  }
}
