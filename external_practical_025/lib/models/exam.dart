/// Model class representing an exam entry in the timetable
class Exam {
  String id;
  String courseCode;
  String courseName;
  DateTime date;
  String time;
  String venue;
  String? documentPath; // Optional path to attached document

  Exam({
    required this.id,
    required this.courseCode,
    required this.courseName,
    required this.date,
    required this.time,
    required this.venue,
    this.documentPath,
  });

  /// Convert exam to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseCode': courseCode,
      'courseName': courseName,
      'date': date.toIso8601String(),
      'time': time,
      'venue': venue,
      'documentPath': documentPath,
    };
  }

  /// Create exam from JSON data
  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'],
      courseCode: json['courseCode'],
      courseName: json['courseName'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      venue: json['venue'],
      documentPath: json['documentPath'],
    );
  }
}
