import 'package:flutter/material.dart';
import 'screens/exam_list_screen.dart';
import 'screens/add_exam_screen.dart';

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
    );
  }
}
