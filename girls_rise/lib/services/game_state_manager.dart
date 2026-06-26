import 'package:flutter/foundation.dart';
import '../models/game_stats.dart';

class GameStateManager extends ChangeNotifier {
  static final GameStateManager instance = GameStateManager._internal();
  GameStateManager._internal() {
    reset();
  }

  int? activeScenarioId;

  late List<StatItem> _stats;
  List<StatItem> get stats => List.unmodifiable(_stats);

  // History stack for undoing when pressing BACK (Navigator.pop)
  final List<List<StatItem>> _historyStack = [];

  bool get isScenarioActive => activeScenarioId != null;
  bool isEndingMode = false;
  bool isPreviewingHistory = false;

  void setEndingMode(bool val) {
    isEndingMode = val;
    notifyListeners();
  }

  void startHistoryPreview(List<StatItem> previewStats) {
    isPreviewingHistory = true;
    isEndingMode = true;
    _stats = List.from(previewStats);
    notifyListeners();
  }

  void startScenario(int scenarioId) {
    activeScenarioId = scenarioId;
    reset();
  }

  void endScenario() {
    activeScenarioId = null;
    isPreviewingHistory = false;
    notifyListeners();
  }

  void resetScenario() {
    endScenario();
    reset();
  }

  void reset() {
    isPreviewingHistory = false;
    isEndingMode = false;
    _stats = [
      const StatItem(type: StatType.pendidikan, value: 50, initialRank: 0),
      const StatItem(type: StatType.ekonomi, value: 50, initialRank: 1),
      const StatItem(type: StatType.relasi, value: 50, initialRank: 2),
      const StatItem(type: StatType.mental, value: 50, initialRank: 3),
    ];
    _historyStack.clear();
    notifyListeners();
  }

  void applyDeltas(List<StatDelta> deltas) {
    // Push current snapshot to history
    _historyStack.add(List.from(_stats));

    // Calculate new values
    final Map<StatType, StatItem> currentMap = {
      for (var s in _stats) s.type: s
    };

    for (var d in deltas) {
      if (currentMap.containsKey(d.type)) {
        final oldItem = currentMap[d.type]!;
        currentMap[d.type] = oldItem.copyWith(value: oldItem.value + d.delta);
      }
    }

    final List<StatItem> updatedList = currentMap.values.toList();

    // Sort descending by value.
    // If ties, compare previous position index in _stats!
    updatedList.sort((a, b) {
      if (b.value != a.value) {
        return b.value.compareTo(a.value); // descending
      }
      // Tie breaking: maintain relative position from previous state
      final int rankA = _stats.indexWhere((item) => item.type == a.type);
      final int rankB = _stats.indexWhere((item) => item.type == b.type);
      return rankA.compareTo(rankB);
    });

    _stats = updatedList;
    notifyListeners();
  }

  void undo() {
    if (_historyStack.isNotEmpty) {
      _stats = _historyStack.removeLast();
      notifyListeners();
    }
  }
}
