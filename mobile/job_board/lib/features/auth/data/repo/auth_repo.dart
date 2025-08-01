import 'package:hive/hive.dart';
import 'package:job_board/features/auth/data/models/user_model.dart';
import 'package:uuid/uuid.dart';

class MockAuthRepository {
  final _uuid = Uuid();
  late Box<UserModel> _userBox;

  MockAuthRepository() {
    _userBox = Hive.box<UserModel>('users');

    // Add admin only if not exists
    if (_userBox.values.every((u) => u.email != 'admin@admin.com')) {
      _userBox.add(
        UserModel(
          id: '1',
          fullName: 'Admin User',
          email: 'admin@admin.com',
          password: 'admin123',
          role: 'admin',
        ),
      );
    }
  }

  Future<UserModel?> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final user = _userBox.values.firstWhere(
      (u) => u.email == email.toLowerCase() && u.password == password,
      orElse: () => throw Exception("Invalid credentials"),
    );
    final sessionBox = await Hive.openBox('sessionBox');
    await sessionBox.put('currentUserId', user.id);

    return user;
  }

  Future<UserModel> signup(
    String email,
    String password,
    String fullName,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final exists = _userBox.values.any((u) => u.email == email.toLowerCase());
    if (exists) throw Exception("Email already exists");

    final newUser = UserModel(
      id: _uuid.v4(),
      fullName: fullName,
      email: email.toLowerCase(),
      password: password,
      role: 'jobseeker',
    );

    await _userBox.add(newUser);

    final sessionBox = await Hive.openBox('sessionBox');
    await sessionBox.put('currentUserId', newUser.id);

    return newUser;
  }

  Future<UserModel?> getCurrentUser() async {
    final sessionBox = await Hive.openBox('sessionBox');
    final userId = sessionBox.get('currentUserId');
    if (userId == null) return null;
    try {
      return _userBox.values.firstWhere((u) => u.id == userId);
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    final sessionBox = await Hive.openBox('sessionBox');
    await sessionBox.clear();
  }
}
