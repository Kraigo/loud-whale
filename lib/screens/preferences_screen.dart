import 'package:flutter/material.dart';
import 'package:mastodon/base/database.dart';
import 'package:mastodon/base/routes.dart';
import 'package:mastodon/helpers/format_bytes.dart';
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

    await database.accountDao.deleteAllAccounts();
    await database.attachmentDao.deleteAllAttachments();
    await database.notificationDao.deleteAllNotifications();
    await database.relationshipDao.deleteAllRelationships();
    await database.statusDao.deleteAllStatuses();
    await database.settingDao.vacuum();
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
              leading: loading ? const LoadingIcon() : const Icon(Icons.cleaning_services),
              onTap: _onCleanCache,
            ),
            ListTile(
              tileColor: Theme.of(context).cardColor,
              title: const Text("Logout"),
              leading: const Icon(Icons.logout),
              onTap: _onLogout,
            )
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
