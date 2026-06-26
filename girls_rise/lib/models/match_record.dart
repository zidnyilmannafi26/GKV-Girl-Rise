import 'game_stats.dart';

class MatchRecord {
  final int matchNumber;
  final int scenarioId;
  final String outcomeId;
  final List<StatItem> stats;
  final DateTime timestamp;

  const MatchRecord({
    required this.matchNumber,
    required this.scenarioId,
    required this.outcomeId,
    required this.stats,
    required this.timestamp,
  });

  bool get isNikahMuda =>
      outcomeId == 'outcome_nikahmuda' || outcomeId == 'outcome_nikahmuda2';

  Map<String, dynamic> toJson() {
    return {
      'matchNumber': matchNumber,
      'scenarioId': scenarioId,
      'outcomeId': outcomeId,
      'stats': stats
          .map((s) => {
                'type': s.type.name,
                'value': s.value,
                'initialRank': s.initialRank,
              })
          .toList(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory MatchRecord.fromJson(Map<String, dynamic> json) {
    final rawStats = (json['stats'] as List<dynamic>?) ?? [];
    final statList = rawStats.map((item) {
      final map = item as Map<String, dynamic>;
      final typeStr = map['type'] as String;
      final type = StatType.values.firstWhere(
        (e) => e.name == typeStr,
        orElse: () => StatType.mental,
      );
      return StatItem(
        type: type,
        value: (map['value'] as num).toInt(),
        initialRank: (map['initialRank'] as num?)?.toInt() ?? 0,
      );
    }).toList();

    return MatchRecord(
      matchNumber: (json['matchNumber'] as num).toInt(),
      scenarioId: (json['scenarioId'] as num).toInt(),
      outcomeId: json['outcomeId'] as String? ?? 'outcome_nikahmuda',
      stats: statList,
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
