import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'services/audio_service.dart';
import 'widgets/atmospheric_particles.dart';
import 'widgets/dynamic_mood_overlay.dart';
import 'widgets/game_qol_overlay.dart';
import 'widgets/game_stats_overlay.dart';
import 'widgets/global_front_dialog.dart';
import 'widgets/global_touch_effect.dart';
import 'widgets/screen_shake.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AudioService.instance.init();

  // Enforce landscape orientation and enable fullscreen immersive mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const GirlRiseApp());
}

final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();

class GirlRiseApp extends StatelessWidget {
  const GirlRiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globalNavigatorKey,
      title: 'Girl Rise',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return ScreenShake(
          child: Material(
            type: MaterialType.transparency,
            child: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (event) {
                GlobalTouchEffectController.instance.triggerEffect(event.position);
              },
              child: Stack(
                children: [
                  KenBurnsCamera(child: child!),
                  const Positioned.fill(
                    child: IgnorePointer(
                      child: AtmosphericParticles(),
                    ),
                  ),
                  const Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              Colors.transparent,
                              Color(0x4D000000), // AAA dark console border framing
                            ],
                            radius: 1.15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Positioned.fill(
                    child: DynamicMoodOverlay(),
                  ),
                  const GameStatsOverlay(),
                  const GameQolOverlay(),
                  const GlobalFrontOverlay(),
                  const GlobalTouchEffectOverlay(),
                ],
              ),
            ),
          ),
        );
      },
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class KenBurnsCamera extends StatefulWidget {
  final Widget child;
  const KenBurnsCamera({required this.child, super.key});

  @override
  State<KenBurnsCamera> createState() => _KenBurnsCameraState();
}

class _KenBurnsCameraState extends State<KenBurnsCamera>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.022).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
