import 'package:flutter/material.dart';
import 'package:mastodon/dao/account_dao.dart';
import 'package:mastodon/dao/attachment_dao.dart';
import 'package:mastodon/dao/status_dao.dart';
import 'package:mastodon/dao/timeline_dao.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/helpers/mastodon_helper.dart';

class TimelineProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  StatusDao statusDao;
  AccountDao accountDao;
  AttachmentDao attachmentDao;
  TimelineDao timelineDao;

  List<StatusEntity> _statuses = [];
  List<StatusEntity> get statuses => _statuses;

  TimelineProvider({
    required this.statusDao,
    required this.accountDao,
    required this.attachmentDao,
    required this.timelineDao,
  });

  refresh() async {
    _statuses = await statusDao.findAllStatuses();
    for (var s in _statuses) {
      await timelineDao.populateStatus(s);
    }
    notifyListeners();
  }

  loadTimeline() async {
    _loading = true;
    notifyListeners();

    try {
      final resp = await MastodonHelper.api?.v1.timelines.lookupHomeTimeline();
      if (resp != null) {
        await timelineDao.saveTimelineStatuses(resp.data);
        await refresh();
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  favoriteStatus(String statusId) async {
    try {
      final resp = await MastodonHelper.api?.v1.statuses
          .createFavourite(statusId: statusId);
      if (resp != null) {
        await timelineDao.saveTimelineStatuses([resp.data]);
      }
    } finally {
      notifyListeners();
    }
  }
}
