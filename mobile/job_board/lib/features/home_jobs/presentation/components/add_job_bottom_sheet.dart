import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:job_board/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:job_board/features/home_jobs/data/models/job_model.dart';
import 'package:job_board/features/home_jobs/presentation/cubit/job_cubit.dart';

void showAddJobSheet(BuildContext context, Job? job) {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _salaryController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _requirementsController = TextEditingController();
  var status = job == null ? 'open' : job.status;
  if (job != null) {
    _titleController.text = job.title;
    _descriptionController.text = job.description;
    _locationController.text = job.location;
    _salaryController.text = job.salary.toString();
    _imageUrlController.text = job.imageUrl;
    _companyNameController.text = job.companyName;
    _requirementsController.text = job.requirements.join(', ');
  }

  TextEditingController _statusController = TextEditingController(text: status);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Center(
              child: Text(
                "Add New Job",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            _buildInputField(context, "Job Title", _titleController),
            _buildInputField(
              context,
              "Description",
              _descriptionController,
              maxLines: 3,
            ),
            _buildInputField(context, "Location", _locationController),
            _buildInputField(
              context,
              "Salary",
              _salaryController,
              keyboardType: TextInputType.number,
            ),
            _buildInputField(context, "Image URL", _imageUrlController),
            _buildInputField(context, "Company Name", _companyNameController),
            _buildInputField(
              context,
              "Requirements (comma separated)",
              _requirementsController,
            ),
            job != null
                ? _buildInputField(context, "Status", _statusController)
                : const SizedBox.shrink(),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  status = _statusController.text.trim();
                  if (status.isEmpty ||
                      (status != 'open' && status != 'closed')) {
                    Fluttertoast.showToast(
                      msg:
                          'Status is Invalid, it must be either open or closed',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Color(0xFF4F4AD3).withOpacity(0.8),
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    return;
                  }
                  final job1 = Job(
                    createdAt: job == null ? DateTime.now() : job.createdAt,
                    id: job == null
                        ? DateTime.now().millisecondsSinceEpoch.toString()
                        : job.id,
                    title: _titleController.text.trim(),
                    description: _descriptionController.text.trim(),
                    location: _locationController.text.trim(),
                    salary:
                        double.tryParse(_salaryController.text.trim()) ?? 0.0,
                    status: job == null ? 'open' : status,
                    createdBy:
                        context.read<AuthCubit>().currentUser?.fullName ?? "",
                    imageUrl: _imageUrlController.text.trim(),
                    companyName: _companyNameController.text.trim(),
                    requirements: _requirementsController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList(),
                  );
                  if (job != null) {
                    context.read<JobCubit>().updateJob(job.id, job1);
                  } else {
                    context.read<JobCubit>().addJob(job1);
                  }
                  context.read<JobCubit>().loadJobs();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.check),
                label: const Text(
                  "Submit Job",
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFF4F4AD3),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildInputField(
  BuildContext context,
  String label,
  TextEditingController controller, {
  int maxLines = 1,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    ),
  );
}
