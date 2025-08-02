import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_board/features/auth/data/models/user_model.dart';
import 'package:job_board/features/users/data/repo/users_rebo.dart';
import 'package:job_board/features/users/presentation/cubit/users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final UsersRepository usersRepo;

  UsersCubit(this.usersRepo) : super(UsersInitial());

  void getAllUsers() async {
    emit(UsersLoading());
    try {
      var users = await usersRepo.getAllUsers();

      final adminUsers = users.where((u) => u.role == 'admin').toList();
      users = users.where((u) => u.role != 'admin').toList();
      emit(UsersLoaded(users, adminUsers));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> addnewAdmin(UserModel admin) async {
    await usersRepo.addNewAdmin(admin);
  }

  Future<void> removeAdmin(UserModel admin) async {
    await usersRepo.removeAdmin(admin);
  }
}
