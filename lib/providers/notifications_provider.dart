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

  NotificationsProvider({
    required this.notificationDao,
    required this.timelineDao,
  });

  loadNotifications() async {
    _loading = true;
    notifyListeners();

    try {
      final resp =
          await MastodonHelper.api?.v1.notifications.lookupNotifications();
      if (resp != null) {
        final notifications =
            resp.data.map(NotificationEntity.fromModel).toList();
        await notificationDao.insertNotifications(notifications);
        await timelineDao.saveTimelineStatuses(resp.data
            .where((e) => e.status != null)
            .map((e) => e.status!)
            .toList());
        await timelineDao.insertAccounts(
            resp.data.map((e) => AccountEntity.fromModel(e.account)).toList());

        for (var n in _notifications) {
          await timelineDao.populateNotification(n);
        }
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
