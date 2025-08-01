import 'package:job_board/features/auth/data/models/user_model.dart';

abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<UserModel> users;
  final List<UserModel> adminUsers;

  UsersLoaded(this.users, this.adminUsers);
}

class UsersError extends UsersState {
  final String message;

  UsersError(this.message);
}
