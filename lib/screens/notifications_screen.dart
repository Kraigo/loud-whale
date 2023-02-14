import 'package:flutter/material.dart';
import 'package:mastodon/enties/entries.dart';
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
            return NotificationCard(item);
          },
          separatorBuilder: ((context, index) {
            return const Divider();
          }),
        ));
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  const NotificationCard(this.notification, {super.key});

  @override
  Widget build(BuildContext context) {
    return MiddleContainer(Column(
      children: [
        if (notification.account != null)
          Row(children: [
            Icon(notificationTypeIcon),
            const SizedBox(
              width: 10,
            ),
            Text(
                '${notification.account?.displayName ?? 'User'} $notificationTypeText')
          ]),
        if (notification.status != null)
          Padding(
            padding: const EdgeInsets.all(8),
            child: StatusCardContent(notification.status!),
          )
      ],
    ));
  }

  String get notificationTypeText {
    switch (notification.type) {
      case 'mention':
        return 'Mentioned you';
      case 'status':
        return '';
      case 'reblog':
        return 'Reblogged your status';
      case 'follow':
        return 'Followed';
      case 'follow_request':
        return 'Follow Request';
      case 'favourite':
        return 'Favourited your status';
      case 'poll':
        return 'poll';
      case 'update':
        return 'update';
      case 'admin.sign_up':
        return 'admin.sign_up';
      case 'admin.report':
        return 'admin.report';
      default:
        return 'Some notification';
    }
  }

  IconData get notificationTypeIcon {
    switch (notification.type) {
      case 'mention':
        return Icons.reply;
      case 'reblog':
        return Icons.repeat;
      case 'follow':
        return Icons.person;
      case 'follow_request':
        return Icons.person;
      case 'favourite':
        return Icons.star;
      default:
        return Icons.notifications;
    }
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
