// cubit/auth/auth_state.dart
import 'package:job_board/features/auth/data/models/user_model.dart';
import 'package:job_board/features/auth/data/repo/auth_repo.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class loggedInSuccess extends AuthState {
  final UserModel user;

  loggedInSuccess(this.user);
}
class registeredSuccess extends AuthState {

  registeredSuccess();
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}
