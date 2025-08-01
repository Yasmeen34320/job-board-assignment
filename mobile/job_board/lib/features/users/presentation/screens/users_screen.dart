import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_board/core/services/service_locator.dart';
import 'package:job_board/features/users/data/repo/users_rebo.dart';
import 'package:job_board/features/users/presentation/components/show_add_admin_sheet.dart';
import 'package:job_board/features/users/presentation/cubit/users_cubit.dart';
import 'package:job_board/features/users/presentation/cubit/users_state.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UsersCubit(locator<UsersRepository>())..getAllUsers(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Users',
            style: GoogleFonts.poppins(color: Colors.white, letterSpacing: 2),
          ),
        ),
        body: Center(
          child: BlocBuilder<UsersCubit, UsersState>(
            builder: (context, state) {
              if (state is UsersLoading) {
                return CircularProgressIndicator();
              } else if (state is UsersLoaded) {
                return Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Admins',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          final user = state.adminUsers[index];
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              child: Text(user.fullName[0]),
                            ),
                            title: Text(
                              user.fullName,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              user.email,
                              style: GoogleFonts.poppins(
                                // fontSize: 16,
                                letterSpacing: 1.2,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemCount: state.adminUsers.length,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        showAddAdminSheet(context);
                      },
                      icon: const Icon(Icons.add),
                      label: Text(
                        'Add Admin',
                        style: GoogleFonts.poppins(
                          letterSpacing: 1.2,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F4AD3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    Divider(),
                    SizedBox(height: 20),
                    Text(
                      'Job Seekers',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: state.users.length,
                        itemBuilder: (context, index) {
                          final user = state.users[index];
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 30,

                              child: Text(user.fullName[0]),
                            ),
                            title: Text(
                              user.fullName,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              user.email,
                              style: GoogleFonts.poppins(
                                // fontSize: 16,
                                letterSpacing: 1.2,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(),
                      ),
                    ),
                  ],
                );
              } else if (state is UsersError) {
                return Text('Error: ${state.message}');
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
