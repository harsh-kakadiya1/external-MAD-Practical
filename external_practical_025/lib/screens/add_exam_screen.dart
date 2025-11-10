import 'package:flutter/material.dart';

class AddExamScreen extends StatefulWidget {
  const AddExamScreen({super.key});

  @override
  State<AddExamScreen> createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamScreen> {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildSectionTitle('Course Details'),
              const SizedBox(height: 16),
              _buildInputField('Course Code', 'e.g., CS301'),
              const SizedBox(height: 16),
              _buildInputField('Course Name', 'e.g., Database Management'),
              const SizedBox(height: 24),
              _buildSectionTitle('Exam Schedule'),
              const SizedBox(height: 16),
              _buildDateField('Date'),
              const SizedBox(height: 16),
              _buildTimeField('Time'),
              const SizedBox(height: 24),
              _buildSectionTitle('Venue'),
              const SizedBox(height: 16),
              _buildInputField('Venue', 'e.g., Hall A, Room 203'),
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

  Widget _buildInputField(String label, String hint) {
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
      child: TextField(
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

  Widget _buildDateField(String label) {
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
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Select date',
          labelStyle: TextStyle(color: Colors.grey[700]),
          hintStyle: TextStyle(color: Colors.grey[400]),
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

  Widget _buildTimeField(String label) {
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
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Select time',
          labelStyle: TextStyle(color: Colors.grey[700]),
          hintStyle: TextStyle(color: Colors.grey[400]),
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
    return Container(
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
          Icon(Icons.attach_file, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Upload Document',
              style: TextStyle(color: Colors.grey[700], fontSize: 15),
            ),
          ),
          Icon(Icons.cloud_upload_outlined, color: Colors.grey[600]),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {},
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
