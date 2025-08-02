import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_board/features/auth/presentation/component/custom_input_label_form.dart';
import 'package:job_board/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:job_board/features/auth/presentation/cubit/auth_state.dart';
import 'package:job_board/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:job_board/features/home_jobs/presentation/screens/main_navigation_screen.dart';
import 'package:job_board/features/home_jobs/test.dart';
import 'package:lottie/lottie.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({super.key});
  final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Container(
                  width: double.infinity,
                  color: const Color(0xFF4F4AD3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        'Welcome back',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          letterSpacing: 3,
                          fontSize: 24,
                        ),
                      ),
                      Lottie.asset(
                        'assets/No Job Vacancies (1).json',
                        width: 300,
                        height: 300,
                      ),
                      Container(
                        width: double.infinity,

                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 238, 236, 236),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(60.0),
                            topRight: Radius.circular(60.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(30),
                        child: BlocConsumer<AuthCubit, AuthState>(
                          listener: (context, state) {
                            if (state is loggedInSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Logged in successfully!"),
                                ),
                              );
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MainNavigationScreen(
                                    role: state.user.role,
                                  ),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            } else if (state is AuthFailure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.error)),
                              );
                            }
                          },
                          builder: (context, state) {
                            return Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  CustomInputLabelForm(
                                    hintText: 'Enter your email',
                                    label: 'Email',
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This field is required';
                                      } else if (!emailRegExp.hasMatch(value)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                    controller: _emailController,
                                    isPassword: false,
                                  ),
                                  const SizedBox(height: 25),
                                  CustomInputLabelForm(
                                    hintText: 'Enter your password',
                                    label: 'Password',
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This field is required';
                                      } else if (value.length < 6) {
                                        return 'Please enter at least 6 characters';
                                      }
                                      return null;
                                    },
                                    controller: _passwordController,
                                    isPassword: true,
                                  ),
                                  const SizedBox(height: 25),
                                  if (state is AuthLoading)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Color(0xFF4F4AD3),
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Logging in...',
                                          style: GoogleFonts.poppins(
                                            color: Color(0xFF4F4AD3),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<AuthCubit>().login(
                                            _emailController.text,
                                            _passwordController.text,
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        backgroundColor: const Color(
                                          0xFF4F4AD3,
                                        ),
                                        foregroundColor: Colors.white,
                                        fixedSize: const Size(400, 48),
                                      ),
                                      child: Text(
                                        'Log In',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Don't have an account?",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => SignUpScreen(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Sign Up',
                                          style: GoogleFonts.poppins(
                                            color: Color(0xFF4F4AD3),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
