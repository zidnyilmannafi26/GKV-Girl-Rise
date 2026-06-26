import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/game_stats.dart';

class GameParameterBar extends StatefulWidget {
  final StatItem item;
  final double scale;

  const GameParameterBar({
    required this.item,
    required this.scale,
    super.key,
  });

  @override
  State<GameParameterBar> createState() => _GameParameterBarState();
}

class _GameParameterBarState extends State<GameParameterBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.08).chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.08, end: 1.0).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 65,
      ),
    ]).animate(_pulseController);
  }

  @override
  void didUpdateWidget(GameParameterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.value != widget.item.value) {
      _pulseController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color _getActiveColor(int value) {
    if (value < 25) return const Color(0xFFDB2B2C); // Merah (<25 & minus)
    if (value <= 50) return const Color(0xFFF6B717); // Kuning (25-50)
    if (value <= 100) return const Color(0xFF43A047); // Hijau (51-100)
    return const Color(0xFF1E88E5); // Biru (>100 fallback color)
  }

  LinearGradient _getFillGradient(int value, Color baseColor) {
    if (value > 100) {
      return const LinearGradient(
        colors: [Color(0xFF43A047), Color(0xFF1E88E5)], // Hijau ke Biru
      );
    }
    return LinearGradient(colors: [baseColor, baseColor]);
  }

  @override
  Widget build(BuildContext context) {
    final int val = widget.item.value;
    final Color activeColor = _getActiveColor(val);
    final double clampedPercent = val.clamp(0, 100).toDouble();
    final double maxBarWidth = 72.0 * widget.scale;
    final double targetBarWidth = (clampedPercent / 100.0) * maxBarWidth;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final double pulseScale = _scaleAnimation.value;
        final bool isPulsing = _pulseController.isAnimating;
        final double glowAlpha = isPulsing ? 0.45 * sin(_pulseController.value * pi) : 0.0;

        return Transform.scale(
          scale: pulseScale,
          child: Container(
            width: 141.0 * widget.scale,
            height: 26.0 * widget.scale,
            decoration: BoxDecoration(
              color: const Color(0xFFFAF1E9),
              borderRadius: BorderRadius.circular(13.0 * widget.scale),
              border: Border.all(
                color: glowAlpha > 0 ? activeColor : const Color(0xFF9C6C69),
                width: (glowAlpha > 0 ? 1.6 : 1.0) * widget.scale,
              ),
              boxShadow: [
                BoxShadow(
                  color: (glowAlpha > 0 ? activeColor : Colors.black).withValues(alpha: glowAlpha > 0 ? glowAlpha : 0.06),
                  blurRadius: (glowAlpha > 0 ? 8 : 3) * widget.scale,
                  offset: Offset(0, 1.5 * widget.scale),
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: Stack(
        children: [
          // Stat Icon
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13.0 * widget.scale),
              child: SvgPicture.string(
                widget.item.type.iconSvg,
                fit: BoxFit.fill,
                colorFilter: ColorFilter.mode(activeColor, BlendMode.srcIn),
              ),
            ),
          ),

          // Progress Track Background (#EECCBF)
          Positioned(
            left: 28.0 * widget.scale,
            top: 10.0 * widget.scale,
            width: maxBarWidth,
            height: 6.0 * widget.scale,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEECCBF),
                borderRadius: BorderRadius.circular(3.0 * widget.scale),
              ),
            ),
          ),

          // Progress Bar Fill (Animated width & glow)
          TweenAnimationBuilder<double>(
            tween: Tween<double>(end: targetBarWidth),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, currentWidth, _) {
              return Positioned(
                left: 28.0 * widget.scale,
                top: 10.0 * widget.scale,
                width: currentWidth,
                height: 6.0 * widget.scale,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: _getFillGradient(val, activeColor),
                    borderRadius: BorderRadius.circular(3.0 * widget.scale),
                    boxShadow: [
                      if (currentWidth > 0)
                        BoxShadow(
                          color: activeColor.withValues(alpha: 0.35),
                          blurRadius: 2.5 * widget.scale,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Percentage Text String (Smooth Animated Counter)
          Positioned(
            right: 8.5 * widget.scale,
            top: 0,
            bottom: 0,
            child: Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(end: val.toDouble()),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                builder: (context, numVal, _) {
                  final int displayNum = numVal.round();
                  return Text(
                    '$displayNum%',
                    style: GoogleFonts.lora(
                      fontSize: 10.5 * widget.scale,
                      fontWeight: FontWeight.w700,
                      color: activeColor,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
