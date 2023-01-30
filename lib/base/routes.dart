import 'package:flutter/material.dart';
import 'package:mastodon/screens/login_screen.dart';
import 'package:mastodon/screens/profile_screen.dart';
import 'package:mastodon/screens/thread_screen.dart';
import 'package:mastodon/screens/timeline_screen.dart';

class Routes {
  static const timeline = '/timeline';
  static const login = '/login';
  static const thread = '/thread';
  static const profile = '/profile';

  static Route onGenerateRoute(RouteSettings settings) {
    Map<String, dynamic>? pageArguments;

    if (settings.arguments != null) {
      pageArguments = settings.arguments as Map<String, dynamic>;
    }
    
    var routes = <String, WidgetBuilder>{
      Routes.login: (context) => const LoginScreen(),
      Routes.timeline: (context) => const TimelineScreen(),
      Routes.thread: (context) => ThreadScreen(statusId: pageArguments?['statusId']),
      Routes.profile: (context) => ProfileScreen(accountId: pageArguments?['accountId'])
    };
    
    WidgetBuilder builder = routes[settings.name] ?? routes.values.first;

    return MaterialPageRoute(
      builder: (ctx) => builder(ctx),
      settings: settings,
    );
  }
}
