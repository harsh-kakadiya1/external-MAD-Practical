import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/exam.dart';
import '../utils/storage_helper.dart';

class AddExamScreen extends StatefulWidget {
  const AddExamScreen({super.key});

  @override
  State<AddExamScreen> createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamScreen> {
  // Form key and controllers
  final _formKey = GlobalKey<FormState>();
  final _courseCodeController = TextEditingController();
  final _courseNameController = TextEditingController();
  final _venueController = TextEditingController();

  // State variables
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _documentPath;

  @override
  void dispose() {
    _courseCodeController.dispose();
    _courseNameController.dispose();
    _venueController.dispose();
    super.dispose();
  }

  // Date and time picker methods
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Document picker with error handling
  Future<void> _pickDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles();

      if (result != null &&
          result.files.isNotEmpty &&
          result.files.first.path != null) {
        final pickedFile = result.files.first;
        final file = File(pickedFile.path!);

        if (await file.exists()) {
          // Save file to app directory
          final appDir = await getApplicationDocumentsDirectory();
          final fileName = pickedFile.name;
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final newFileName = '${timestamp}_$fileName';
          final newPath = '${appDir.path}/$newFileName';

          final savedFile = await file.copy(newPath);

          setState(() {
            _documentPath = savedFile.path;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✓ Document "$fileName" selected'),
                backgroundColor: Colors.green[700],
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      }
    } on Exception {
      // If file picker fails, offer manual path entry
      if (mounted) {
        _showManualPathDialog();
      }
    } catch (e) {
      if (mounted) {
        _showManualPathDialog();
      }
    }
  }

  void _showManualPathDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('File Picker Issue'),
          content: const Text(
            'The file picker is having issues. Would you like to:\n\n'
            '1. Skip document upload (you can add it later)\n'
            '2. Try again',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Skip'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _pickDocument();
              },
              child: const Text('Try Again'),
            ),
          ],
        );
      },
    );
  }

  void _saveExam() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select exam date'),
            backgroundColor: Colors.black,
          ),
        );
        return;
      }

      if (_selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select exam time'),
            backgroundColor: Colors.black,
          ),
        );
        return;
      }

      final newExam = Exam(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        courseCode: _courseCodeController.text.trim(),
        courseName: _courseNameController.text.trim(),
        date: _selectedDate!,
        time: _selectedTime!.format(context),
        venue: _venueController.text.trim(),
        documentPath: _documentPath,
      );

      await StorageHelper.addExam(newExam);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exam saved successfully!'),
            backgroundColor: Colors.black,
          ),
        );

        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Add Exam',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildSectionTitle('Course Details'),
                const SizedBox(height: 16),
                _buildInputField(
                  'Course Code',
                  'e.g., CS301',
                  _courseCodeController,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  'Course Name',
                  'e.g., Database Management',
                  _courseNameController,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Exam Schedule'),
                const SizedBox(height: 16),
                _buildDateField(),
                const SizedBox(height: 16),
                _buildTimeField(),
                const SizedBox(height: 24),
                _buildSectionTitle('Venue'),
                const SizedBox(height: 16),
                _buildInputField(
                  'Venue',
                  'e.g., Hall A, Room 203',
                  _venueController,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Documents'),
                const SizedBox(height: 16),
                _buildDocumentUpload(),
                const SizedBox(height: 32),
                _buildSaveButton(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(color: Colors.grey[700]),
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        readOnly: true,
        onTap: _selectDate,
        decoration: InputDecoration(
          labelText: 'Date',
          hintText: _selectedDate == null
              ? 'Select date'
              : DateFormat('MMM dd, yyyy').format(_selectedDate!),
          labelStyle: TextStyle(color: Colors.grey[700]),
          hintStyle: TextStyle(
            color: _selectedDate == null ? Colors.grey[400] : Colors.black87,
          ),
          suffixIcon: Icon(Icons.calendar_today, color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        readOnly: true,
        onTap: _selectTime,
        decoration: InputDecoration(
          labelText: 'Time',
          hintText: _selectedTime == null
              ? 'Select time'
              : _selectedTime!.format(context),
          labelStyle: TextStyle(color: Colors.grey[700]),
          hintStyle: TextStyle(
            color: _selectedTime == null ? Colors.grey[400] : Colors.black87,
          ),
          suffixIcon: Icon(Icons.access_time, color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentUpload() {
    String displayText = 'Upload Document (Optional)';
    if (_documentPath != null) {
      final fileName = _documentPath!.split('/').last;
      displayText = fileName;
    }

    return GestureDetector(
      onTap: _pickDocument,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              _documentPath == null ? Icons.attach_file : Icons.check_circle,
              color: _documentPath == null ? Colors.grey[600] : Colors.black,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                displayText,
                style: TextStyle(
                  color: _documentPath == null
                      ? Colors.grey[700]
                      : Colors.black,
                  fontSize: 15,
                  fontWeight: _documentPath == null
                      ? FontWeight.normal
                      : FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.cloud_upload_outlined, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _saveExam,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Save Exam',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
