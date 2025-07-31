import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_board/core/services/service_locator.dart';
import 'package:job_board/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:job_board/features/home_jobs/data/repo/job_repo.dart';
import 'package:job_board/features/home_jobs/presentation/cubit/job_cubit.dart';
import 'package:google_fonts/google_fonts.dart';

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
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.search, color: Colors.white),
        //     onPressed: () {
        //       // Implement search logic
        //     },
        //   ),
        // ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => JobCubit(locator<JobRepository>())..loadJobs(),
            child: BlocBuilder<JobCubit, JobState>(
              builder: (context, state) {
                if (state is JobLoading) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Column(
                    children: [
                      SizedBox(height: 20),
                      Padding(
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
                                  Text(
                                    'Filter Jobs',
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF4F4AD3),
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 16,
                                    alignment: WrapAlignment.spaceBetween,
                                    children: [
                                      _buildDropdown(
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
                                      _buildDropdown(
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
                                      SizedBox(width: 30),
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
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
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (state is JobLoaded && state.jobs.isEmpty)
                        Center(
                          child: Text(
                            'No jobs found',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      else if (state is JobLoaded)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 16,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.jobs.length,
                            itemBuilder: (context, index) {
                              final job = state.jobs[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 120,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.shade200,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomLeft: Radius.circular(12),
                                          ),
                                          color: job.status == 'open'
                                              ? Colors.green.shade500
                                              : Colors.red.shade500,
                                        ),
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
                                                Image.network(
                                                  job.imageUrl,
                                                  width: 70,
                                                  height: 70,
                                                ),
                                                const SizedBox(width: 15),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      job.title,
                                                      style:
                                                          GoogleFonts.poppins(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      job.companyName,
                                                      style:
                                                          GoogleFonts.poppins(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                    ),
                                                  ],
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
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    job.location,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      color: Colors.black54,
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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
                            },
                          ),
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
      ),
    );
  }
}

Widget _buildDropdown({
  required String label,
  required String value,
  required List<String> items,
  required void Function(String?) onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          letterSpacing: 2,
        ),
      ),
      const SizedBox(height: 6),
      Container(
        height: 35,
        width: 110,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade500),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: DropdownButton<String>(
            value: value,
            underline: const SizedBox(),
            isDense: true,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black,
              letterSpacing: 2,
            ),
            items: items.map((String val) {
              return DropdownMenuItem<String>(value: val, child: Text(val));
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    ],
  );
}
