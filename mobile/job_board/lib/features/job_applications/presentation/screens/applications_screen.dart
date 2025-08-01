import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:job_board/core/services/service_locator.dart';
import 'package:job_board/features/auth/data/models/user_model.dart';
import 'package:job_board/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:job_board/features/home_jobs/data/models/job_model.dart';
import 'package:job_board/features/home_jobs/presentation/components/build_dropDown.dart';
import 'package:job_board/features/home_jobs/presentation/cubit/job_cubit.dart';
import 'package:job_board/features/job_applications/data/models/application_model.dart';
import 'package:job_board/features/job_applications/presentation/components/container_component.dart';
import 'package:job_board/features/job_applications/presentation/screens/pdf_viewer_screen.dart';
import 'package:job_board/features/job_details/presentation/screens/job_details_screen.dart';
import 'package:job_board/features/job_applications/data/repo/applications_repo.dart';
import 'package:job_board/features/job_applications/presentation/cubit/application_cubit.dart';
import 'package:job_board/features/job_applications/presentation/cubit/application_state.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  TextEditingController search = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Accessing the Cubit instance and calling the function
    context.read<ApplicationCubit>().getAllApplications(
      context.read<AuthCubit>().currentUser?.id ?? "",
    ); // or BlocProvider.of<JobCubit>(context).fetchJobs();
  }

  @override
  Widget build(BuildContext context) {
    // BlocProvider(
    //   create: (context) => ApplicationCubit(locator<ApplicationRepo>())
    //     ..getAllApplications(context.read<AuthCubit>().currentUser?.id ?? ''),
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Job Applications',
          style: GoogleFonts.poppins(letterSpacing: 2, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          if (context.read<AuthCubit>().currentUser?.role == 'admin')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Review and manage Job Applications ',
                style: GoogleFonts.poppins(
                  letterSpacing: 2,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BlocBuilder<ApplicationCubit, ApplicationState>(
              builder: (context, state) => SizedBox(
                height: 50,
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final status = [
                      'All',
                      'pending',
                      'rejected',
                      'accepted',
                    ][index];
                    String selectedStatus = context
                        .read<ApplicationCubit>()
                        .selectedStatus;
                    return Center(
                      child: GestureDetector(
                        onTap: () {
                          context.read<ApplicationCubit>().selectedStatus =
                              status;
                          context.read<ApplicationCubit>().getAllApplications(
                            context.read<AuthCubit>().currentUser?.id ?? '',
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedStatus == status
                                ? Color(0xFF4F4AD3)
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16,
                            ),
                            child: Text(
                              status,
                              style: GoogleFonts.poppins(
                                letterSpacing: 3,
                                fontSize: 16,
                                color: status == selectedStatus
                                    ? Colors.white
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(width: 10),
                  itemCount: 4,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
          ),

          SizedBox(height: 8),

          // if (context.read<AuthCubit>().currentUser?.role == 'admin')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BlocBuilder<ApplicationCubit, ApplicationState>(
              builder: (context, state) {
                search.text = context.read<ApplicationCubit>().searchQuery;
                return TextField(
                  controller: search,
                  decoration: InputDecoration(
                    focusColor: Color(0xFF4F4AD3),
                    hintText: 'Search by full name...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  onChanged: (value) {
                    context.read<ApplicationCubit>().searchQuery = value;
                    context.read<ApplicationCubit>().getAllApplications(
                      context.read<AuthCubit>().currentUser?.id ?? '',
                    );
                    // setState(() {
                    //   searchQuery = value;
                    // });
                  },
                );
              },
            ),
          ),

          SizedBox(height: 10),
          BlocBuilder<ApplicationCubit, ApplicationState>(
            builder: (context, state) {
              if (state is ApplicationsLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ApplicationsLoaded) {
                if (state.applications.isNotEmpty) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${state.applications.length} Application Found',
                              style: GoogleFonts.poppins(
                                letterSpacing: 2,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.separated(
                              itemCount: state.applications.length,
                              itemBuilder: (context, index) {
                                final application = state.applications[index];
                                final jobsBox = Hive.box<Job>('jobs');
                                var job = jobsBox.values
                                    .where((job) => job.id == application.jobId)
                                    .firstOrNull;
                                final usersBox = Hive.box<UserModel>('users');
                                final user = usersBox.values
                                    .where(
                                      (user) => user.id == application.userId,
                                    )
                                    .firstOrNull;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 2,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (job == null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Error : Job not found',
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              JobDetailsScreen(job: job),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 0.8,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16.0,
                                          horizontal: 10,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.network(
                                                    job?.imageUrl ?? '',
                                                    width: 60,
                                                    height: 60,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),

                                                // Image.network(
                                                //   job?.imageUrl ?? "",
                                                //   width: 70,
                                                //   height: 70,
                                                // ),
                                                const SizedBox(width: 15),
                                                SizedBox(
                                                  width: 200,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        job?.title ?? "",
                                                        style:
                                                            GoogleFonts.poppins(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              letterSpacing: 1,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                      ),
                                                      // const SizedBox(height: 2),
                                                      Text(
                                                        job?.companyName ?? "",
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 18,
                                                          // fontWeight: FontWeight.w700,
                                                          letterSpacing: 1.2,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors
                                                              .blue
                                                              .shade50,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 4.0,
                                                                horizontal: 8,
                                                              ),
                                                          child: Text(
                                                            job?.location ?? "",
                                                            style:
                                                                GoogleFonts.poppins(
                                                                  fontSize: 16,
                                                                  letterSpacing:
                                                                      1.2,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 6),

                                                      // submitted, reviewed, accepted, rejected
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        application.status ==
                                                            'pending'
                                                        ? Colors.amber.shade50
                                                        : application.status ==
                                                              'accepted'
                                                        ? Colors.green.shade50
                                                        : Colors.red.shade50,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 4.0,
                                                          horizontal: 10,
                                                        ),
                                                    child: Text(
                                                      application.status,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        letterSpacing: 1.2,
                                                        color:
                                                            application
                                                                    .status ==
                                                                'pending'
                                                            ? Colors
                                                                  .amber
                                                                  .shade700
                                                            : application
                                                                      .status ==
                                                                  'accepted'
                                                            ? Colors.green
                                                            : Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 2),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 6.0,
                                                    horizontal: 16,
                                                  ),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.calendar_month),
                                                  SizedBox(width: 2),
                                                  Text(
                                                    'Applied On  ${DateFormat('dd-MM-yyyy').format(application.createdAt)}',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      letterSpacing: 2,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 14.0,
                                                  ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.green.shade50,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 4.0,
                                                            horizontal: 16,
                                                          ),
                                                      child: Text(
                                                        user?.fullName ?? "",
                                                        style:
                                                            GoogleFonts.poppins(
                                                              letterSpacing: 2,
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .green
                                                                  .shade700,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    'Applied',
                                                    style: GoogleFonts.poppins(
                                                      letterSpacing: 2,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            if (context
                                                    .read<AuthCubit>()
                                                    .currentUser
                                                    ?.role ==
                                                'admin')
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                    ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Change Status:',
                                                      style:
                                                          GoogleFonts.poppins(
                                                            letterSpacing: 2,
                                                            fontSize: 16,
                                                          ),
                                                    ),
                                                    SizedBox(width: 20),
                                                    Container(
                                                      height: 35,

                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors
                                                              .grey
                                                              .shade500,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: DropdownButton<String>(
                                                          value: application
                                                              .status,
                                                          underline:
                                                              const SizedBox(),
                                                          isDense: true,
                                                          style:
                                                              GoogleFonts.poppins(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black,
                                                                letterSpacing:
                                                                    2,
                                                              ),
                                                          items:
                                                              [
                                                                'pending',
                                                                'accepted',
                                                                'rejected',
                                                              ].map((
                                                                String val,
                                                              ) {
                                                                return DropdownMenuItem<
                                                                  String
                                                                >(
                                                                  value: val,
                                                                  child: Text(
                                                                    val,
                                                                  ),
                                                                );
                                                              }).toList(),
                                                          onChanged: (String? val) {
                                                            final app1 = ApplicationModel(
                                                              id: application
                                                                  .id,
                                                              jobId: application
                                                                  .jobId,
                                                              userId:
                                                                  application
                                                                      .userId,
                                                              status:
                                                                  val ??
                                                                  "pending",
                                                              resumePath:
                                                                  application
                                                                      .resumePath,
                                                              coverLetter:
                                                                  application
                                                                      .coverLetter,
                                                              createdAt:
                                                                  application
                                                                      .createdAt,
                                                            );

                                                            context
                                                                .read<
                                                                  ApplicationCubit
                                                                >()
                                                                .updateApplication(
                                                                  application
                                                                      .id,
                                                                  app1,
                                                                );
                                                            context
                                                                .read<
                                                                  ApplicationCubit
                                                                >()
                                                                .getAllApplications(
                                                                  context
                                                                          .read<
                                                                            AuthCubit
                                                                          >()
                                                                          .currentUser
                                                                          ?.id ??
                                                                      "",
                                                                );
                                                            // job.status = val;
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                            SizedBox(height: 8),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              PDFViewerScreen(
                                                                filePath:
                                                                    application
                                                                        .resumePath,
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey
                                                            .shade100,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 8.0,
                                                              horizontal: 16,
                                                            ),
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.visibility,
                                                            ),
                                                            SizedBox(width: 6),
                                                            Text(
                                                              'Resume',
                                                              style: GoogleFonts.poppins(
                                                                fontSize: 15,
                                                                letterSpacing:
                                                                    2,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  GestureDetector(
                                                    onTap: () {
                                                      showCoverLetterDialog(
                                                        context,
                                                        application.coverLetter,
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey
                                                            .shade100,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 8.0,
                                                              horizontal: 16,
                                                            ),
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.visibility,
                                                            ),
                                                            SizedBox(width: 6),
                                                            Text(
                                                              'Cover Letter',
                                                              style: GoogleFonts.poppins(
                                                                fontSize: 15,
                                                                letterSpacing:
                                                                    2,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      final result = await showWithdrawDialog(
                                                        context,
                                                        () {
                                                          context
                                                              .read<
                                                                ApplicationCubit
                                                              >()
                                                              .deleteApplication(
                                                                application.id,
                                                              ); // implement this
                                                        },
                                                      );
                                                      if (result == true) {
                                                        context
                                                            .read<
                                                              ApplicationCubit
                                                            >()
                                                            .getAllApplications(
                                                              context
                                                                      .read<
                                                                        AuthCubit
                                                                      >()
                                                                      .currentUser
                                                                      ?.id ??
                                                                  '',
                                                            );
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey
                                                            .shade100,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 8.0,
                                                              horizontal: 16,
                                                            ),
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.delete,
                                                              color: Colors
                                                                  .redAccent,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                                // ListTile(
                                //   title: Text('Application #${application.id}'),
                                // );
                              },
                              separatorBuilder: (context, index) => Divider(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        ),

                        SizedBox(height: 20),
                        Text(
                          'No Applications Found',
                          style: GoogleFonts.poppins(
                            letterSpacing: 3,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Center(
                          child: Lottie.asset('assets/non data found.json'),
                        ),
                      ],
                    ),
                  );
                }
              } else {
                return Center(child: Text('Error loading applications'));
              }
            },
          ),
        ],
      ),
    );
  }
}

Future<bool?> showWithdrawDialog(BuildContext context, VoidCallback onConfirm) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
        'Confirm Withdraw',
        style: GoogleFonts.poppins(letterSpacing: 2),
      ),
      content: Text(
        'Are you sure you want to withdraw this application?',
        style: GoogleFonts.poppins(letterSpacing: 2),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(
            'Cancel',
            style: GoogleFonts.poppins(letterSpacing: 2, color: Colors.black87),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4F4AD3),
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            onConfirm();
            Navigator.of(ctx).pop(true);
          },
          child: Text('Withdraw', style: GoogleFonts.poppins(letterSpacing: 2)),
        ),
      ],
    ),
  );
}

void showCoverLetterDialog(BuildContext context, String coverLetter) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
        'Cover Letter',
        style: GoogleFonts.poppins(letterSpacing: 2, color: Color(0xFF4F4AD3)),
      ),
      content: SingleChildScrollView(
        child: Text(coverLetter, style: GoogleFonts.poppins(letterSpacing: 2)),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4F4AD3),
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text('Close', style: GoogleFonts.poppins(letterSpacing: 2)),
        ),
      ],
    ),
  );
}
