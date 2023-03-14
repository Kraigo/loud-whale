import 'package:flutter/material.dart';
import 'package:mastodon/providers/authorization_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

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
    super.initState();
  }

  @override
  void dispose() {
    instanceTextController.dispose();
    super.dispose();
  }

  _onLogin() async {
    final instanceName = instanceTextController.text;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TokenScreen(
        instanceName: instanceName,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Text(
            "Mastodon",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(
            height: 40,
          ),
          TextField(
            controller: instanceTextController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter mastodon domain',
                label: Text("Instance")),
          ),
          const SizedBox(
            height: 40,
          ),
          ElevatedButton(
            onPressed: isDisabled ? null : _onLogin,
            child: const Text("Open authorization"),
          ),
        ]),
      ),
    );
  }

  bool get isDisabled {
    return context.read<AuthorizationProvider>().loading ||
        instanceTextController.text.isEmpty;
  }
}

class TokenScreen extends StatefulWidget {
  final String instanceName;
  const TokenScreen({required this.instanceName, super.key});

  @override
  State<TokenScreen> createState() => _TokenScreenState();
}

class _TokenScreenState extends State<TokenScreen> {
  late TextEditingController tokenController;

  @override
  void initState() {
    super.initState();
    tokenController = TextEditingController(text: '');
    context.read<AuthorizationProvider>().openLogin(widget.instanceName);
  }

  @override
  void dispose() {
    tokenController.dispose();
    super.dispose();
  }

  bool get isDisabled {
    return context.read<AuthorizationProvider>().loading ||
        tokenController.text.isEmpty;
  }

  _onLogin() async {
    final authorizationProvider = context.read<AuthorizationProvider>();
    final router = Navigator.of(context);
    final code = tokenController.text;
    final instanceName = widget.instanceName;
    final token = await authorizationProvider.getToken(instanceName, code);

    if (token != null) {
      await authorizationProvider.setAuthorization(Authorization(
        token: token.accessToken,
        instance: instanceName,
      ));
      await authorizationProvider.verifyAccount();
      await router.pushNamed(Routes.start);
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => const Text("Failed to get token"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Token"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    maxLines: 1,
                    controller: tokenController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Paste token here',
                      label: Text("Token"),
                    ),
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.paste),
                  onPressed: () async {
                    final value = await Clipboard.getData(Clipboard.kTextPlain);
                    if (value != null) {
                      tokenController.text = value.text ?? '';
                      setState(() {});
                    }
                  },
                  label: const Text("Paste"),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isDisabled ? null : _onLogin,
                  child: const Text("Login"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
