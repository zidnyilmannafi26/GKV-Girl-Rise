import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_stats.dart';
import '../models/match_record.dart';
import 'audio_service.dart';

class HistoryService {
  static final HistoryService instance = HistoryService._internal();
  HistoryService._internal();

  static const String _storageKey = 'girls_rise_match_history';

  Future<List<MatchRecord>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_storageKey);
    if (jsonStr == null || jsonStr.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(jsonStr) as List<dynamic>;
      return decoded
          .map((item) => MatchRecord.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> recordMatch({
    required int scenarioId,
    required String outcomeId,
    required List<StatItem> stats,
  }) async {
    AudioService.instance.playOutcomeChimeSfx();
    final history = await getHistory();
    final int newMatchNo = history.isEmpty ? 1 : history.last.matchNumber + 1;

    final newRecord = MatchRecord(
      matchNumber: newMatchNo,
      scenarioId: scenarioId,
      outcomeId: outcomeId,
      stats: stats,
      timestamp: DateTime.now(),
    );

    history.add(newRecord);

    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(history.map((r) => r.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
