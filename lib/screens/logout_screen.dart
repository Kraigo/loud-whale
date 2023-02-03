import 'package:flutter/material.dart';
import 'package:mastodon/base/routes.dart';
import 'package:mastodon/providers/authorization_provider.dart';
import 'package:provider/provider.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  @override
  void initState() {
    super.initState();
    _logout();
  }

  _logout() async {
    await context.read<AuthorizationProvider>().removeAuthorization();
    await Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.start, ModalRoute.withName(Routes.start));
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
