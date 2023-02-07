import 'package:flutter/material.dart';
import 'package:mastodon/dao/account_dao.dart';
import 'package:mastodon/dao/attachment_dao.dart';
import 'package:mastodon/dao/status_dao.dart';
import 'package:mastodon/dao/timeline_dao.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/helpers/mastodon_helper.dart';

class ThreadProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  StatusDao statusDao;
  TimelineDao timelineDao;
  StatusEntity? _threadStatus;
  StatusEntity? get threadStatus => _threadStatus;

  List<StatusEntity> _ancestors = [];
  List<StatusEntity> get ancestors => _ancestors;

  List<StatusEntity> _descendants = [];
  List<StatusEntity> get descendants => _descendants;

  ThreadProvider({
    required this.statusDao,
    required this.timelineDao,
  });

  Future<void> loadThread(String statusId) async {
    _loading = true;
    _ancestors = [];
    _descendants = [];
    notifyListeners();

    try {
      final resp = await MastodonHelper.api?.v1.statuses
          .lookupStatusContext(statusId: statusId);
      if (resp != null) {
        await timelineDao.saveTimelineStatuses(
            [...resp.data.ancestors, ...resp.data.descendants]);

        _threadStatus = await statusDao.findStatusById(statusId);
        _ancestors = await statusDao.findStatusRepliesAncestors(statusId);
        _descendants = await statusDao.findStatusRepliesDescendants(statusId);

        await timelineDao.populateStatus(_threadStatus);
        for (var s in _ancestors) {
          await timelineDao.populateStatus(s);
        }
        for (var s in _descendants) {
          await timelineDao.populateStatus(s);
        }
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
