import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_board/core/services/service_locator.dart';
import 'package:job_board/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:job_board/features/auth/presentation/screens/log_in_screen.dart';
import 'package:job_board/features/home_jobs/data/repo/job_repo.dart';
import 'package:job_board/features/home_jobs/presentation/components/add_job_bottom_sheet.dart';
import 'package:job_board/features/home_jobs/presentation/components/build_dropDown.dart';
import 'package:job_board/features/home_jobs/presentation/cubit/job_cubit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_board/features/home_jobs/presentation/cubit/job_state.dart';
import 'package:job_board/features/job_details/presentation/screens/job_details_screen.dart';
import 'package:job_board/features/job_applications/data/repo/applications_repo.dart';
import 'package:job_board/features/job_applications/presentation/cubit/application_cubit.dart';
import 'package:lottie/lottie.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // <-- Add this

      appBar: AppBar(
        backgroundColor: const Color(0xFF4F4AD3),
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.menu, color: Colors.black),
        //   onPressed: () {
        //     // Implement drawer or side menu
        //   },
        // ),
        title: Text(
          'Discover Jobs',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              context.read<AuthCubit>().logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LogInScreen()),
              );
              // Implement logout logic
            },
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  JobCubit(locator<JobRepository>())..loadJobs(),
            ),
            BlocProvider(
              create: (context) => ApplicationCubit(locator<ApplicationRepo>()),
            ),
          ],
          child: BlocBuilder<JobCubit, JobState>(
            builder: (context, state) {
              if (state is JobLoading) {
                return Center(child: CircularProgressIndicator());
              } else {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: SizedBox(height: 20)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 20,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Filter Jobs',
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF4F4AD3),
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          context
                                                  .read<JobCubit>()
                                                  .selectedStatus =
                                              'All';
                                          context
                                                  .read<JobCubit>()
                                                  .selectedLocation =
                                              'All';
                                          context.read<JobCubit>().loadJobs();
                                        },
                                        icon: const Icon(
                                          Icons.refresh,
                                          size: 18,
                                        ),
                                        label: Text(
                                          "Reset",
                                          style: GoogleFonts.poppins(
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF4F4AD3,
                                          ),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 16,
                                    alignment: WrapAlignment.spaceBetween,
                                    children: [
                                      LabeledDropdown(
                                        label: 'Status',
                                        value: context
                                            .read<JobCubit>()
                                            .selectedStatus,
                                        items: ['All', 'open', 'closed'],
                                        onChanged: (value) {
                                          context
                                                  .read<JobCubit>()
                                                  .selectedStatus =
                                              value!;
                                          context.read<JobCubit>().loadJobs();
                                        },
                                      ),
                                      LabeledDropdown(
                                        label: 'Location',
                                        value: context
                                            .read<JobCubit>()
                                            .selectedLocation,
                                        items: ['All', 'Egypt', 'USA'],
                                        onChanged: (value) {
                                          context
                                                  .read<JobCubit>()
                                                  .selectedLocation =
                                              value!;
                                          context.read<JobCubit>().loadJobs();
                                        },
                                      ),

                                      // SizedBox(width: 30),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: const SizedBox(height: 10)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Results',
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${state is JobLoaded ? state.jobs.length : 0}  jobs found',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                    letterSpacing: 1,
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                            if (context.read<AuthCubit>().currentUser?.role ==
                                'admin')
                              ElevatedButton.icon(
                                onPressed: () {
                                  showAddJobSheet(context, null);
                                },
                                icon: const Icon(Icons.add),
                                label: Text(
                                  'Add Job',
                                  style: GoogleFonts.poppins(
                                    letterSpacing: 1.2,
                                    fontSize: 16,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4F4AD3),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (state is JobLoaded && state.jobs.isEmpty)
                      SliverToBoxAdapter(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            Center(
                              child: Text(
                                'No jobs found !!',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: Lottie.asset('assets/non data found.json'),
                            ),
                          ],
                        ),
                      )
                    else if (state is JobLoaded)
                      //  Padding(
                      //     padding: const EdgeInsets.symmetric(
                      //       horizontal: 8.0,
                      //       vertical: 16,
                      //     ),
                      SliverList(
                        //shrinkWrap: true,

                        // physics: const NeverScrollableScrollPhysics(),

                        // itemCount: state.jobs.length,
                        // itemBuilder: (context, index) {
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final job = state.jobs[index];
                          return GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => JobDetailsScreen(job: job),
                                ),
                              );

                              if (result == true) {
                                // User applied and went back
                                context
                                    .read<JobCubit>()
                                    .loadJobs(); // reload job list
                                // setState(
                                //   () {},
                                // ); // rebuild to update applied UI
                              }
                            },
                            child: FutureBuilder<bool>(
                              future: context
                                  .read<ApplicationCubit>()
                                  .checkApplicationExists(
                                    job.id,
                                    context.read<AuthCubit>().currentUser?.id ??
                                        '',
                                  ),
                              builder: (context, snapshot) {
                                final exists = snapshot.data ?? false;
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    // height: 140,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                    ),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 10,
                                            // height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(12),
                                                bottomLeft: Radius.circular(12),
                                              ),
                                              color: job.status == 'open'
                                                  ? Colors.green.shade500
                                                  : Colors.red.shade500,
                                            ),
                                            // Expands to match parent height
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                SizedBox(height: 10),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      child: Container(
                                                        height: 70,
                                                        width: 70,
                                                        decoration: BoxDecoration(
                                                          color: Colors
                                                              .grey[300], // gray background
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                          image: DecorationImage(
                                                            image: NetworkImage(
                                                              job.imageUrl,
                                                            ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      //  Image.network(
                                                      //   job?.imageUrl ?? '',
                                                      //   width: 70,
                                                      //   height: 70,
                                                      //   fit: BoxFit.cover,
                                                      // ),
                                                    ),
                                                    const SizedBox(width: 15),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: 180,
                                                          child: Text(
                                                            job.title,
                                                            style:
                                                                GoogleFonts.poppins(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .black87,
                                                                ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          job.companyName,
                                                          style:
                                                              GoogleFonts.poppins(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black54,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    if (context
                                                            .read<AuthCubit>()
                                                            .currentUser
                                                            ?.role ==
                                                        'admin')
                                                      IconButton(
                                                        onPressed: () {
                                                          context
                                                              .read<JobCubit>()
                                                              .deleteJob(
                                                                job.id,
                                                              );
                                                          // Handle edit action
                                                        },
                                                        icon: Icon(
                                                          Icons.delete,
                                                          size: 20,
                                                        ),
                                                        color: Colors.red,
                                                      ),
                                                    // SizedBox(width: 5),
                                                    if (context
                                                            .read<AuthCubit>()
                                                            .currentUser
                                                            ?.role ==
                                                        'admin')
                                                      IconButton(
                                                        onPressed: () {
                                                          // Handle edit action
                                                          showAddJobSheet(
                                                            context,
                                                            job,
                                                          );
                                                        },
                                                        icon: Icon(
                                                          Icons.edit,
                                                          size: 20,
                                                        ),
                                                        color: Colors.blue,
                                                      ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 20.0,
                                                      ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        exists == true
                                                        ? MainAxisAlignment
                                                              .spaceBetween
                                                        : MainAxisAlignment.end,
                                                    children: [
                                                      if (exists == true)
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            color: Colors
                                                                .green
                                                                .shade50,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  vertical: 6.0,
                                                                  horizontal:
                                                                      12,
                                                                ),
                                                            child: Text(
                                                              'Applied',
                                                              style: GoogleFonts.poppins(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                letterSpacing:
                                                                    2,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      Text(
                                                        job.location,
                                                        style:
                                                            GoogleFonts.poppins(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .black54,
                                                              letterSpacing: 1,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 15),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );

                          //  ListTile(
                          //   title: Text(job.title),
                          //   subtitle: Text(
                          //     '${job.location} - ${job.salary}',
                          //   ),
                          //   trailing: Text(job.status),
                          //   onTap: () {
                          //     // Navigate to job details
                          //   },
                          // );
                        }, childCount: state.jobs.length),
                      )
                    else
                      const Center(child: CircularProgressIndicator()),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
