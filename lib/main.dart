import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mastodon/providers/mastodon_provider.dart';
import 'package:mastodon/providers/timeline_provider.dart';
import 'package:provider/provider.dart';

import 'base/database.dart';
import 'base/keys.dart';
import 'base/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final database = await $FloorAppDatabase.databaseBuilder(dotenv.get('DATABASE_NAME')).build();

  runApp(MultiProvider(
    providers: [
      Provider.value(value: database),
      ChangeNotifierProvider(
        create: (context) => MastodonProvider(
          clientId: dotenv.get('MASTODON_CLIENT_ID'),
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => TimelineProvider(
          statusDao: database.statusDao
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
