import 'package:flutter/material.dart';
import 'package:mastodon/providers/notifications_provider.dart';
import 'package:mastodon/widgets/widgets.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    Future.microtask(_loadInitial);
    super.initState();
  }

  _loadInitial() async {
    final notificationsProvider = context.read<NotificationsProvider>();
    await notificationsProvider.refresh();
    await notificationsProvider.loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<NotificationsProvider>().notifications;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(3.0),
            child: _NotificationsLoading(),
          ),
        ),
        body: ListView.separated(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final item = notifications[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: NotificationCard(item),
            );
          },
          separatorBuilder: (context, index) =>
              const MiddleContainer(Divider()),
        ));
  }
}

class _NotificationsLoading extends StatelessWidget {
  const _NotificationsLoading();

  @override
  Widget build(BuildContext context) {
    final notificationsProvider = context.watch<NotificationsProvider>();
    if (notificationsProvider.loading) {
      return const LinearProgressIndicator();
    }
    return Container();
  }
}
