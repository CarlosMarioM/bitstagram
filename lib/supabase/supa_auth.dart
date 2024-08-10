import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

import '../models/user.dart';
import 'my_supabase.dart';

final supaAuth = SupaAuth._();

class SupaAuth extends MySupaBase {
  SupaAuth._() {
    authChanges;
  }
  late final User currentUser;

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
    return response;
  }
}
