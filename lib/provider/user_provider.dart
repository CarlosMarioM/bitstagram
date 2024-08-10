import 'package:flutter/material.dart';

import '../models/user.dart';
import '../repository/user_repository.dart';

class PostProvider with ChangeNotifier {
  bool _like = false;
  bool get like => _like;
  void likePressed() {
    _like = !_like;
    notifyListeners();
  }
}

class UserProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  User? _user;

  User? get user => _user;

  Future<void> createUser(
      {required User user, required Function(String) errorCallback}) async {
    _user = await _userRepository.createUser(
        user: user, errorCallback: errorCallback);
    notifyListeners();
  }

  Future<void> signOut() async {
    _user = null;
    await _userRepository.signOut();
    notifyListeners();
  }

  Future<void> login(
      {required String email,
      required String password,
      required Function(String) errorCallback}) async {
    _user = await _userRepository.login(
        email: email, password: password, errorCallback: errorCallback);
    notifyListeners();
  }

  Future<void> fetchUserById(String id) async {
    _user = await _userRepository.getUserById(id);
    notifyListeners();
  }
}
