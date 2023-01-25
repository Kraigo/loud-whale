import 'package:flutter/material.dart';
import 'package:mastodon/providers/mastodon_provider.dart';
import 'package:provider/provider.dart';

import 'base/keys.dart';
import 'base/routes.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => MastodonProvider(),
      ),
    ],
    child: MastodonApp(),
  ));
}

class MastodonApp extends StatelessWidget {
  const MastodonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: AppKeys.navigatorKey,
      onGenerateRoute: Routes.onGenerateRoute,
      initialRoute: Routes.login,
    );
  }
}
