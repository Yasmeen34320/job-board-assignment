import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:job_board/core/services/service_locator.dart';
import 'package:job_board/features/auth/data/models/user_model.dart';
import 'package:job_board/features/auth/data/repo/auth_repo.dart';
import 'package:job_board/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:job_board/features/auth/presentation/cubit/auth_state.dart';
import 'package:job_board/features/auth/presentation/screens/log_in_screen.dart';
import 'package:job_board/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:job_board/features/home_jobs/data/models/job_model.dart';
import 'package:job_board/features/home_jobs/presentation/cubit/navigation_cubit/navigation_cubit.dart';
import 'package:job_board/features/home_jobs/test.dart';
import 'package:job_board/features/job_applications/data/models/application_model.dart';
import 'package:job_board/features/job_applications/data/repo/applications_repo.dart';
import 'package:job_board/features/job_applications/presentation/cubit/application_cubit.dart';
import 'package:job_board/features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('users');
  await Hive.openBox('sessionBox');
  Hive.registerAdapter(JobAdapter());
  // Hive.deleteBoxFromDisk('jobs');

  await Hive.openBox<Job>('jobs');
  Hive.registerAdapter(ApplicationModelAdapter());
  // Hive.deleteBoxFromDisk('applications');

  await Hive.openBox<ApplicationModel>('applications');
  setupLocator(); // ⬅ Initialize your service locator
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthCubit(locator<MockAuthRepository>())..getCurrentUser(),
        ),
        BlocProvider(
          create: (context) => ApplicationCubit(
            (locator<ApplicationRepo>())..getAllApplications(''),
          ),
        ),
        BlocProvider(create: (_) => MainLayoutCubit()), // <-- This
      ],

      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF4F4AD3),
            iconTheme: IconThemeData(
              color: Colors.white,
            ), // Set default icon color
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
