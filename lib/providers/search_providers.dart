import 'package:flutter/material.dart';
import 'package:mastodon/dao/account_dao.dart';
import 'package:mastodon/dao/setting_dao.dart';
import 'package:mastodon/dao/status_dao.dart';
import 'package:mastodon/dao/timeline_dao.dart';
import 'package:mastodon/enties/account_entity.dart';
import 'package:mastodon/enties/status_entity.dart';
import 'package:mastodon/helpers/mastodon_helper.dart';

class SearchProvider extends ChangeNotifier {
  StatusDao statusDao;
  AccountDao accountDao;
  TimelineDao timelineDao;

  bool _loading = false;
  bool get loading => _loading;
  int pageSize = 5;

  List<String> _accountIds = [];
  List<AccountEntity> _accounts = [];
  List<AccountEntity> get accounts => _accounts;

  List<String> _statuseIds = [];
  List<StatusEntity> _statuses = [];
  List<StatusEntity> get statuses => _statuses;

  SearchProvider(
      {required this.statusDao,
      required this.accountDao,
      required this.timelineDao});

  refresh() async {
    List<AccountEntity> accounts = [];
    for (var id in _accountIds) {
      final account = await accountDao.findAccountById(id);
      if (account != null) {
        accounts.add(account);
      }
    }

    List<StatusEntity> statuses = [];
    for (var id in _statuseIds) {
      final status = await statusDao.findStatusById(id);
      if (status != null) {
        statuses.add(status);
      }
    }

    _accounts = accounts;
    _statuses = statuses;

    notifyListeners();
  }

  loadSearch(String query) async {
    _loading = true;
    notifyListeners();

    try {
      final resp =
          await MastodonHelper.api?.v2.search.searchContents(query: query);

      if (resp != null) {
        if (resp.data.accounts != null) {
          _accountIds = resp.data.accounts!.map((e) => e.id).toList();
          await timelineDao.saveAccounts(resp.data.accounts!);
        }
        if (resp.data.statuses != null) {
          _statuseIds = resp.data.statuses!.map((e) => e.id).toList();
          await timelineDao.saveStatuses(resp.data.statuses!);
        }
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
