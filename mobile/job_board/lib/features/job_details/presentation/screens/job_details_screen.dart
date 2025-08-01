import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:job_board/core/services/service_locator.dart';
import 'package:job_board/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:job_board/features/home_jobs/data/models/job_model.dart';
import 'package:job_board/features/job_applications/data/models/application_model.dart';
import 'package:job_board/features/job_applications/data/repo/applications_repo.dart';
import 'package:job_board/features/job_applications/presentation/cubit/application_cubit.dart';
import 'package:job_board/features/job_applications/presentation/cubit/application_state.dart';
import 'package:job_board/features/job_details/presentation/components/submit_application_sheet.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class JobDetailsScreen extends StatefulWidget {
  final Job job;
  const JobDetailsScreen({super.key, required this.job});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  bool hasApplied = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, hasApplied); // Send result even on back button
        return false; // Prevent default pop, since we already did it
      },
      child: BlocProvider(
        create: (context) => ApplicationCubit(locator<ApplicationRepo>())
          ..checkApplicationExists(
            widget.job.id,
            context.read<AuthCubit>().currentUser?.id ?? '',
          ),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Details",
              style: GoogleFonts.poppins(color: Colors.white, letterSpacing: 2),
            ),
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(minHeight: screenHeight),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(widget.job.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.job.companyName,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    letterSpacing: 2,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                SizedBox(
                                  width: 300,
                                  child: Text(
                                    widget.job.title,
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      letterSpacing: 2,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            SizedBox(width: 20),
                            Container(
                              width: 60, // adjust size as needed
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade200, // background color
                              ),
                              child: Icon(
                                Icons
                                    .attach_money, // change to your desired icon
                                color: Color(0xFF4F4AD3), // icon color
                                size: 30,
                              ),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Salary',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    letterSpacing: 2,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '\$${widget.job.salary}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    letterSpacing: 2,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            SizedBox(width: 20),
                            Container(
                              width: 60, // adjust size as needed
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade200, // background color
                              ),
                              child: Icon(
                                Icons
                                    .location_city, // change to your desired icon
                                color: Color(0xFF4F4AD3), // icon color
                                size: 30,
                              ),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Locaion',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    letterSpacing: 2,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  widget.job.location,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    letterSpacing: 2,

                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 36),
                        Text(
                          'Job Description',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            letterSpacing: 2,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          widget.job.description,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            letterSpacing: 1,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Requirements',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            letterSpacing: 2,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 16),
                        ListView.builder(
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF4F4AD3),
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      widget.job.requirements[index],
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        letterSpacing: 1.2,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: widget.job.requirements.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (context.read<AuthCubit>().currentUser?.role != 'admin')
                BlocConsumer<ApplicationCubit, ApplicationState>(
                  listener: (context, state) {
                    if (state is ApplicationSubmitted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Application submitted successfully!'),
                        ),
                      );
                      setState(() {
                        hasApplied = true;
                      });
                    } else if (state is ApplicationError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${state.message}')),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ApplicationSubmitting) {
                      return CircularProgressIndicator();
                    }
                    return FutureBuilder<bool>(
                      future: context
                          .read<ApplicationCubit>()
                          .checkApplicationExists(
                            widget.job.id,
                            context.read<AuthCubit>().currentUser?.id ?? '',
                          ),
                      builder: (context, snapshot) {
                        final exists = snapshot.data ?? false;
                        return Positioned(
                          bottom: 1,
                          left: 20,
                          right: 20,
                          child: ElevatedButton(
                            onPressed: () {
                              if (exists == true ||
                                  widget.job.status == 'closed') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      widget.job.status == 'closed'
                                          ? 'This Job don'
                                                't accept applications anymore '
                                          : 'You have already applied for this job.',
                                    ),
                                  ),
                                );
                                return;
                              }
                              final applicationCubit = context
                                  .read<ApplicationCubit>();

                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                ),
                                builder: (context) => BlocProvider.value(
                                  value: applicationCubit, // reuse existing
                                  child: SubmitApplicationSheet(
                                    jobId: widget.job.id,
                                    userId:
                                        context
                                            .read<AuthCubit>()
                                            .currentUser
                                            ?.id ??
                                        '',
                                    scaffoldContext: context,
                                  ),
                                ),
                              );

                              // Handle apply button press
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  exists == true ||
                                      widget.job.status == 'closed'
                                  ? Colors.grey.shade300
                                  : Color(0xFF4F4AD3),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              exists == true
                                  ? 'Already Applied'
                                  : widget.job.status == 'closed'
                                  ? 'Closed'
                                  : 'Apply Now',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                letterSpacing: 2,
                                color:
                                    exists == true ||
                                        widget.job.status == 'closed'
                                    ? Colors.black
                                    : Colors.white,
                                fontWeight:
                                    exists == true ||
                                        widget.job.status == 'closed'
                                    ? FontWeight.w500
                                    : FontWeight.w300,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
