import 'package:declarative_navigation/db/auth_repository.dart';
import 'package:declarative_navigation/model/user.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthProvider(this._authRepository);

  bool isLoadingLogin = false;
  bool isLoadingRegister = false;
  bool isLoadingLogout = false;
  bool isLoggedIn = false;

  // login trigger method
  Future<bool> logIn(User user) async {
    isLoadingLogin = true;
    notifyListeners();

    final userState = await _authRepository.getUser();
    print(userState);
    if (user == userState) {
      await _authRepository.logIn();
    }

    isLoggedIn = await _authRepository.isLoggedIn();
    isLoadingLogin = false;
    notifyListeners();

    return isLoggedIn;
  }

  // logout trigger method
  Future<bool> logOut() async {
    isLoadingLogout = true;
    notifyListeners();

    final userState = await _authRepository.logOUt();
    if (userState) {
      await _authRepository.deleteUser();
    }

    isLoggedIn = await _authRepository.isLoggedIn();
    isLoadingLogout = false;

    return !isLoggedIn;
  }

  // register trigger method
  Future<bool> saveUser(User user) async {
    isLoadingRegister = true;
    notifyListeners();

    final userState = await _authRepository.saveUser(user);

    isLoadingRegister = false;
    notifyListeners();

    return userState;
  }
}
