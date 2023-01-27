import 'package:flutter/material.dart';
import 'package:mastodon/helpers/mastodon_helper.dart';
import 'package:mastodon/providers/authorization_provider.dart';
import 'package:mastodon/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../base/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController instanceTextController;

  @override
  void initState() {
    instanceTextController = TextEditingController(text: 'mstdn.social');
    Future.microtask(_checkAuthorization);
    super.initState();
  }

  @override
  void dispose() {
    instanceTextController.dispose();
    super.dispose();
  }

  _checkAuthorization() async {
    final authorizationProvider = context.read<AuthorizationProvider>();
    final router = Navigator.of(context);

    await authorizationProvider.checkAuthorization();

    if (authorizationProvider.isAuthorized) {
      await router.pushNamed(Routes.timeline);
    }
  }

  _onLogin() async {
    final authorizationProvider = context.read<AuthorizationProvider>();
    final router = Navigator.of(context);
    final instanceName = instanceTextController.text;

    authorizationProvider.openLogin(instanceName);

    final code = await showDialog(
      context: context,
      builder: (context) {
        return const PromptDialog();
      },
    );

    if (code != null) {
      final token = await authorizationProvider.getToken(instanceName, code);

      if (token != null) {
        await authorizationProvider.setAuthorization(Authorization(
          token: token.accessToken,
          instance: instanceName,
        ));
        await router.pushNamed(Routes.timeline);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        TextField(
          controller: instanceTextController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter a search term',
          ),
        ),
        ElevatedButton(
            onPressed: isDisabled ? null : _onLogin,
            child: const Text("Login")),
      ]),
    );
  }

  bool get isDisabled {
    return context.read<AuthorizationProvider>().loading ||
        instanceTextController.text.isEmpty;
  }
}
