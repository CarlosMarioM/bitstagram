import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../supabase/supa_auth.dart';
import '../views/bottom_bar/bottom_bar_page.dart';
import '../views/login/login_page.dart';
import '../views/splash/loading_splash_page.dart';

class AuthStateWrapper extends StatelessWidget {
  const AuthStateWrapper({Key? key}) : super(key: key);
  static const String route = "/";
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: supaAuth.authStream,
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingSplashPage();
        }
        if (snapshot.hasData) {
          if (snapshot.hasData && snapshot.data?.session != null) {
            if (snapshot.data!.event == AuthChangeEvent.signedIn) {
              return const BottomBarPage();
            }
          }
        }
        return const LoginPage();
      }),
    );
  }
}
