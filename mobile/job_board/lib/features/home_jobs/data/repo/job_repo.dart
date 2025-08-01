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
    final keyToUpdate = _jobBox.keys.firstWhere(
      (key) => _jobBox.get(key)?.id == id,
      orElse: () => null,
    );

    if (keyToUpdate != null) {
      await _jobBox.put(keyToUpdate, updatedJob);
    }
  }

  Future<void> deleteJob(String id) async {
    final keyToDelete = _jobBox.keys.firstWhere(
      (key) => _jobBox.get(key)?.id == id,
      orElse: () => null,
    );

    if (keyToDelete != null) {
      await _jobBox.delete(keyToDelete);
    }
    // await _jobBox.delete(id);
  }

  Job? getJobById(String id) {
    return _jobBox.get(id);
  }
}
