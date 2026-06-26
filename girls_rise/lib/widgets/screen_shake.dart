import 'dart:math';
import 'package:flutter/material.dart';

class ScreenShake extends StatefulWidget {
  final Widget child;

  const ScreenShake({required this.child, super.key});

  static ScreenShakeState? of(BuildContext context) {
    return context.findAncestorStateOfType<ScreenShakeState>();
  }

  @override
  State<ScreenShake> createState() => ScreenShakeState();
}

class ScreenShakeState extends State<ScreenShake> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
  }

  void shake() {
    if (_controller.isAnimating) {
      _controller.reset();
    }
    _controller.forward(from: 0);
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
        if (!_controller.isAnimating) return child!;
        final progress = _controller.value;
        final intensity = (1.0 - progress) * 8.0; // max 8px offset
        final dx = (_rnd.nextDouble() * 2 - 1) * intensity;
        final dy = (_rnd.nextDouble() * 2 - 1) * intensity;
        return Transform.translate(
          offset: Offset(dx, dy),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
