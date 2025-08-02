import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:job_board/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:job_board/features/home_jobs/data/models/job_model.dart';
import 'package:job_board/features/home_jobs/presentation/components/build_dropDown.dart';
import 'package:job_board/features/home_jobs/presentation/components/build_input_field.dart';
import 'package:job_board/features/home_jobs/presentation/cubit/job_cubit.dart';

void showAddJobSheet(BuildContext context, Job? job) {
  final _formKey = GlobalKey<FormState>();
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
        child: Form(
          key: _formKey,
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
                  job == null ? "Add New Job" : "Edit Job",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              buildInputField(
                label: "Job Title",
                controller: _titleController,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Title is required'
                    : null,
              ),
              buildInputField(
                label: "Description",
                controller: _descriptionController,
                maxLines: 3,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Description is required'
                    : null,
              ),
              buildInputField(
                label: "Location",
                controller: _locationController,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Location is required'
                    : null,
              ),
              buildInputField(
                label: "Salary",
                controller: _salaryController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Salary is required';
                  }
                  final salary = double.tryParse(value);
                  if (salary == null || salary < 0) {
                    return 'Enter a valid salary';
                  }
                  return null;
                },
              ),
              buildInputField(
                label: "Image URL",
                controller: _imageUrlController,
                validator: (value) {
                  final urlPattern =
                      r"(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|jpeg|png|gif|webp)";
                  final isValidUrl = RegExp(
                    urlPattern,
                    caseSensitive: false,
                  ).hasMatch(value ?? '');
                  if (value == null || value.trim().isEmpty) {
                    return 'Image URL is required';
                  } else if (!isValidUrl) {
                    return 'Enter a valid image URL (jpg, png, etc)';
                  }
                  return null;
                },
              ),
              buildInputField(
                label: "Company Name",
                controller: _companyNameController,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Company name is required'
                    : null,
              ),
              buildInputField(
                label: "Requirements (comma separated)",
                controller: _requirementsController,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Requirements are required'
                    : null,
              ),
              if (job != null)
                buildInputField(
                  label: "Status",
                  controller: _statusController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Status is required';
                    }
                    if (value != 'open' && value != 'closed') {
                      return 'Status must be "open" or "closed"';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final job1 = Job(
                        createdAt: job == null ? DateTime.now() : job.createdAt,
                        id: job == null
                            ? DateTime.now().millisecondsSinceEpoch.toString()
                            : job.id,
                        title: _titleController.text.trim(),
                        description: _descriptionController.text.trim(),
                        location: _locationController.text.trim(),
                        salary:
                            double.tryParse(_salaryController.text.trim()) ??
                            0.0,
                        status: job == null
                            ? 'open'
                            : _statusController.text.trim(),
                        createdBy:
                            context.read<AuthCubit>().currentUser?.fullName ??
                            "",
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
                    }
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
    ),
  );
}
