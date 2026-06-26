import 'package:flutter/material.dart';
import '../services/audio_service.dart';

class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadePageRoute({required this.page})
      : super(
          opaque: false,
          pageBuilder: (context, animation, secondaryAnimation) {
            AudioService.instance.playTransitionSfx();
            return page;
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
        );
}
