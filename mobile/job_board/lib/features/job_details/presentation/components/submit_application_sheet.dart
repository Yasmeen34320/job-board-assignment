import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:job_board/features/job_applications/data/models/application_model.dart';
import 'package:job_board/features/job_applications/presentation/cubit/application_cubit.dart';

class SubmitApplicationSheet extends StatefulWidget {
  final String jobId;
  final String userId;
  final BuildContext scaffoldContext;

  const SubmitApplicationSheet({
    Key? key,
    required this.jobId,
    required this.userId,
    required this.scaffoldContext,
  }) : super(key: key);

  @override
  State<SubmitApplicationSheet> createState() => _SubmitApplicationSheetState();
}

class _SubmitApplicationSheetState extends State<SubmitApplicationSheet> {
  final TextEditingController _coverLetterController = TextEditingController();
  File? _selectedResume;

  Future<void> _pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        _selectedResume = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(16)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Apply for Job',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
                color: Color(0xFF4F4AD3),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickResume,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade500,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              icon: _selectedResume == null
                  ? Icon(Icons.attach_file, color: Colors.black87)
                  : Icon(Icons.check, color: Colors.black87),
              label: Text(
                _selectedResume == null
                    ? 'Select Resume (PDF)'
                    : 'Resume Selected',
                style: GoogleFonts.poppins(
                  // fontSize: 16,
                  letterSpacing: 1.2,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _coverLetterController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Cover Letter',
                focusColor: Color(0xFF4F4AD3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (_selectedResume == null ||
                      _coverLetterController.text.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Please fill all fields!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Color(0xFF4F4AD3).withOpacity(0.8),
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    return;
                  }

                  await context.read<ApplicationCubit>().submitApplication(
                    jobId: widget.jobId,
                    userId: widget.userId,
                    resumeFile: _selectedResume!,
                    coverLetter: _coverLetterController.text,
                  );

                  final box = await Hive.openBox<ApplicationModel>(
                    'applications',
                  );
                  print('Application submitted: ${box.values.last}');

                  if (mounted) Navigator.pop(context);
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text('Application submitted!')),
                  // );
                } catch (e, stack) {
                  print('Submit error: $e');
                  print(stack);
                  Fluttertoast.showToast(
                    msg: "Something went wrong!",
                    backgroundColor: Colors.red,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4F4AD3),
              ),
              child: Text(
                'Submit Application',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
