import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _bestScoreKey = 'best_score';
  static const String _profileNameKey = 'profile_name';

  // static const String _bestScoreKey = 'best_score';

  static Future<void> saveBestScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    int bestScore = await getBestScore();

    if (score > bestScore) {
      await prefs.setInt(_bestScoreKey, score);
      print("Best score updated to: $score");
    }
  }

  static Future<int> getBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_bestScoreKey) ?? 0;
  }

  // Save profile name
  static Future<void> saveProfileName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileNameKey, name);
  }

  // Retrieve profile name
  static Future<String> getProfileName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profileNameKey) ?? "My Profile"; // Default value
  }
}




// import 'package:shared_preferences/shared_preferences.dart';
//
// class LocalStorage {
//   static const String _bestScoreKey = 'best_score';
//
//   static Future<void> saveBestScore(int score) async {
//     final prefs = await SharedPreferences.getInstance();
//     int bestScore = await getBestScore();
//
//     if (score > bestScore) {
//       await prefs.setInt(_bestScoreKey, score);
//     }
//   }
//
//   static Future<int> getBestScore() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getInt(_bestScoreKey) ?? 0;
//   }
// }
