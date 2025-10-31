import 'package:declarative_navigation/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final String stateKey = 'state';
  final String userKey = 'user';

  // user state use case
  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.getBool(stateKey) ?? false;
  }

  // log in usecase
  Future<bool> logIn() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setBool(stateKey, true);
  }

  // log out usecase
  Future<bool> logOUt() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setBool(stateKey, false);
  }

  // save user method
  Future<bool> saveUser(User user) async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(userKey, user.toJson());
  }

  // delete user method
  Future<bool> deleteUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(userKey, '');
  }

  // get user method
  Future<User?> getUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    final json = preferences.getString(userKey);

    User? user;
    try {
      user = User.fromJson(json ?? '');
    } catch (e) {
      user = null;
    }
    return user;
  }
}
