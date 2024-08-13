import 'package:bitstagram/supabase/supa_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

import '../models/user.dart';

class UserRepository {
  Future<User?> createUser(
      {required User user, required Function(String) errorCallback}) async {
    try {
      final userMap = await supaAuth.client
          .from('users')
          .insert({"email": user.email, "password": user.password})
          .select()
          .single();

      // ignore: no_leading_underscores_for_local_identifiers
      final _user = User.fromMap(userMap);
      supaAuth.currentUser = _user;
      await supaAuth.signup(user.email, user.password);
      return _user;
    } on supa.PostgrestException catch (e) {
      errorCallback(e.message);
    } on supa.AuthApiException catch (e) {
      errorCallback(e.message);
    }
    return null;
  }

  Future<void> signOut() async {
    await supaAuth.client.auth.signOut();
    supaAuth.authController
        .add(supa.AuthState(supa.AuthChangeEvent.signedOut, null));
  }

  Future<User?> login(
      {required String email,
      required String password,
      required Function(String) errorCallback}) async {
    try {
      final user = await supaAuth.client
          .from('users')
          .select()
          .eq('email', email)
          .eq("password", password)
          .single()
          .then((value) => User.fromMap(value));
      supaAuth.currentUser = user;
      await supaAuth.login(email, password);
      return user;
    } on supa.PostgrestException catch (e) {
      errorCallback(e.message);
    } on supa.AuthApiException catch (e) {
      errorCallback(e.message);
    }
    return null;
  }

  Future<User?> getUserById(String id) async {
    try {
      final response =
          await supaAuth.client.from('users').select().eq('id', id).single();

      final user = User.fromMap(response);

      return user;
    } on supa.PostgrestException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<User?> updateUserInfo({
    required String storagePath,
    required String nickname,
    String? photoUrl,
  }) async {
    final response = await supaAuth.client
        .from('users')
        .update({
          'nickname': nickname,
          'photo_url': photoUrl,
        })
        .eq('id', supaAuth.currentUser.id!)
        .select()
        .maybeSingle();

    if (response == null) {
      throw Exception('Failed to update user info');
    } else {
      return User.fromMap(response);
    }
  }
}
