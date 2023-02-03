import 'package:flutter/material.dart';
import 'package:mastodon/dao/account_dao.dart';
import 'package:mastodon/dao/attachment_dao.dart';
import 'package:mastodon/dao/status_dao.dart';
import 'package:mastodon/enties/attachment_entity.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/helpers/mastodon_helper.dart';
import 'package:mastodon_api/mastodon_api.dart';

class TimelineProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  List<StatusEntity> _statuses = [];
  List<StatusEntity> get statuses => _statuses;

  StatusDao statusDao;
  AccountDao accountDao;
  AttachmentDao attachmentDao;
  TimelineProvider({
    required this.statusDao,
    required this.accountDao,
    required this.attachmentDao,
  });

  Stream<AccountEntity?> getAccountById(String id) {
    return accountDao.findAccountById(id);
  }

  Stream<List<AttachmentEntity>> getAttachmentsByStatus(String statusId) {
    return attachmentDao.findAttachemntsByStatus(statusId);
  }

  loadTimeline() async {
    _loading = true;
    notifyListeners();

    try {
      final resp = await MastodonHelper.api?.v1.timelines.lookupHomeTimeline();
      if (resp != null) {
        for (var s in resp.data) {
          await _saveStatus(s);
          if (s.reblog != null) {
            await _saveStatus(s.reblog!);
          }
        }
        _statuses = await statusDao.findAllStatuses();
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
        for (var s in resp.data.ancestors) {
          await _saveStatus(s);
        }
        for (var s in resp.data.descendants) {
          await _saveStatus(s);
        }
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
        await _saveStatus(resp.data);
      }
    } finally {
      notifyListeners();
    }
  }

  _saveStatus(Status status) async {
    await statusDao.insertStatus(StatusEntity.fromModel(status));
    await accountDao.insertAccount(AccountEntity.fromModel(status.account));

    for (var attachment in status.mediaAttachments) {
      await attachmentDao
          .insertAttachment(AttachmentEntity.fromModel(status.id, attachment));
    }
  }

  StatusEntity? getStatusById(String id) {
    for (var status in _statuses) {
      if (status.id == id) {
        return status;
      }
    }
    return null;
  }

  Stream<StatusEntity?> getStatusByIdStream(String id) {
    return statusDao.findStatusById(id);
  }
}
