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
import 'package:job_board/features/home_jobs/test.dart';
import 'package:job_board/features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('users');
  await Hive.openBox('sessionBox');
  Hive.registerAdapter(JobAdapter());
  await Hive.openBox<Job>('jobs');
  setupLocator(); // ⬅ Initialize your service locator
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AuthCubit(locator<MockAuthRepository>())..getCurrentUser(),
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

        // home: BlocBuilder<AuthCubit, AuthState>(
        //   builder: (context, state) {
        //     if (state is AuthLoading) {
        //       return Center(child: CircularProgressIndicator());
        //     } else if (state is AuthSuccess) {
        //       return Test(); // Assuming this is the admin screen
        //       //return HomeScreen(user: state.user);
        //     } else {
        //       return LogInScreen();
        //     }
        //   },
      ),
    );
  }
}
