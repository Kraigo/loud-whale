import 'package:flutter/material.dart';
import 'package:mastodon/dao/status_dao.dart';
import 'package:mastodon/dao/timeline_dao.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/helpers/mastodon_helper.dart';

class ThreadProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  StatusDao statusDao;
  TimelineDao timelineDao;

  String? _statusId;
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

  Future<void> refresh() async {
    if (_statusId == null) return;
    _threadStatus = await statusDao.findStatusById(_statusId!);
    _ancestors = await statusDao.findStatusRepliesAncestors(_statusId!);
    _descendants = await statusDao.findStatusRepliesDescendants(_statusId!);

    await timelineDao.populateStatus(_threadStatus);
    for (var s in _ancestors) {
      await timelineDao.populateStatus(s);
    }
    for (var s in _descendants) {
      await timelineDao.populateStatus(s);
    }

    notifyListeners();
  }

  Future<void> loadThread(String statusId) async {
    _loading = true;
    _ancestors = [];
    _descendants = [];
    _statusId = statusId;
    notifyListeners();

    try {
      final resp = await MastodonHelper.api?.v1.statuses
          .lookupStatusContext(statusId: statusId);
      if (resp != null) {
        await timelineDao.saveTimelineStatuses(
            [...resp.data.ancestors, ...resp.data.descendants]);
        await refresh();
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
