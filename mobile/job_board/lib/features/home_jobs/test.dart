import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_board/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:job_board/features/auth/presentation/screens/log_in_screen.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Add your admin functionality here
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text('Admin functionality not implemented')),
            // );
            context.read<AuthCubit>().logout();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LogInScreen()),
            );
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
