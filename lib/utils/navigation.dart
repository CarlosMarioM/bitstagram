import 'package:flutter/material.dart';

import '../views/bottom_bar/bottom_bar_page.dart';
import '../views/login/login_page.dart';
import '../views/splash/loading_splash_page.dart';
import '../widgets/auth_state_wrapper.dart';

extension TransitionWidget on Widget {
  PageRouteBuilder routeAnimated() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => this,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Center centerWidget() {
    return Center(child: this);
  }
}

class Navigation {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case AuthStateWrapper.route:
        return const AuthStateWrapper().routeAnimated();
      case LoginPage.route:
        return const LoginPage().routeAnimated();
      case BottomBarPage.route:
        return const BottomBarPage().routeAnimated();
      default:
        return const LoadingSplashPage().routeAnimated();
    }
  }
}
