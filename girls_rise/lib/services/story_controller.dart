import 'package:flutter/services.dart';
import 'audio_service.dart';

class StoryController {
  static final StoryController instance = StoryController._internal();
  StoryController._internal();

  VoidCallback? _skipCallback;
  bool _isTyping = false;

  bool get isTyping => _isTyping;

  void startTyping(VoidCallback onSkip) {
    _isTyping = true;
    _skipCallback = onSkip;
  }

  void finishTyping() {
    _isTyping = false;
    _skipCallback = null;
  }

  bool interceptTap() {
    if (_isTyping && _skipCallback != null) {
      HapticFeedback.selectionClick();
      _skipCallback!();
      return true;
    }
    AudioService.instance.playTransitionSfx();
    return false;
  }
}
