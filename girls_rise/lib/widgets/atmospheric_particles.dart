import 'dart:math';
import 'package:flutter/material.dart';

class AtmosphericParticles extends StatefulWidget {
  final int particleCount;

  const AtmosphericParticles({
    this.particleCount = 28,
    super.key,
  });

  @override
  State<AtmosphericParticles> createState() => _AtmosphericParticlesState();
}

class _AtmosphericParticlesState extends State<AtmosphericParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_AtmosphericParticle> _particles;
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    _particles = List.generate(
      widget.particleCount,
      (_) => _AtmosphericParticle(rnd: _rnd, randomY: true),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        for (final p in _particles) {
          p.update();
        }
      })
      ..repeat();
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
      builder: (context, _) {
        return CustomPaint(
          painter: _AtmosphericParticlePainter(particles: _particles),
          size: Size.infinite,
        );
      },
    );
  }
}

class _AtmosphericParticle {
  late double x;
  late double y;
  late double speed;
  late double horizontalDriftSpeed;
  late double horizontalAmplitude;
  late double size;
  late double maxOpacity;
  late double phase;
  late Color color;

  _AtmosphericParticle({required Random rnd, bool randomY = false}) {
    reset(rnd, randomY: randomY);
  }

  void reset(Random rnd, {bool randomY = false}) {
    x = rnd.nextDouble();
    y = randomY ? rnd.nextDouble() : 1.05;
    speed = 0.0006 + rnd.nextDouble() * 0.0012; // slow drift upward
    horizontalDriftSpeed = 0.02 + rnd.nextDouble() * 0.04;
    horizontalAmplitude = 0.001 + rnd.nextDouble() * 0.002;
    size = 1.0 + rnd.nextDouble() * 2.2;
    maxOpacity = 0.12 + rnd.nextDouble() * 0.32;
    phase = rnd.nextDouble() * pi * 2;

    const colors = [
      Color(0xFFFFFDF5), // warm soft white
      Color(0xFFFFEECC), // soft sunlight gold
      Color(0xFFFFD54F), // golden mote
      Color(0xFFFBE9E7), // rose mote
    ];
    color = colors[rnd.nextInt(colors.length)];
  }

  void update() {
    y -= speed;
    phase += horizontalDriftSpeed;
    x += sin(phase) * horizontalAmplitude;

    if (y < -0.05) {
      reset(Random(), randomY: false);
    }
  }
}

class _AtmosphericParticlePainter extends CustomPainter {
  final List<_AtmosphericParticle> particles;

  _AtmosphericParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      final double px = p.x * size.width;
      final double py = p.y * size.height;

      // Soft fading near top and bottom edges
      double edgeFade = 1.0;
      if (p.y < 0.15) {
        edgeFade = p.y / 0.15;
      } else if (p.y > 0.85) {
        edgeFade = (1.0 - p.y) / 0.15;
      }
      edgeFade = edgeFade.clamp(0.0, 1.0);

      // Pulse glow opacity
      final double currentOpacity = (p.maxOpacity * edgeFade * (0.7 + 0.3 * sin(p.phase))).clamp(0.0, 1.0);

      paint.color = p.color.withValues(alpha: currentOpacity);

      // Add a dreamy blur to larger motes
      if (p.size > 2.0) {
        paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.8);
      } else {
        paint.maskFilter = null;
      }

      canvas.drawCircle(Offset(px, py), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _AtmosphericParticlePainter oldDelegate) => true;
}
