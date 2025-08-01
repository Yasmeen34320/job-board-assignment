import 'package:get_it/get_it.dart';
import 'package:job_board/features/auth/data/repo/auth_repo.dart';
import 'package:job_board/features/home_jobs/data/repo/job_repo.dart';
import 'package:job_board/features/job_applications/data/repo/applications_repo.dart';
import 'package:job_board/features/users/data/repo/users_rebo.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<MockAuthRepository>(() => MockAuthRepository());
  locator.registerLazySingleton<JobRepository>(() => JobRepository());
  locator.registerLazySingleton<ApplicationRepo>(() => ApplicationRepo());
  locator.registerLazySingleton<UsersRepository>(() => UsersRepository());
}
