import 'package:bitstagram/supabase/media_service.dart';
import 'package:bitstagram/supabase/supa_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user.dart';
import '../repository/user_repository.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  final MediaService _mediaService = MediaService();
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

  Future<User> fetchUserById(String id) async {
    _user = await _userRepository.getUserById(id);

    notifyListeners();
    if (_user == null) {
      return User.empty;
    } else {
      return _user!;
    }
  }

  Future<void> updateUserInfo({
    required String storagePath,
    required String nickname,
    String? phone,
    required XFile file,
  }) async {
    try {
      final photoUrl =
          await _mediaService.uploadMediaAccountPicture(storagePath, file);
      final user = await _userRepository.updateUserInfo(
        storagePath: storagePath,
        nickname: nickname,
        phone: phone,
        photoUrl: photoUrl,
      );
      _user = user;
      notifyListeners();
    } catch (e) {
      print('Error updating user info: $e');
    }
  }

  Future<(String, XFile)?> pickAccountImage() async {
    final (String, XFile)? response = await _mediaService.pickImage();
    if (response == null) {
      throw Exception("image is null");
    } else {
      return response;
    }
  }
}
