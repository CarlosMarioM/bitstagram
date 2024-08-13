import 'dart:convert';

import 'package:bitstagram/supabase/media_service.dart';
import 'package:bitstagram/supabase/supa_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

import '../models/user.dart';
import '../repository/user_repository.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  final MediaService _mediaService = MediaService();
  User? _user;

  User? get user => _user;

  Map<String, User> _users = {};
  Map<String, User> get users => _users;

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

  Future<User> fetchUserById(String id, String postId) async {
    final user = await _userRepository.getUserById(id);
    if (user == null) {
      return User.empty;
    } else {
      users[postId] = user;
      notifyListeners();
      return user;
    }
  }

  Future<String?> updateUserInfo({
    required String storagePath,
    required String nickname,
    required XFile file,
  }) async {
    try {
      final photoUrl =
          await _mediaService.uploadMediaAccountPicture(storagePath, file);
      final user = await _userRepository.updateUserInfo(
        storagePath: storagePath,
        nickname: nickname,
        photoUrl: photoUrl,
      );
      _user = user;
      supaAuth.currentUser = _user ?? User.empty;
      notifyListeners();
      return null;
    } on supa.PostgrestException catch (e) {
      final message = jsonDecode(e.message);
      return message["message"];
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
