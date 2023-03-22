import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mastodon/base/store_key.dart';
import 'package:mastodon/providers/authorization_provider.dart';
import 'package:mastodon/providers/compose_provider.dart';
import 'package:mastodon/providers/home_provider.dart';
import 'package:mastodon/providers/notifications_provider.dart';
import 'package:mastodon/providers/profile_provider.dart';
import 'package:mastodon/providers/search_providers.dart';
import 'package:mastodon/providers/settings_provider.dart';
import 'package:mastodon/providers/thread_provider.dart';
import 'package:mastodon/providers/timeline_provider.dart';
import 'package:mastodon/screens/start_screen.dart';
import 'package:provider/provider.dart';

import 'base/database.dart';
import 'base/routes.dart';
import 'base/theme.dart';

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
          accountDao: database.accountDao,
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => TimelineProvider(
          statusDao: database.statusDao,
          accountDao: database.accountDao,
          attachmentDao: database.attachmentDao,
          timelineDao: database.timelineDao,
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => ComposeProvider(
          statusDao: database.statusDao,
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => NotificationsProvider(
          notificationDao: database.notificationDao,
          timelineDao: database.timelineDao,
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => ThreadProvider(
          statusDao: database.statusDao,
          timelineDao: database.timelineDao,
        ),
      ),
      ChangeNotifierProvider(create: (context) => HomeProvider()),
      ChangeNotifierProvider(
        create: (context) => ProfileProvider(
          accountDao: database.accountDao,
          relationshipDao: database.relationshipDao,
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => SettingsProvider(
          settingDao: database.settingDao,
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => SearchProvider(
          accountDao: database.accountDao,
          statusDao: database.statusDao,
          timelineDao: database.timelineDao,
        ),
      ),
    ],
    child: const MastodonApp(),
  ));
}

class MastodonApp extends StatelessWidget {
  const MastodonApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkEnabled = context
            .watch<SettingsProvider>()
            .getSettingValue(StorageKeys.accessabilityDarkMode)
            ?.isNotEmpty ??
        false;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0x003088d4),
        appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        // colorScheme: ColorSwatch(const Color(0x003088d4)),
        appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
      ),
      themeMode: isDarkEnabled ? ThemeMode.dark : ThemeMode.light,
      onGenerateRoute: Routes.onGenerateRoute,
      home: const StartScreen(),
    );
  }
}
