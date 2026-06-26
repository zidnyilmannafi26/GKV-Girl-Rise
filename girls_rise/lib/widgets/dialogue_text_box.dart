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
  final String? bgSvgAsset;
  final bool showNextHint;

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
    this.bgSvgAsset,
    this.showNextHint = true,
    super.key,
  });

  @override
  State<DialogueTextBox> createState() => _DialogueTextBoxState();
}

class _DialogueTextBoxState extends State<DialogueTextBox> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _bounceAnim;
  bool _canScroll = false;

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

  bool _handleScrollNotification(ScrollMetrics metrics) {
    // Show the indicator if we can scroll and haven't reached the bottom
    final canScroll = metrics.maxScrollExtent > 0 && metrics.pixels < metrics.maxScrollExtent - 2.0;
    if (_canScroll != canScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _canScroll = canScroll;
          });
        }
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final double boxWidth = widget.width * widget.scale;
    final double boxHeight = widget.height * widget.scale;

    final String selectedBgSvg = widget.bgSvgAsset ??
        ((widget.width / widget.height > 3.0)
            ? 'assets/text_Box/form 5.svg'
            : 'assets/text_Box/form 3.svg');

    final bool isForm5 = selectedBgSvg == 'assets/text_Box/form 5.svg';

    final double bgLeft = isForm5 ? 0.0 : -boxWidth * (99.25 / 478.40);
    final double bgTop = isForm5 ? -boxHeight * (37.0 / 132.0) : -boxHeight * (103.62 / 229.59);
    final double bgWidth = isForm5 ? boxWidth : boxWidth * (628.0 / 478.40);
    final double bgHeight = isForm5 ? boxHeight * (169.0 / 132.0) : boxHeight * (372.0 / 229.59);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background Native Box (Replaces heavy SVG)
        Positioned(
          left: 0,
          top: 0,
          width: boxWidth,
          height: boxHeight,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFDF7F0).withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16.0 * widget.scale),
              border: Border.all(
                color: const Color(0xFF765E54).withValues(alpha: 0.5),
                width: 2.0 * widget.scale,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8.0,
                  offset: const Offset(2.0, 4.0),
                )
              ],
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
            child: NotificationListener<ScrollMetricsNotification>(
              onNotification: (notification) {
                _handleScrollNotification(notification.metrics);
                return false;
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  _handleScrollNotification(notification.metrics);
                  return false;
                },
                child: widget.child,
              ),
            ),
          ),
        ),

        // Next / Continue Hint Indicator
        if (widget.showNextHint && !_canScroll)
          Positioned(
            bottom: 10.0 * widget.scale,
            right: 25.0 * widget.scale,
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _bounceAnim,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_bounceAnim.value - 2.0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 12.0 * widget.scale,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF765E54).withValues(alpha: 0.6),
                            letterSpacing: 0.6,
                          ),
                        ),
                        SizedBox(width: 4.0 * widget.scale),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 10.0 * widget.scale,
                          color: const Color(0xFF765E54).withValues(alpha: 0.6),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        else if (_canScroll)
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

        // Optional Dialogue Header Tab (Native text instead of SVG)
        if (widget.headerTabAsset != null)
          Positioned(
            left: widget.headerTabLeft * widget.scale,
            top: widget.headerTabTop * widget.scale,
            width: widget.headerTabWidth * widget.scale,
            height: widget.headerTabHeight * widget.scale,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF765E54),
                borderRadius: BorderRadius.circular(12.0 * widget.scale),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4.0,
                    offset: const Offset(0, 2.0),
                  )
                ],
              ),
              child: Text(
                widget.headerTabAsset!.split('/').last.replaceAll('.svg', '').toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0 * widget.scale,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFDF7F0),
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
