import 'dart:ffi';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:job_board/features/auth/data/models/user_model.dart';
import 'package:job_board/features/home_jobs/data/models/job_model.dart';
import 'package:job_board/features/job_applications/data/models/application_model.dart';
import 'package:job_board/features/job_applications/data/repo/applications_repo.dart';
import 'application_state.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  final ApplicationRepo applicationRepo;

  ApplicationCubit(this.applicationRepo) : super(ApplicationInitial());

  Future<void> submitApplication({
    required String jobId,
    required String userId,
    required File resumeFile,
    required String coverLetter,
  }) async {
    emit(ApplicationSubmitting());

    try {
      await applicationRepo.submitApplication(
        jobId: jobId,
        userId: userId,
        resumeFile: resumeFile,
        coverLetter: coverLetter,
      );

      emit(ApplicationSubmitted());
    } catch (e) {
      emit(ApplicationError('Failed to submit application: $e'));
    }
  }

  var selectedStatus = "All";
  var searchQuery = "";
  Future<void> getAllApplications(String userId) async {
    emit(ApplicationsLoading());
    try {
      var applications = await applicationRepo.getAllApplications(userId);
      var jobsBox = Hive.box<Job>('jobs');
      applications = applications
          .where(
            (application) => jobsBox.values.toList().any(
              (job) => job.id == application.jobId,
            ),
          )
          .toList();
      if (selectedStatus != 'All') {
        applications = applications
            .where((app) => app.status == selectedStatus)
            .toList();
      }
      print("Before search filter: ${applications.length}");

      if (searchQuery.isNotEmpty) {
        final usersBox = Hive.box<UserModel>('users');
        final query = searchQuery.toLowerCase();

        applications = applications.where((app) {
          final user = usersBox.values.firstWhere(
            (user) => user.id == app.userId,
          );

          if (user == null) return false;

          return user.fullName.toLowerCase().contains(query);
        }).toList();
      }
      print("After search filter: ${applications.length}");

      print('from the cubit: $userId');
      print('status: ${selectedStatus}');
      emit(ApplicationsLoaded(applications));
      // return applications;
    } catch (e) {
      emit(ApplicationError('Failed to fetch applications: $e'));
      // return [];
    }
  }

  // bool applicationExists = false;
  Future<bool> Function(String jobId, String userId)
  get checkApplicationExists => (String jobId, String userId) async {
    final applications = await applicationRepo.getAllApplications(userId);
    return applications.any(
      (app) => app.jobId == jobId && app.userId == userId,
    );
  };
  Future<void> updateApplication(String id, ApplicationModel updatedApp) async {
    await applicationRepo.updateApp(id, updatedApp);
  }

  Future<void> deleteApplication(String applicationId) async {
    await applicationRepo.deleteApp(applicationId);
  }

  // Future<void> filterApplications() async {
  //   emit(ApplicationsLoading());
  //   try {
  //     var applications = await applicationRepo.getAllApplications('');
  //     var jobsBox = Hive.box<Job>('jobs');
  //     applications = applications
  //         .where(
  //           (application) => jobsBox.values.toList().any(
  //             (job) => job.id == application.jobId,
  //           ),
  //         )
  //         .toList();
  //     if (selectedStatus != 'All') {
  //       applications = applications
  //           .where((app) => app.status == selectedStatus)
  //           .toList();
  //     }
  //     emit(ApplicationsLoaded(applications));
  //     // return applications;
  //   } catch (e) {
  //     emit(ApplicationError('Failed to fetch applications: $e'));
  //     // return [];
  //   }
  // }

  // ApplicationModel? getApplicationById(String jobId, String userId) {
  //   final applications = applicationRepo.getAllApplications();
  //   return applications.firstWhere((app) => app.jobId == jobId && app.userId == userId, orElse: () => null);
  // }
}
