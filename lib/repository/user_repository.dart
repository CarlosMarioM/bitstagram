import 'package:bitstagram/supabase/supa_auth.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

import '../models/user.dart';

class UserRepository {
  Future<User?> createUser(
      {required User user, required Function(String) errorCallback}) async {
    try {
      await supaAuth.signup(user.email, user.password);
      await supaAuth.client
          .from('users')
          .insert({"email": user.email, "password": user.password});

      final userMap = await supaAuth.client
          .from("users")
          .select()
          .eq("email", user.email)
          .eq("password", user.password)
          .single();

      return User.fromMap(userMap);
    } on supa.PostgrestException catch (e) {
      errorCallback(e.message);
    } on supa.AuthApiException catch (e) {
      errorCallback(e.message);
    }
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
      await supaAuth.login(email, password);
      final user = await supaAuth.client
          .from('users')
          .select()
          .eq('email', email)
          .eq("password", password)
          .single()
          .then((value) => User.fromMap(value));
      return user;
    } on supa.PostgrestException catch (e) {
      errorCallback(e.message);
    } on supa.AuthApiException catch (e) {
      errorCallback(e.message);
    }
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
}
