import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game_stats.dart';
import '../services/game_state_manager.dart';
import 'game_parameter_bar.dart';

class GameStatsOverlay extends StatelessWidget {
  const GameStatsOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: GameStateManager.instance,
      builder: (context, _) {
        if (!GameStateManager.instance.isScenarioActive ||
            GameStateManager.instance.isEndingMode) {
          return const SizedBox.shrink();
        }

        final Size screenSize = MediaQuery.of(context).size;
        const double designWidth = 874.0;
        const double designHeight = 402.0;

        final double scaleX = screenSize.width / designWidth;
        final double scaleY = screenSize.height / designHeight;
        final double scale = min(scaleX, scaleY);

        final double activeCanvasWidth = designWidth * scale;
        final double activeCanvasHeight = designHeight * scale;
        final double offsetX = max(0.0, (screenSize.width - activeCanvasWidth) / 2);
        final double offsetY = max(0.0, (screenSize.height - activeCanvasHeight) / 2);

        final List<StatItem> stats = GameStateManager.instance.stats;
        final double itemHeight = 26.0 * scale;
        final double itemSpacing = 6.0 * scale;
        final double totalHeight = (stats.length * itemHeight) + ((stats.length - 1) * itemSpacing);
        final double itemWidth = 141.0 * scale;

        return Positioned(
          top: offsetY + 18.0 * scale,
          right: offsetX + 48.0 * scale,
          width: itemWidth,
          height: totalHeight,
          child: IgnorePointer(
            child: Stack(
              children: [
                for (int i = 0; i < stats.length; i++)
                  AnimatedPositioned(
                    key: ValueKey<StatType>(stats[i].type),
                    top: i * (itemHeight + itemSpacing),
                    right: 0,
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.easeInOutCubic,
                    child: GameParameterBar(
                      item: stats[i],
                      scale: scale,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
