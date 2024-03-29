import 'package:flutter/material.dart';
import 'package:polaris_suite_app/utils/routes/routes_name.dart';
import 'package:polaris_suite_app/view/forgot_password_screen.dart';
import 'package:polaris_suite_app/view/login_screen.dart';
import 'package:polaris_suite_app/view/reset_password_screen.dart';
import 'package:polaris_suite_app/view/screens/bottom_nav_screen.dart';
import 'package:polaris_suite_app/view/signup_screen.dart';
import 'package:polaris_suite_app/view/splash_screen.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SplashScreen(),
        );
      case RoutesName.login:
        return MaterialPageRoute(
          builder: (BuildContext context) => const LoginScreen(),
        );
      case RoutesName.signup:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SignUpScreen(),
        );
      case RoutesName.forgotPassword:
        return MaterialPageRoute(
          builder: (BuildContext context) => const ForgotPasswordScreen(),
        );
      case RoutesName.resetPassword:
        return MaterialPageRoute(
          builder: (BuildContext context) => const ResetPasswordScreen(),
        );
      case RoutesName.bottomNavBar:
        return MaterialPageRoute(
          builder: (BuildContext context) => const BottomNavScreen(),
        );
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text("No Route Defined"),
            ),
          );
        });
    }
  }
}
