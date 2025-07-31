import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_board/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:job_board/features/auth/presentation/cubit/auth_state.dart';
import 'package:job_board/features/auth/presentation/screens/log_in_screen.dart';
import 'package:job_board/features/home_jobs/presentation/screens/main_navigation_screen.dart';
import 'package:job_board/features/home_jobs/test.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is loggedInSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => MainNavigationScreen(role: state.user.role),
              ),
            );
          } else if (state is AuthFailure || state is registeredSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LogInScreen()),
            );
          }
        },
        child: Center(
          child: Lottie.asset(
            'assets/hiring.json',
            width: 300,
            height: 300,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
