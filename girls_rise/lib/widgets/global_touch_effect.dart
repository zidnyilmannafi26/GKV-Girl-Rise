import 'dart:math';
import 'package:flutter/material.dart';

class GlobalTouchEffectController {
  static final GlobalTouchEffectController instance = GlobalTouchEffectController._();
  GlobalTouchEffectController._();

  final ValueNotifier<int> _triggerNotifier = ValueNotifier<int>(0);
  final List<TouchRipple> activeRipples = [];

  void triggerEffect(Offset globalPosition) {
    activeRipples.add(TouchRipple(globalPosition));
    _triggerNotifier.value++;
  }
}

class TouchRipple {
  final Offset position;
  double progress = 0.0;
  final List<RippleParticle> particles = [];
  static const double durationSeconds = 0.4;

  TouchRipple(this.position) {
    final rnd = Random();
    // Only 4 soft, gentle floating dust specks
    for (int i = 0; i < 4; i++) {
      final angle = (i * pi / 2) + (rnd.nextDouble() * 0.5 - 0.25);
      final speed = 12.0 + rnd.nextDouble() * 8.0; // Very soft drift
      final size = 1.2 + rnd.nextDouble() * 1.0;
      particles.add(RippleParticle(angle, speed, size));
    }
  }

  void update(double dt) {
    progress += dt / durationSeconds;
  }

  bool get isFinished => progress >= 1.0;
}

class RippleParticle {
  final double angle;
  final double speed;
  final double size;

  RippleParticle(this.angle, this.speed, this.size);
}

class GlobalTouchEffectOverlay extends StatefulWidget {
  const GlobalTouchEffectOverlay({super.key});

  @override
  State<GlobalTouchEffectOverlay> createState() => _GlobalTouchEffectOverlayState();
}

class _GlobalTouchEffectOverlayState extends State<GlobalTouchEffectOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  DateTime? _lastTime;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_onTick);

    GlobalTouchEffectController.instance._triggerNotifier.addListener(_onNewTouch);
  }

  void _onNewTouch() {
    if (!_controller.isAnimating) {
      _lastTime = DateTime.now();
      _controller.repeat();
    }
  }

  void _onTick() {
    final now = DateTime.now();
    final dt = _lastTime == null ? 0.016 : now.difference(_lastTime!).inMicroseconds / 1000000.0;
    _lastTime = now;

    final ripples = GlobalTouchEffectController.instance.activeRipples;
    for (int i = ripples.length - 1; i >= 0; i--) {
      ripples[i].update(dt);
      if (ripples[i].isFinished) {
        ripples.removeAt(i);
      }
    }

    if (ripples.isEmpty) {
      _controller.stop();
      _lastTime = null;
    }
    setState(() {});
  }

  @override
  void dispose() {
    GlobalTouchEffectController.instance._triggerNotifier.removeListener(_onNewTouch);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (GlobalTouchEffectController.instance.activeRipples.isEmpty) {
      return const SizedBox.shrink();
    }
    return IgnorePointer(
      child: CustomPaint(
        painter: _TouchEffectPainter(GlobalTouchEffectController.instance.activeRipples),
        size: Size.infinite,
      ),
    );
  }
}

class _TouchEffectPainter extends CustomPainter {
  final List<TouchRipple> ripples;
  _TouchEffectPainter(this.ripples);

  @override
  void paint(Canvas canvas, Size size) {
    final ringPaint = Paint()..style = PaintingStyle.stroke;
    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);

    for (final ripple in ripples) {
      final p = ripple.progress.clamp(0.0, 1.0);
      final easeOut = 1.0 - pow(1.0 - p, 2).toDouble();
      final fade = (1.0 - p).clamp(0.0, 1.0);

      // Subtle, Soft Outer Rosewood Ripple
      ringPaint.color = const Color(0xFF8C6D62).withValues(alpha: fade * 0.28);
      ringPaint.strokeWidth = 1.4 * fade;
      canvas.drawCircle(ripple.position, 6.0 + 16.0 * easeOut, ringPaint);

      // Delicate Inner Champagne Ripple
      ringPaint.color = const Color(0xFFD4A373).withValues(alpha: fade * 0.38);
      ringPaint.strokeWidth = 1.0 * fade;
      canvas.drawCircle(ripple.position, 3.0 + 9.0 * easeOut, ringPaint);

      // Tiny Soft Center Glow
      dotPaint.color = const Color(0xFFFDF7F0).withValues(alpha: fade * 0.45);
      canvas.drawCircle(ripple.position, 2.2 * fade, dotPaint);

      // 4 Gentle Floating Specks
      for (final particle in ripple.particles) {
        final dist = particle.speed * easeOut;
        final px = ripple.position.dx + cos(particle.angle) * dist;
        final py = ripple.position.dy + sin(particle.angle) * dist;
        
        dotPaint.color = const Color(0xFFE8C5A0).withValues(alpha: fade * 0.35);
        canvas.drawCircle(Offset(px, py), particle.size * fade, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TouchEffectPainter oldDelegate) => true;
}
