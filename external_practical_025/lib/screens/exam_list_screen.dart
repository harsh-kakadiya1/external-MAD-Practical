import 'package:flutter/material.dart';
import '../models/exam.dart';
import '../widgets/exam_card.dart';
import '../utils/storage_helper.dart';

class ExamListScreen extends StatefulWidget {
  const ExamListScreen({super.key});

  @override
  State<ExamListScreen> createState() => _ExamListScreenState();
}

class _ExamListScreenState extends State<ExamListScreen> {
  List<Exam> exams = [];
  List<Exam> filteredExams = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExams();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadExams() async {
    final loadedExams = await StorageHelper.loadExams();
    setState(() {
      exams = loadedExams;
      exams.sort((a, b) => a.date.compareTo(b.date));
      filteredExams = exams;
      isLoading = false;
    });
  }

  void _filterExams(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredExams = exams;
      } else {
        filteredExams = exams.where((exam) {
          final courseCodeMatch =
              exam.courseCode.toLowerCase().contains(query.toLowerCase());
          final courseNameMatch =
              exam.courseName.toLowerCase().contains(query.toLowerCase());
          return courseCodeMatch || courseNameMatch;
        }).toList();
      }
    });
  }

  void _navigateToAddExam() async {
    final result = await Navigator.pushNamed(context, '/add-exam');
    if (result == true) {
      _loadExams();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text(
          'Exam Timetable',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              onChanged: _filterExams,
              decoration: InputDecoration(
                hintText: 'Search by course code or name',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[600]),
                        onPressed: () {
                          _searchController.clear();
                          _filterExams('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty && !isLoading && exams.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[200],
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.grey[700]),
                  const SizedBox(width: 8),
                  Text(
                    'Found ${filteredExams.length} result${filteredExams.length != 1 ? 's' : ''}',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  )
                : exams.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 80,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No exams scheduled',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap + to add your first exam',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : filteredExams.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 80,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No results found',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try a different search term',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredExams.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key: Key(filteredExams[index].id),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                onDismissed: (direction) async {
                                  final deletedExam = filteredExams[index];
                                  await StorageHelper.deleteExam(deletedExam.id);
                                  setState(() {
                                    exams.removeWhere((e) => e.id == deletedExam.id);
                                    filteredExams.removeAt(index);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${deletedExam.courseCode} deleted',
                                      ),
                                      backgroundColor: Colors.black,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: ExamCard(exam: filteredExams[index]),
                              );
                            },
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        elevation: 4,
        onPressed: _navigateToAddExam,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
