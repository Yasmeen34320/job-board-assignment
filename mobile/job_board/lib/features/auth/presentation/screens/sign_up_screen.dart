import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_board/features/auth/presentation/component/custom_input_label_form.dart';
import 'package:job_board/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:job_board/features/auth/presentation/cubit/auth_state.dart';
import 'package:job_board/features/auth/presentation/screens/log_in_screen.dart';

import 'package:lottie/lottie.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  File? selectedImage;
  String? base64Image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is registeredSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Registration successful!")));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LogInScreen()),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) => Stack(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(color: const Color(0xFF4F4AD3)),
            ),
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              // left:
              //     MediaQuery.of(context).size.width / 2 -
              //     'Welcome to My App'.length,
              child: Center(
                child: Text(
                  'Welcome to Our App',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    letterSpacing: 3,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Lottie.asset(
                  'assets/No Job Vacancies (1).json',
                  width: 350,
                  height: 350,
                ),
              ),
            ),
            Positioned.fill(
              top: 400,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 238, 236, 236),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 20,
                      offset: Offset(0, 5),
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60.0),
                    topRight: Radius.circular(60.0),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 25),
                          CustomInputLabelForm(
                            hintText: 'Enter your full name',
                            label: 'Full Name',
                            validator: (String? value) {
                              return null;
                            },
                            controller: _usernameController,
                            isPassword: false,
                          ),
                          SizedBox(height: 25),

                          CustomInputLabelForm(
                            hintText: 'Enter your email',
                            label: 'Email',
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'this field if required';
                              } else if (!emailRegExp.hasMatch(value)) {
                                return 'please enter a valid email';
                              }
                              return null;
                            },
                            controller: _emailController,
                            isPassword: false,
                          ),
                          SizedBox(height: 25),
                          CustomInputLabelForm(
                            hintText: 'Enter your password',
                            label: 'Password',
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'this field is required';
                              } else if (value.length < 6) {
                                return 'please enter at least 6 characters';
                              }
                              return null;
                            },
                            controller: _passwordController,
                            isPassword: true,
                          ),
                          SizedBox(height: 25),

                          ElevatedButton(
                            onPressed: () async {
                              if ((_formKey.currentState?.validate() ??
                                  false)) {
                                context.read<AuthCubit>().signup(
                                  _emailController.text,
                                  _passwordController.text,
                                  _usernameController.text,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: Color(0xFF4F4AD3),
                              foregroundColor: Color(0xFFFFFCFC),
                              textStyle: GoogleFonts.poppins(
                                fontSize: 22,
                                letterSpacing: 3,
                              ),
                              fixedSize: Size(400, 48),
                            ),
                            child: Text('Sign Up'),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'have an account ?',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return LogInScreen();
                                      },
                                    ),
                                  );
                                },
                                child: Text(
                                  'Log In',
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
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
