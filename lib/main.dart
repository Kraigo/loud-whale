import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mastodon/providers/authorization_provider.dart';
import 'package:mastodon/providers/timeline_provider.dart';
import 'package:mastodon/screens/start_screen.dart';
import 'package:provider/provider.dart';

import 'base/database.dart';
import 'base/keys.dart';
import 'base/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final database = await $FloorAppDatabase
      .databaseBuilder(dotenv.get('DATABASE_NAME'))
      .build();

  runApp(MultiProvider(
    providers: [
      Provider.value(value: database),
      ChangeNotifierProvider(
        create: (context) => AuthorizationProvider(
          clientId: dotenv.get('MASTODON_CLIENT_ID'),
          clientSecret: dotenv.get('MASTODON_CLIENT_SECRET'),
          settingDao: database.settingDao,
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => TimelineProvider(
          statusDao: database.statusDao,
          accountDao: database.accountDao,
          attachmentDao: database.attachmentDao
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
      // initialRoute: Routes.login,
      home: const StartScreen(),
    );
  }
}
