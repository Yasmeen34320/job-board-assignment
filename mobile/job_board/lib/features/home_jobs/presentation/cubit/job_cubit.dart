import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_board/features/home_jobs/data/models/job_model.dart';
import 'package:job_board/features/home_jobs/data/repo/job_repo.dart';
import 'package:job_board/features/home_jobs/presentation/cubit/job_state.dart';

class JobCubit extends Cubit<JobState> {
  final JobRepository _jobRepository;

  JobCubit(this._jobRepository) : super(JobInitial()) {
    if (_jobRepository.getAllJobs().isEmpty) {
      _jobRepository.addJob(
        Job(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'Flutter Developer',
          description: 'Develop mobile apps using Flutter framework.',
          location: 'Remote',
          salary: 12000,
          status: 'open',
          createdBy: 'Admin User',
          imageUrl:
              'https://i.pinimg.com/1200x/db/bd/b5/dbbdb52017ffdce38af556366ae68793.jpg',
          companyName: 'Tech Innovators',
          requirements: [
            'Strong experience with Flutter and Dart',
            'Familiarity with RESTful APIs',
            'Experience with state management solutions like Provider or Bloc',
            'Understanding of mobile app architecture',
            'Ability to write clean and maintainable code',
            'Good problem-solving skills',
            'Team player with good communication skills',
          ],
          createdAt: DateTime.now(),
        ),
      );

      _jobRepository.addJob(
        Job(
          id: DateTime.now()
              .add(const Duration(minutes: 1))
              .millisecondsSinceEpoch
              .toString(),
          title: 'Backend Engineer',
          description: 'Build and maintain RESTful APIs using Node.js.',
          location: 'Cairo, Egypt',
          salary: 10000,
          status: 'closed',
          createdBy: 'Admin User',
          imageUrl:
              'https://i.pinimg.com/1200x/12/81/60/12816076ccb21f8ae05704c5662efbff.jpg',
          companyName: 'haystack',
          requirements: [
            'Strong experience with Node.js and Express.js',
            'Familiarity with RESTful API design',
            'Experience with MongoDB or similar databases',
            'Understanding of authentication and authorization',
            'Ability to write clean and maintainable code',
            'Good problem-solving skills',
            'Team player with good communication skills',
          ],
          createdAt: DateTime.now().add(const Duration(minutes: 1)),
        ),
      );
    }

    // Load jobs after adding
    loadJobs();
  }
  var selectedStatus = "All";
  var selectedLocation = "All";
  void loadJobs() {
    emit(JobLoading());
    var jobs = _jobRepository.getAllJobs();

    jobs.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    if (selectedStatus != "All") {
      jobs = jobs.where((job) => job.status == selectedStatus).toList();
    }
    if (selectedLocation != "All") {
      jobs = jobs.where((job) => job.location == selectedLocation).toList();
    }

    emit(JobLoaded(jobs));
  }

  Future<void> addJob(Job job) async {
    await _jobRepository.addJob(job);
    loadJobs();
  }

  Future<void> updateJob(String id, Job updatedJob) async {
    await _jobRepository.updateJob(id, updatedJob);
    loadJobs();
  }

  Future<void> deleteJob(String id) async {
    await _jobRepository.deleteJob(id);
    loadJobs();
  }

  Job? getJobById(String id) {
    return _jobRepository.getJobById(id);
  }
}
