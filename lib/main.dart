import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mastodon/providers/mastodon_provider.dart';
import 'package:provider/provider.dart';

import 'base/keys.dart';
import 'base/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => MastodonProvider(
          clientId: dotenv.get('MASTODON_CLIENT_ID'),
        ),
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
