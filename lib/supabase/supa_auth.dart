import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

import '../models/user.dart';
import 'my_supabase.dart';

final supaAuth = SupaAuth._();

class SupaAuth extends MySupaBase {
  SupaAuth._() {
    authChanges;
  }
  User currentUser = User.empty;

  StreamController<supa.AuthState> authController =
      StreamController.broadcast();

  late Stream<supa.AuthState> authStream = authController.stream;

  StreamSubscription<supa.AuthState> get authChanges =>
      client.auth.onAuthStateChange.listen((data) => authController.add(data));

  Future<void> signup(String email, String password) async {
    try {
      await client.auth.signUp(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<supa.AuthResponse> login(String email, String password) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    try {
      final map = await client
          .from('users')
          .select()
          .eq("email", email)
          .eq("password", password)
          .single();

      final user = User.fromMap(map);
      currentUser = User(
          id: user.id,
          nickname: user.nickname,
          photoUrl: user.photoUrl,
          phone: user.phone,
          email: response.user!.email!,
          password: password,
          createdAt: DateTime.parse(response.user!.createdAt));
      return response;
    } catch (e) {
      return supa.AuthResponse(session: null, user: null);
    }
  }
}
