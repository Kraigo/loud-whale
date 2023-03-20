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
  late ScrollController _scrollController;

  @override
  void initState() {
    Future.microtask(_loadInitial);
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      const delta = 100;
      if (maxScroll - currentScroll <= delta) {
        _onLoadMore();
      }

      if (currentScroll <= 0) {
        _onReadAll();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _onLoadMore() async {
    final notificationsProvider = context.read<NotificationsProvider>();
    notificationsProvider.loadNotificationsMore();
  }
  _onReadAll() async {
    final notificationsProvider = context.read<NotificationsProvider>();
    await notificationsProvider.readNotifications();
  }

  _loadInitial() async {
    final notificationsProvider = context.read<NotificationsProvider>();
    await notificationsProvider.refresh();
    await notificationsProvider.loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final notificationsProvider = context.watch<NotificationsProvider>();
    final notifications = notificationsProvider.notifications;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(3.0),
            child: _NotificationsLoading(),
          ),
        ),
        body: ListView.separated(
          controller: _scrollController,
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final item = notifications[index];
            final isUnread = notificationsProvider.isUnread(item);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: MiddleContainer(NotificationCard(
                item,
                isUnread: isUnread,
              )),
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
