import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'services/audio_service.dart';
import 'widgets/game_stats_overlay.dart';
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
        return ScreenShake(
          child: Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                child!,
                const GameStatsOverlay(),
              ],
            ),
          ),
        );
      },
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
