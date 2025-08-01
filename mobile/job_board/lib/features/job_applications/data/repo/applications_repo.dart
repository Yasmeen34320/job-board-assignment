import 'dart:io';
import 'package:hive/hive.dart';
import 'package:job_board/features/auth/data/models/user_model.dart';
import 'package:job_board/features/job_applications/data/models/application_model.dart';
import 'package:uuid/uuid.dart';

class ApplicationRepo {
  final box = Hive.box<ApplicationModel>('applications');
  final userBox = Hive.box<UserModel>('users');

  Future<List<ApplicationModel>> getAllApplications(String userId) async {
    UserModel? user = userBox.values.firstWhere((user) => user.id == userId);
    print('User role: ${user.role}');
    if (user.role == 'jobseeker') {
      return box.values
          .where((application) => application.userId == user.id)
          .toList();
    }
    return box.values.toList();
  }

  Future<void> updateApp(String id, ApplicationModel app) async {
    final keyToUpdate = box.keys.firstWhere(
      (key) => box.get(key)?.id == id,
      orElse: () => null,
    );

    if (keyToUpdate != null) {
      await box.put(keyToUpdate, app);
    }
  }

  Future<void> submitApplication({
    required String jobId,
    required String userId,
    required File resumeFile,
    required String coverLetter,
  }) async {
    final box = await Hive.openBox<ApplicationModel>('applications');

    final application = ApplicationModel(
      id: const Uuid().v4(),
      jobId: jobId,
      userId: userId,
      resumePath: resumeFile.path,
      coverLetter: coverLetter,
      status: 'pending',
      createdAt: DateTime.now(),
    );

    await box.add(application);
  }

  Future<void> deleteApp(String applicationId) async {
    final keyToDelete = box.keys.firstWhere(
      (key) => box.get(key)?.id == applicationId,
      orElse: () => null,
    );

    if (keyToDelete != null) {
      await box.delete(keyToDelete);
    }
  }
}
