import 'package:flutter/material.dart';
import 'package:mastodon/base/database.dart';
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
    context.read<NotificationsProvider>().loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(3.0),
            child: _NotificationsLoading(),
          ),
        ),
        body: StreamBuilder<List<NotificationEntity>>(
          initialData: const [],
          stream: context
              .read<AppDatabase>()
              .notificationDao
              .findAllNotifications(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Text("Notifications empty");
            }
            final notificaitons = snapshot.data!;

            return ListView.separated(
              itemCount: notificaitons.length,
              itemBuilder: (context, index) {
                final item = notificaitons[index];
                return NotificationCard(item);
              },
              separatorBuilder: ((context, index) {
                return Divider();
              }),
            );
          },
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
        StreamBuilder(
          stream: context
              .read<AppDatabase>()
              .accountDao
              .findAccountById(notification.accountId),
          builder: (context, snapshot) {
            return Row(children: [
              Icon(notificationTypeIcon),
              SizedBox(
                width: 10,
              ),
              Text(
                  '${snapshot.data?.displayName ?? 'User'} $notificationTypeText')
            ]);
          },
        ),
        if (notification.statusId != null)
          StreamBuilder(
            stream: context
                .read<AppDatabase>()
                .statusDao
                .findStatusById(notification.statusId!),
            builder: (context, snapshot) {
              if (snapshot.data == null) return Container();
              return Padding(
                padding: EdgeInsets.all(8),
                child: StatusCardContent(snapshot.data!),
              );
            },
          ),
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
  const _NotificationsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationsProvider = context.watch<NotificationsProvider>();
    if (notificationsProvider.loading) {
      return LinearProgressIndicator();
    }
    return Container();
  }
}
