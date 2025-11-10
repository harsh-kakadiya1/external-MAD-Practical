import 'package:flutter/material.dart';
import 'screens/exam_list_screen.dart';
import 'screens/add_exam_screen.dart';
import 'screens/exam_detail_screen.dart';
import 'models/exam.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exam Timetable',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const ExamListScreen(),
      routes: {'/add-exam': (context) => const AddExamScreen()},
      onGenerateRoute: (settings) {
        if (settings.name == '/exam-detail') {
          final exam = settings.arguments as Exam;
          return MaterialPageRoute(
            builder: (context) => ExamDetailScreen(exam: exam),
          );
        }
        return null;
      },
    );
  }
}
