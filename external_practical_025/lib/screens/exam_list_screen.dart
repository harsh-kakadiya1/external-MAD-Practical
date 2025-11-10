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
  // State variables
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

  // Data management methods
  Future<void> _loadExams() async {
    final loadedExams = await StorageHelper.loadExams();
    setState(() {
      exams = loadedExams;
      exams.sort((a, b) => a.date.compareTo(b.date)); // Sort by date
      filteredExams = exams;
      isLoading = false;
    });
  }

  void _filterExams(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredExams = exams;
      } else {
        // Filter by course code or name
        filteredExams = exams.where((exam) {
          final courseCodeMatch = exam.courseCode.toLowerCase().contains(
            query.toLowerCase(),
          );
          final courseNameMatch = exam.courseName.toLowerCase().contains(
            query.toLowerCase(),
          );
          return courseCodeMatch || courseNameMatch;
        }).toList();
      }
    });
  }

  // Navigation
  void _navigateToAddExam() async {
    final result = await Navigator.pushNamed(context, '/add-exam');
    if (result == true) {
      _loadExams();
    }
  }

  // Helper methods
  Exam? _getNextExam() {
    final now = DateTime.now();
    final upcomingExams = exams.where((exam) {
      return exam.date.isAfter(now) ||
          (exam.date.year == now.year &&
              exam.date.month == now.month &&
              exam.date.day == now.day);
    }).toList();

    if (upcomingExams.isEmpty) return null;
    return upcomingExams.first;
  }

  int _getDaysUntilExam(DateTime examDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final exam = DateTime(examDate.year, examDate.month, examDate.day);
    return exam.difference(today).inDays;
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
          if (!isLoading && exams.isNotEmpty && _getNextExam() != null)
            _buildCountdownBanner(_getNextExam()!),
          if (_searchController.text.isNotEmpty &&
              !isLoading &&
              exams.isNotEmpty)
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
                      final currentExam = filteredExams[index];
                      final nextExam = _getNextExam();
                      final isNextExam =
                          nextExam != null && currentExam.id == nextExam.id;

                      return Dismissible(
                        key: Key(currentExam.id),
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
                          final deletedExam = currentExam;
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
                        child: ExamCard(exam: currentExam, isNext: isNextExam),
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

  Widget _buildCountdownBanner(Exam nextExam) {
    final daysUntil = _getDaysUntilExam(nextExam.date);
    String countdownText;

    if (daysUntil == 0) {
      countdownText = 'Today';
    } else if (daysUntil == 1) {
      countdownText = 'Tomorrow';
    } else {
      countdownText = 'in $daysUntil days';
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.black, Color(0xFF424242)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.notifications_active,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next Exam $countdownText',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${nextExam.courseCode} - ${nextExam.courseName}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
