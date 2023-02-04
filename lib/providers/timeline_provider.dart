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
  TimelineProvider({
    required this.statusDao,
    required this.accountDao,
    required this.attachmentDao,
    required this.timelineDao,
  });

  loadTimeline() async {
    _loading = true;
    notifyListeners();

    try {
      final resp = await MastodonHelper.api?.v1.timelines.lookupHomeTimeline();
      if (resp != null) {
        await timelineDao.saveTimelineStatues(resp.data);
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  loadThread(String statusId) async {
    _loading = true;
    notifyListeners();

    try {
      final resp = await MastodonHelper.api?.v1.statuses
          .lookupStatusContext(statusId: statusId);
      if (resp != null) {
        await timelineDao.saveTimelineStatues([
          ...resp.data.ancestors,
          ...resp.data.descendants
        ]);
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
        await timelineDao.saveTimelineStatues([resp.data]);
      }
    } finally { 
      notifyListeners();
    }
  }
}
