import 'package:flutter/material.dart';
import 'package:mastodon/providers/mastodon_provider.dart';
import 'package:mastodon/widgets/widgets.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final mastodonProvider = context.watch<MastodonProvider>();
    return Scaffold(
      body: Column(children: [
        TextField(
          controller: instanceTextController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter a search term',
          ),
        ),
        ElevatedButton(
            onPressed: isDisabled
                ? null
                : () async {
                    final instanceName = instanceTextController.text;
                    mastodonProvider.openLogin(instanceName);

                    final result = await showDialog(
                      context: context,
                      builder: (context) {
                        return const PromptDialog();
                      },
                    );

                    if (result != null) {
                      mastodonProvider.init(
                        instance: instanceName,
                        token: result,
                      );
                      // AppKeys.navigatorKey.currentState!.pushNamed(Routes.library);
                    }
                  },
            child: Text("Login")),
      ]),
    );
  }

  bool get isDisabled {
    return context.read<MastodonProvider>().loading ||
        instanceTextController.text.isEmpty;
  }
}
