import 'package:flutter/material.dart';
import 'package:mastodon/dao/account_dao.dart';
import 'package:mastodon/dao/status_dao.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/helpers/mastodon_helper.dart';

class TimelineProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  List<Status> _statuses = [];
  List<Status> get statuses => _statuses;

  StatusDao statusDao;
  AccountDao accountDao;
  TimelineProvider({required this.statusDao, required this.accountDao});

  Stream<Account?> getAccountById(String id) {
    return accountDao.findAccountById(id);
  }

  loadTimeline() async {
    _loading = true;
    notifyListeners();

    try {
      final resp = await MastodonHelper.api?.v1.timelines.lookupHomeTimeline();
      if (resp != null) {
        for (var s in resp.data) {
          await statusDao.insertStatus(Status(
            id: s.id,
            content: s.content,
            accountId: s.account.id,
          ));

          await accountDao.insertAccount(Account(
            id: s.account.id,
            username: s.account.username,
            display_name: s.account.displayName,
          ));
        }

        _statuses = await statusDao.findAllStatuses();
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
