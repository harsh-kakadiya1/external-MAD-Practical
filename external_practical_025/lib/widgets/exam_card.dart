import 'package:flutter/material.dart';
import '../models/exam.dart';
import 'package:intl/intl.dart';

class ExamCard extends StatelessWidget {
  final Exam exam;
  final bool isNext;

  const ExamCard({super.key, required this.exam, this.isNext = false});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMM dd, yyyy').format(exam.date);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/exam-detail', arguments: exam);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isNext ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isNext ? Border.all(color: Colors.black, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isNext ? 0.15 : 0.05),
              blurRadius: isNext ? 15 : 10,
              offset: Offset(0, isNext ? 4 : 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          exam.courseCode,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isNext ? Colors.white : Colors.black,
                          ),
                        ),
                        if (isNext) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'NEXT',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (exam.documentPath != null)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isNext
                            ? Colors.white.withOpacity(0.2)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.attach_file,
                        size: 18,
                        color: isNext ? Colors.white : Colors.grey[700],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                exam.courseName,
                style: TextStyle(
                  fontSize: 14,
                  color: isNext
                      ? Colors.white.withOpacity(0.9)
                      : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: isNext
                        ? Colors.white.withOpacity(0.8)
                        : Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 14,
                      color: isNext
                          ? Colors.white.withOpacity(0.9)
                          : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: isNext
                        ? Colors.white.withOpacity(0.8)
                        : Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    exam.time,
                    style: TextStyle(
                      fontSize: 14,
                      color: isNext
                          ? Colors.white.withOpacity(0.9)
                          : Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: isNext
                        ? Colors.white.withOpacity(0.8)
                        : Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      exam.venue,
                      style: TextStyle(
                        fontSize: 14,
                        color: isNext
                            ? Colors.white.withOpacity(0.9)
                            : Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
