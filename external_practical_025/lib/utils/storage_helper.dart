import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exam.dart';

/// Helper class for managing exam data persistence using SharedPreferences
class StorageHelper {
  static const String _examsKey = 'exams';

  /// Save list of exams to local storage
  static Future<void> saveExams(List<Exam> exams) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> examStrings = exams.map((exam) {
      return json.encode(exam.toJson());
    }).toList();
    await prefs.setStringList(_examsKey, examStrings);
  }

  /// Load all exams from local storage
  static Future<List<Exam>> loadExams() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? examStrings = prefs.getStringList(_examsKey);

    if (examStrings == null || examStrings.isEmpty) {
      return [];
    }

    return examStrings.map((examString) {
      final Map<String, dynamic> examJson = json.decode(examString);
      return Exam.fromJson(examJson);
    }).toList();
  }

  /// Add a new exam to storage
  static Future<void> addExam(Exam exam) async {
    final exams = await loadExams();
    exams.add(exam);
    await saveExams(exams);
  }

  /// Delete an exam by ID
  static Future<void> deleteExam(String id) async {
    final exams = await loadExams();
    exams.removeWhere((exam) => exam.id == id);
    await saveExams(exams);
  }

  /// Clear all exams from storage
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_examsKey);
  }
}
