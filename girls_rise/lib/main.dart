import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'widgets/game_stats_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Enforce landscape orientation and enable fullscreen immersive mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky).then((_) {
    runApp(const GirlRiseApp());
  });
}

class GirlRiseApp extends StatelessWidget {
  const GirlRiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Girl Rise',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              if (child != null) child,
              const GameStatsOverlay(),
            ],
          ),
        );
      },
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
