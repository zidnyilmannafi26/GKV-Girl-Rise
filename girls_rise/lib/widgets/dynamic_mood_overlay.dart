import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game_stats.dart';
import '../services/game_state_manager.dart';

class DynamicMoodOverlay extends StatefulWidget {
  const DynamicMoodOverlay({super.key});

  @override
  State<DynamicMoodOverlay> createState() => _DynamicMoodOverlayState();
}

class _DynamicMoodOverlayState extends State<DynamicMoodOverlay>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _particleController;

  late List<_SparkleParticle> _sparkleParticles;
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.4, end: 0.85).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );

    _sparkleParticles = List.generate(
      35,
      (_) => _SparkleParticle(_rnd, randomY: true),
    );

    _particleController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..addListener(() {
            for (final p in _sparkleParticles) {
              p.update(_rnd);
            }
          })
          ..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: GameStateManager.instance,
      builder: (context, _) {
        if (!GameStateManager.instance.isScenarioActive ||
            GameStateManager.instance.isEndingMode) {
          return const SizedBox.shrink();
        }

        final stats = GameStateManager.instance.stats;
        final mental = stats
            .firstWhere(
              (s) => s.type == StatType.mental,
              orElse: () => const StatItem(
                type: StatType.mental,
                value: 50,
                initialRank: 0,
              ),
            )
            .value;
        final pendidikan = stats
            .firstWhere(
              (s) => s.type == StatType.pendidikan,
              orElse: () => const StatItem(
                type: StatType.pendidikan,
                value: 50,
                initialRank: 0,
              ),
            )
            .value;

        // Condition 1: Critical Mental Health (<= 49) -> Melancholic Rain & Vignette
        if (mental <= 30) {
          return AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, _) {
              return IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.1,
                      colors: [
                        Colors.transparent,
                        const Color(
                          0xFF4A0E17,
                        ).withValues(alpha: 0.55 * _pulseAnimation.value),
                        const Color(
                          0xFF1A050A,
                        ).withValues(alpha: 0.85 * _pulseAnimation.value),
                      ],
                      stops: const [0.55, 0.85, 1.0],
                    ),
                  ),
                ),
              );
            },
          );
        }

        // Condition 2: Radiant Empowerment (Mental >= 80 && Pendidikan >= 80) -> Golden Sparkles
        if (mental >= 51 && pendidikan >= 51) {
          return AnimatedBuilder(
            animation: _particleController,
            builder: (context, _) {
              return IgnorePointer(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 1.15,
                          colors: [
                            Colors.transparent,
                            const Color(
                              0xFFF7D070,
                            ).withValues(alpha: 0.25 * _pulseAnimation.value),
                          ],
                          stops: const [0.7, 1.0],
                        ),
                      ),
                    ),
                    CustomPaint(
                      painter: _SparklePainter(_sparkleParticles),
                      size: Size.infinite,
                    ),
                  ],
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _SparkleParticle {
  late double x;
  late double y;
  late double size;
  late double phase;
  late double driftSpeed;

  _SparkleParticle(Random rnd, {bool randomY = false}) {
    reset(rnd, randomY: randomY);
  }

  void reset(Random rnd, {bool randomY = false}) {
    x = rnd.nextDouble();
    y = randomY ? rnd.nextDouble() : 1.1;
    size = 2.0 + rnd.nextDouble() * 3.5;
    phase = rnd.nextDouble() * pi * 2;
    driftSpeed = 0.002 + rnd.nextDouble() * 0.004;
  }

  void update(Random rnd) {
    y -= driftSpeed;
    phase += 0.1;
    if (y < -0.1) {
      reset(rnd, randomY: false);
    }
  }
}

class _SparklePainter extends CustomPainter {
  final List<_SparkleParticle> particles;
  _SparklePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      final alpha = (0.3 + 0.7 * sin(p.phase)).clamp(0.0, 1.0);
      paint.color = const Color(0xFFF7D070).withValues(alpha: alpha);
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SparklePainter oldDelegate) => true;
}
