import 'package:flutter/material.dart';
import 'package:mastodon/screens/login_screen.dart';

class Routes {
  static const home = '/';
  static const login = '/login';

  static Route onGenerateRoute(RouteSettings settings) {
    Map<String, dynamic>? pageArguments;

    if (settings.arguments != null) {
      pageArguments = settings.arguments as Map<String, dynamic>;
    }
    
    var routes = <String, WidgetBuilder>{
      Routes.login: (context) => const LoginScreen(),
    };
    
    WidgetBuilder builder = routes[settings.name] ?? routes.values.first;

    return MaterialPageRoute(
      builder: (ctx) => builder(ctx),
      settings: settings,
    );
  }
}
