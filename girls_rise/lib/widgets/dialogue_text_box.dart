import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DialogueTextBox extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final double boxWidth = width * scale;
    final double boxHeight = height * scale;

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
            padding: contentPadding ?? EdgeInsets.fromLTRB(
              41.0 * scale,
              30.0 * scale,
              35.0 * scale,
              20.0 * scale,
            ),
            child: child,
          ),
        ),

        // Optional Dialogue Header Tab SVG (Placed on top of the textbox relative to its top-left corner)
        if (headerTabAsset != null)
          Positioned(
            left: headerTabLeft * scale,
            top: headerTabTop * scale,
            width: headerTabWidth * scale,
            height: headerTabHeight * scale,
            child: IgnorePointer(
              child: SvgPicture.asset(
                headerTabAsset!,
                fit: BoxFit.contain,
              ),
            ),
          ),
      ],
    );
  }
}
