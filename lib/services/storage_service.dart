import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_progress.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String _progressKeyPrefix = 'blooket_progress_';
  static const String _totalFlagsKey = 'blooket_total_flags';
  static const String _streakKey = 'blooket_daily_streak';

  Future<WeekProgress> getProgress(String lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_progressKeyPrefix$lessonId');
    if (raw != null) {
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        return WeekProgress.fromJson(map);
      } catch (_) {}
    }
    return WeekProgress(lessonId: lessonId);
  }

  Future<void> saveProgress(WeekProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '$_progressKeyPrefix${progress.lessonId}',
      jsonEncode(progress.toJson()),
    );
  }

  Future<int> getTotalFlags() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_totalFlagsKey) ?? 0;
  }

  Future<void> addFlags(int count) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_totalFlagsKey) ?? 0;
    await prefs.setInt(_totalFlagsKey, current + count);
  }

  Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 1;
  }
}
