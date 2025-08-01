import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:job_board/core/services/service_locator.dart';
import 'package:job_board/features/auth/data/models/user_model.dart';
import 'package:job_board/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:job_board/features/home_jobs/data/models/job_model.dart';
import 'package:job_board/features/job_details/presentation/screens/job_details_screen.dart';
import 'package:job_board/features/job_applications/data/repo/applications_repo.dart';
import 'package:job_board/features/job_applications/presentation/cubit/application_cubit.dart';
import 'package:job_board/features/job_applications/presentation/cubit/application_state.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ApplicationCubit(locator<ApplicationRepo>())
        ..getAllApplications(context.read<AuthCubit>().currentUser?.id ?? ''),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Job Applications',
            style: GoogleFonts.poppins(letterSpacing: 2, color: Colors.white),
          ),
        ),
        body: BlocBuilder<ApplicationCubit, ApplicationState>(
          builder: (context, state) {
            if (state is ApplicationsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ApplicationsLoaded) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 16,
                ),
                child: ListView.separated(
                  itemCount: state.applications.length,
                  itemBuilder: (context, index) {
                    final application = state.applications[index];
                    final jobsBox = Hive.box<Job>('jobs');
                    final job = jobsBox.values
                        .where((job) => job.id == application.jobId)
                        .firstOrNull;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          if (job == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error : Job not found')),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => JobDetailsScreen(job: job),
                            ),
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              job?.imageUrl ?? "",
                              width: 90,
                              height: 90,
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  job?.title ?? "",
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.2,
                                    color: Colors.black87,
                                  ),
                                ),
                                // const SizedBox(height: 2),
                                Text(
                                  job?.companyName ?? "",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  job?.location ?? "",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black45,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // submitted, reviewed, accepted, rejected
                                Text(
                                  'Status: ${application.status}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.2,
                                    color: application.status == 'submitted'
                                        ? Colors.black87
                                        : application.status == 'reviewed'
                                        ? Color(0xFF007BFF)
                                        : application.status == 'accepted'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                    // ListTile(
                    //   title: Text('Application #${application.id}'),
                    // );
                  },
                  separatorBuilder: (context, index) => Divider(),
                ),
              );
            } else {
              return Center(child: Text('Error loading applications'));
            }
          },
        ),
      ),
    );
  }
}
