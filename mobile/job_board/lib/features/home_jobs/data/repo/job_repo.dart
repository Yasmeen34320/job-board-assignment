import 'package:hive/hive.dart';
import '../models/job_model.dart';

class JobRepository {
  final Box<Job> _jobBox = Hive.box<Job>('jobs');

  List<Job> getAllJobs() {
    return _jobBox.values.toList();
  }

  Future<void> addJob(Job job) async {
    await _jobBox.put(job.id, job);
  }

  Future<void> updateJob(String id, Job updatedJob) async {
    await _jobBox.put(id, updatedJob);
  }

  Future<void> deleteJob(String id) async {
    await _jobBox.delete(id);
  }

  Job? getJobById(String id) {
    return _jobBox.get(id);
  }
}
