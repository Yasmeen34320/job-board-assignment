import 'package:job_board/features/home_jobs/data/models/job_model.dart';

abstract class JobState {}

class JobInitial extends JobState {}

class JobLoading extends JobState {}

class JobLoaded extends JobState {
  final List<Job> jobs;
  JobLoaded(this.jobs);
}
