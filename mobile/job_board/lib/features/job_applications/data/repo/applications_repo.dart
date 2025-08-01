import 'dart:io';
import 'package:hive/hive.dart';
import 'package:job_board/features/auth/data/models/user_model.dart';
import 'package:job_board/features/job_applications/data/models/application_model.dart';
import 'package:uuid/uuid.dart';

class ApplicationRepo {
  Future<List<ApplicationModel>> getAllApplications(String userId) async {
    final box = Hive.box<ApplicationModel>('applications');
    final userBox = Hive.box<UserModel>('users');

    UserModel? user = userBox.values.firstWhere((user) => user.id == userId);
    print('User role: ${user.role}');
    if (user.role == 'jobseeker') {
      return box.values
          .where((application) => application.userId == user.id)
          .toList();
    }
    return box.values.toList();
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
      status: 'submitted',
    );

    await box.add(application);
  }
}
