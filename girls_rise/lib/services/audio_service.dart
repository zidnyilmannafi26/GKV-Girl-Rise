import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService extends ChangeNotifier {
  static final AudioService instance = AudioService._internal();
  AudioService._internal();

  AudioPlayer? _bgmPlayer;
  AudioPlayer? _sfxPlayer;

  bool _isMuted = false;
  bool get isMuted => _isMuted;

  bool _isInitialized = false;
  bool _suppressTransition = false;

  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;

    try {
      _bgmPlayer = AudioPlayer();
      _sfxPlayer = AudioPlayer();

      final prefs = await SharedPreferences.getInstance();
      _isMuted = prefs.getBool('audio_muted') ?? false;

      // Konfigurasi pemutaran looping untuk BGM
      await _bgmPlayer!.setReleaseMode(ReleaseMode.loop);
      await _sfxPlayer!.setReleaseMode(ReleaseMode.stop);

      if (!_isMuted) {
        startBgm();
      }
    } catch (e) {
      debugPrint('Error initializing AudioService: $e');
    }
  }

  Future<void> startBgm() async {
    if (_isMuted || _bgmPlayer == null) return;
    try {
      if (_bgmPlayer!.state != PlayerState.playing) {
        await _bgmPlayer!.play(AssetSource('audio/lofi_bgm.wav'), volume: 0.45);
      }
    } catch (e) {
      debugPrint('Error playing BGM: $e');
    }
  }

  Future<void> playTransitionSfx() async {
    if (!_suppressTransition) {
      HapticFeedback.lightImpact();
    }
    if (_suppressTransition || _isMuted || _sfxPlayer == null) return;
    try {
      await _sfxPlayer!.stop();
      await _sfxPlayer!.play(AssetSource('audio/transition_sfx.wav'), volume: 0.65);
    } catch (e) {
      debugPrint('Error playing transition SFX: $e');
    }
  }

  Future<void> playImportantClickSfx() async {
    HapticFeedback.mediumImpact();
    _suppressTransition = true;
    Future.delayed(const Duration(milliseconds: 450), () {
      _suppressTransition = false;
    });
    if (_isMuted || _sfxPlayer == null) return;
    try {
      await _sfxPlayer!.stop();
      await _sfxPlayer!.play(AssetSource('audio/important_click.wav'), volume: 0.85);
    } catch (e) {
      debugPrint('Error playing important click SFX: $e');
    }
  }

  Future<void> playOutcomeChimeSfx() async {
    HapticFeedback.heavyImpact();
    if (_isMuted || _sfxPlayer == null) return;
    try {
      await _sfxPlayer!.stop();
      await _sfxPlayer!.play(AssetSource('audio/outcome_chime.wav'), volume: 0.9);
    } catch (e) {
      debugPrint('Error playing outcome chime SFX: $e');
    }
  }

  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    notifyListeners();

    playImportantClickSfx();

    if (_bgmPlayer == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('audio_muted', _isMuted);

      if (_isMuted) {
        await _bgmPlayer!.pause();
      } else {
        if (_bgmPlayer!.state == PlayerState.paused) {
          await _bgmPlayer!.resume();
        } else {
          startBgm();
        }
      }
    } catch (e) {
      debugPrint('Error toggling audio mute: $e');
    }
  }
}
