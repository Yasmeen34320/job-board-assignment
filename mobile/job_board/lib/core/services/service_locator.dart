import 'package:get_it/get_it.dart';
import 'package:job_board/features/auth/data/repo/auth_repo.dart';
import 'package:job_board/features/home_jobs/data/repo/job_repo.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<MockAuthRepository>(() => MockAuthRepository());
  locator.registerLazySingleton<JobRepository>(() => JobRepository());
}
