import 'package:flutter/material.dart';
import 'package:mastodon/base/database.dart';
import 'package:mastodon/base/routes.dart';
import 'package:mastodon/providers/authorization_provider.dart';
import 'package:provider/provider.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  @override
  void initState() {
    super.initState();
    _logout();
  }

  _logout() async {
    final database = context.read<AppDatabase>();
    final navigator = Navigator.of(context);
    await context.read<AuthorizationProvider>().removeAuthorization();

    await database.attachmentDao.deleteAllAttachments();
    await database.notificationDao.deleteAllNotifications();
    await database.relationshipDao.deleteAllRelationships();
    await database.settingDao.deleteAllSettings();
    await database.statusDao.deleteAllHomeStatuses();
    await database.statusDao.deleteAllStatuses();
    await database.accountDao.deleteAllAccounts();
    await database.settingDao.vacuum();

    await navigator.pushNamedAndRemoveUntil(
        Routes.start, ModalRoute.withName(Routes.start));
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
