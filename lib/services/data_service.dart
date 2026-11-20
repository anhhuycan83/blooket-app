import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/curriculum.dart';
import '../models/lesson.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  // Phase 2: Live Backend Domain via Cloudflare Tunnel
  String? baseUrl = 'https://blooket-api.huypham.io.vn';

  Future<List<GradeItem>> getCurriculumTree() async {
    // 1. Try remote API first if baseUrl is set
    if (baseUrl != null && baseUrl!.isNotEmpty) {
      try {
        final url = Uri.parse('$baseUrl/api/v1/curriculum/tree');
        final response = await http.get(url).timeout(const Duration(seconds: 5));
        if (response.statusCode == 200) {
          final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
          final grades = (data['grades'] as List<dynamic>)
              .map((e) => GradeItem.fromJson(e as Map<String, dynamic>))
              .toList();
          return grades;
        }
      } catch (e) {
        debugPrint('Remote API getCurriculumTree error (fallback to local): $e');
      }
    }

    // 2. Fallback to local bundled assets
    try {
      final jsonString = await rootBundle.loadString('assets/data/curriculum_tree.json');
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      final grades = (data['grades'] as List<dynamic>)
          .map((e) => GradeItem.fromJson(e as Map<String, dynamic>))
          .toList();
      return grades;
    } catch (e) {
      throw Exception('Failed to load curriculum tree: $e');
    }
  }

  Future<LessonData> getLesson({
    required int grade,
    required String subject,
    required int week,
  }) async {
    // 1. Try remote API first if baseUrl is set
    if (baseUrl != null && baseUrl!.isNotEmpty) {
      try {
        final url = Uri.parse('$baseUrl/api/v1/lessons?grade=$grade&subject=$subject&week=$week');
        final response = await http.get(url).timeout(const Duration(seconds: 5));
        if (response.statusCode == 200) {
          final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
          return LessonData.fromJson(data);
        }
      } catch (e) {
        debugPrint('Remote API getLesson error (fallback to local): $e');
      }
    }

    // 2. Fallback to local bundled assets
    final assetPath = 'assets/data/g${grade}_${subject}_w$week.json';
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      return LessonData.fromJson(data);
    } catch (e) {
      return LessonData(
        id: 'g${grade}_${subject}_w$week',
        grade: grade,
        subject: subject,
        subjectName: subject.toUpperCase(),
        week: week,
        title: 'Tuần $week: Bài học chưa có dữ liệu',
        subTitle: 'Đang cập nhật nội dung cho tuần này',
        theoryCards: [],
        exercises: [],
      );
    }
  }
}
