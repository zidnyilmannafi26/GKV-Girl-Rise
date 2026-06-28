import 'dart:async';
import 'package:flutter/material.dart';

class GlobalFrontDialogController {
  static final ValueNotifier<Widget?> currentDialog = ValueNotifier<Widget?>(null);

  static Future<T?> show<T>({
    required Widget Function(void Function([T?])) builder,
    bool barrierDismissible = true,
  }) {
    final completer = Completer<T?>();

    void close([T? result]) {
      if (currentDialog.value != null) {
        currentDialog.value = null;
        if (!completer.isCompleted) {
          completer.complete(result);
        }
      }
    }

    currentDialog.value = Stack(
      children: [
        // Full-screen dark semi-transparent barrier covering all overlays & game layers
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (barrierDismissible) {
                close(null);
              }
            },
            child: Container(
              color: Colors.black.withValues(alpha: 0.65),
            ),
          ),
        ),
        // Dialog Content centered at the very front
        Center(
          child: Material(
            type: MaterialType.transparency,
            child: builder(close),
          ),
        ),
      ],
    );

    return completer.future;
  }

  static void closeCurrent() {
    currentDialog.value = null;
  }
}

class GlobalFrontOverlay extends StatelessWidget {
  const GlobalFrontOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Widget?>(
      valueListenable: GlobalFrontDialogController.currentDialog,
      builder: (context, dialog, child) {
        if (dialog == null) return const SizedBox.shrink();
        return Positioned.fill(child: dialog);
      },
    );
  }
}
