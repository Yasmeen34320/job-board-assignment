import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_board/features/auth/data/models/user_model.dart';
import 'package:job_board/features/auth/data/repo/auth_repo.dart';
import 'package:job_board/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final MockAuthRepository authRepo;

  AuthCubit(this.authRepo) : super(AuthInitial());

  UserModel? get currentUser {
    if (state is loggedInSuccess) {
      return (state as loggedInSuccess).user;
    } else {
      return null;
    }
  }

  getCurrentUser() async {
    emit(AuthLoading());
    try {
      final user = await authRepo.getCurrentUser();
      if (user != null) {
        emit(loggedInSuccess(user));
      } else {
        emit(AuthFailure("No user logged in"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await authRepo.login(email, password);
      emit(loggedInSuccess(user!));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void signup(String email, String password, String fullName) async {
    emit(AuthLoading());
    try {
      final user = await authRepo.signup(email, password, fullName);
      emit(registeredSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void logout() async {
    emit(AuthLoading());
    try {
      await authRepo.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // void getAllUsers() async {
  //   emit(AuthLoading());
  //   try {
  //     final users = authRepo.getAllUsers();
  //     emit(AuthSuccess(users as List<UserModel>));
  //   } catch (e) {
  //     emit(AuthFailure(e.toString()));
  //   }
  // }
}
