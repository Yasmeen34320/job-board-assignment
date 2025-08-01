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
      print('from the cubit: $userId');
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
  // ApplicationModel? getApplicationById(String jobId, String userId) {
  //   final applications = applicationRepo.getAllApplications();
  //   return applications.firstWhere((app) => app.jobId == jobId && app.userId == userId, orElse: () => null);
  // }
}
