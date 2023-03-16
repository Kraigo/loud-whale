import 'package:flutter/material.dart';
import 'package:mastodon/dao/notification_dao.dart';
import 'package:mastodon/dao/timeline_dao.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/helpers/mastodon_helper.dart';

class NotificationsProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  List<NotificationEntity> _notifications = [];
  List<NotificationEntity> get notifications => _notifications;

  NotificationDao notificationDao;
  TimelineDao timelineDao;
  final pageSize = 20;

  NotificationsProvider({
    required this.notificationDao,
    required this.timelineDao,
  });

  Future<void> refresh() async {
    final limit = _notifications.isNotEmpty ? _notifications.length : pageSize;
    const skip = 0;
    _notifications = await notificationDao.findNotifications(limit, skip);
    for (var n in _notifications) {
      await timelineDao.populateNotification(n);
    }
    notifyListeners();
  }

  Future<void> appendNotifications() async {
    final limit = pageSize;
    final skip = _notifications.length;
    final moreNotifications = await notificationDao.findNotifications(limit, skip);
    for (var n in moreNotifications) {
      await timelineDao.populateNotification(n);
    }
    _notifications.addAll(moreNotifications);
    notifyListeners();
  }

  loadNotifications() async {
    _loading = true;
    notifyListeners();

    try {
      final resp =
          await MastodonHelper.api?.v1.notifications.lookupNotifications(limit: pageSize);
      if (resp != null) {
        await timelineDao.saveNotifications(resp.data);
        _notifications.clear();
        await refresh();
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  loadNotificationsMore() async {
    if (_loading) return;

    _loading = true;
    notifyListeners();

    final count = await notificationDao.countNotifications();

    if (count != null && count > _notifications.length) {
      await appendNotifications();
      await Future.delayed(const Duration(milliseconds: 100));
      _loading = false;
      notifyListeners();
      return;
    }

    try {
      final notification = await notificationDao.getOldestNotification();
      final resp = await MastodonHelper.api?.v1.notifications
          .lookupNotifications(maxNotificationId: notification?.id, limit: pageSize);
      if (resp != null) {
        await timelineDao.saveNotifications(resp.data);
        await refresh();
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
