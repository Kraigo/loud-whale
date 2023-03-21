import 'package:flutter/material.dart';
import 'package:mastodon/base/database.dart';
import 'package:mastodon/base/routes.dart';
import 'package:mastodon/base/store_key.dart';
import 'package:mastodon/helpers/format_bytes.dart';
import 'package:mastodon/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  int size = 0;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadInitial);
  }

  _onLogout() async {
    await Navigator.of(context).pushNamed(Routes.logout);
  }

  _onCleanCache() async {
    setState(() {
      loading = true;
    });
    final database = context.read<AppDatabase>();

    try {
      await database.attachmentDao.deleteAllAttachments();
      await database.notificationDao.deleteAllNotifications();
      await database.relationshipDao.deleteAllRelationships();
      await database.statusDao.deleteAllHomeStatuses();
      await database.statusDao.deleteAllStatuses();
      await database.accountDao.deleteAllAccounts();
      await database.settingDao.vacuum();
    } catch (e) {
      debugPrint('Failed to clean cache');
    }
    await _loadInitial();
    setState(() {
      loading = false;
    });
  }

  Future<void> _loadInitial() async {
    final info =
        await context.read<AppDatabase>().settingDao.findDatabaseSize();
    setState(() {
      size = info?.size ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ListTile(
              tileColor: Theme.of(context).cardColor,
              title: const Text("Clean cache"),
              subtitle: Text('Database size ${formatBytes(size, 2)}'),
              leading: loading
                  ? const LoadingIcon()
                  : const Icon(Icons.cleaning_services),
              onTap: _onCleanCache,
            ),
            const _DarkThemeOption(),
            ListTile(
              tileColor: Theme.of(context).cardColor,
              title: const Text("Logout"),
              leading: const Icon(Icons.logout),
              onTap: _onLogout,
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingIcon extends StatelessWidget {
  const LoadingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ));
  }
}

class _DarkThemeOption extends StatelessWidget {
  final storageKey = StorageKeys.accessabilityDarkMode;

  const _DarkThemeOption({super.key});

  _onToggleTheme(BuildContext context) async {
    final settingsProvider = context.read<SettingsProvider>();
    await settingsProvider.updateSettingValue(
        storageKey, settingsProvider.isDarkEnabled ? '' : 'dark');
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    return ListTile(
      tileColor: Theme.of(context).cardColor,
      title: Text("Toggle Theme"),
      subtitle: settingsProvider.isDarkEnabled
          ? const Text("Dark theme enabled")
          : const Text("Light theme enabled"),
      leading: settingsProvider.isDarkEnabled
          ? const Icon(Icons.mode_night_outlined)
          : const Icon(Icons.sunny),
      onTap: () => _onToggleTheme(context),
    );
  }
}
