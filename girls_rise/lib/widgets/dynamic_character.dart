import 'dart:math';
import 'package:flutter/material.dart';

class DynamicCharacter extends StatefulWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final double? scale;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final Color? color;
  final BlendMode? colorBlendMode;
  final bool gaplessPlayback;

  const DynamicCharacter(
    this.assetPath, {
    this.width,
    this.height,
    this.scale,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.bottomCenter, // Strictly anchor bottom edge to screen floor
    this.color,
    this.colorBlendMode,
    this.gaplessPlayback = true,
    super.key,
  });

  @override
  State<DynamicCharacter> createState() => _DynamicCharacterState();
}

class _DynamicCharacterState extends State<DynamicCharacter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _phaseOffset;

  @override
  void initState() {
    super.initState();
    _phaseOffset = (widget.assetPath.hashCode % 1000) / 1000.0 * 2 * pi;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double t = (_controller.value * 2 * pi) + _phaseOffset;

        // 1. Pure Grounded Inhalation (Strictly Upward Expansion):
        // (sin(t) + 1.0) goes from 0.0 to 2.0.
        // Vertical scale goes strictly from 1.000 (at rest) to 1.008 (peak breath).
        // At bottom boundary (y=0), displacement is EXACTLY 0.0px. Zero foot lift!
        final double breatheScaleY = 1.0 + ((sin(t) + 1.0) * 0.004);

        // 2. Pure Floor-Parallel Glide:
        // Gentle horizontal glide (+/- 0.6 px) parallel to the floor line.
        // Eliminates tilt rotation so corners NEVER lift off the floor plane.
        final double offsetX = cos(t * 0.8) * 0.6;

        return Transform.translate(
          offset: Offset(offsetX, 0), // Vertical translation is strictly 0!
          child: Transform(
            alignment: Alignment.bottomCenter,
            transform: Matrix4.diagonal3Values(1.0, breatheScaleY, 1.0),
            child: child,
          ),
        );
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 380),
        switchInCurve: Curves.easeOutQuad,
        switchOutCurve: Curves.easeInQuad,
        child: Image.asset(
          widget.assetPath,
          key: ValueKey<String>(widget.assetPath),
          width: widget.width,
          height: widget.height,
          scale: widget.scale,
          fit: widget.fit,
          alignment: widget.alignment,
          color: widget.color,
          colorBlendMode: widget.colorBlendMode,
          gaplessPlayback: widget.gaplessPlayback,
        ),
      ),
    );
  }
}
