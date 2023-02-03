import 'package:flutter/material.dart';
import 'package:mastodon/base/routes.dart';
import 'package:mastodon/providers/authorization_provider.dart';
import 'package:mastodon/screens/home_screen.dart';
import 'package:mastodon/screens/login_screen.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  _checkLogin() async {
    final authorizationProvider = context.read<AuthorizationProvider>();
    final router = Navigator.of(context);

    await authorizationProvider.checkAuthorization();

    if (authorizationProvider.isAuthorized) {
      router.pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return child;
            },
          ),
          ModalRoute.withName(Routes.home));
    } else {
      router.pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        ),
        ModalRoute.withName(Routes.login),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
