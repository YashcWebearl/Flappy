import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _bestScoreKey = 'best_score';

  static Future<void> saveBestScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    int bestScore = await getBestScore();

    if (score > bestScore) {
      await prefs.setInt(_bestScoreKey, score);
    }
  }

  static Future<int> getBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_bestScoreKey) ?? 0;
  }
}
