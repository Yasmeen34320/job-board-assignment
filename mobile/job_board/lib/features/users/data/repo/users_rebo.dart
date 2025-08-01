import 'package:hive/hive.dart';
import 'package:job_board/features/auth/data/models/user_model.dart';

class UsersRepository {
  final users = Hive.box<UserModel>('users');
  Future<List<UserModel>> getAllUsers() async {
    return users.values.toList();
  }

  Future<void> addNewAdmin(UserModel admin) async {
    await users.put(admin.id, admin);
  }
}
