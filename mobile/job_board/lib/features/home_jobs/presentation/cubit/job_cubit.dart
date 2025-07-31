import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_board/features/home_jobs/data/models/job_model.dart';
import 'package:job_board/features/home_jobs/data/repo/job_repo.dart';

part 'job_state.dart';

class JobCubit extends Cubit<JobState> {
  final JobRepository _jobRepository;

  JobCubit(this._jobRepository) : super(JobInitial()) {
    if (_jobRepository.getAllJobs().isEmpty) {
      _jobRepository.addJob(
        Job(
          id: '1',
          title: 'Flutter Developer',
          description: 'Develop mobile apps using Flutter framework.',
          location: 'Remote',
          salary: 12000,
          status: 'open',
          createdBy: 'Admin User',
          imageUrl:
              'https://i.pinimg.com/1200x/db/bd/b5/dbbdb52017ffdce38af556366ae68793.jpg',
          companyName: 'Tech Innovators',
        ),
      );

      _jobRepository.addJob(
        Job(
          id: '2',
          title: 'Backend Engineer',
          description: 'Build and maintain RESTful APIs using Node.js.',
          location: 'Cairo, Egypt',
          salary: 10000,
          status: 'closed',
          createdBy: 'Admin User',
          imageUrl:
              'https://i.pinimg.com/1200x/12/81/60/12816076ccb21f8ae05704c5662efbff.jpg',
          companyName: 'haystack',
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
