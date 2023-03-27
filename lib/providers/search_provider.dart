import 'package:flutter/material.dart';
import 'package:mastodon/dao/account_dao.dart';
import 'package:mastodon/dao/status_dao.dart';
import 'package:mastodon/dao/timeline_dao.dart';
import 'package:mastodon/enties/account_entity.dart';
import 'package:mastodon/enties/status_entity.dart';
import 'package:mastodon/helpers/mastodon_helper.dart';
import 'package:mastodon/models/search_type.dart';

class SearchProvider extends ChangeNotifier {
  StatusDao statusDao;
  AccountDao accountDao;
  TimelineDao timelineDao;

  bool _loading = false;
  bool get loading => _loading;
  int _pageSize = 5;

  List<String> _accountIds = [];
  List<AccountEntity> _accounts = [];
  List<AccountEntity> get accounts => _accounts;

  List<String> _statuseIds = [];
  List<StatusEntity> _statuses = [];
  List<StatusEntity> get statuses => _statuses;

  String _searchText = '';
  String get searchText => _searchText;
  SearchType _searchType = SearchType.hashtags;
  SearchType get searchType => _searchType;

  SearchProvider({
    required this.statusDao,
    required this.accountDao,
    required this.timelineDao,
  });

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
        await timelineDao.populateStatus(status);
      }
    }

    _accounts = accounts;
    _statuses = statuses;

    notifyListeners();
  }

  loadSearch() async {
    _loading = true;
    notifyListeners();

    try {
      final resp = await MastodonHelper.api?.v2.search
          .searchContents(query: _searchText);

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

  loadSearchTimeline() async {
    try {
      final resp = await MastodonHelper.api?.v1.timelines
          .lookupTimelineByHashtag(hashtag: _searchText, limit: _pageSize);

      if (resp != null) {
        _statuseIds = resp.data.map((e) => e.id).toList();
        await timelineDao.saveStatuses(resp.data);
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  loadSearchTimelineMore() async {
    if (_loading) return;

    _loading = true;
    notifyListeners();

    try {
      final resp =
          await MastodonHelper.api?.v1.timelines.lookupTimelineByHashtag(
        hashtag: _searchText,
        maxStatusId: _statuseIds.last,
        limit: _pageSize,
      );
      if (resp != null) {
        await timelineDao.saveStatuses(resp.data);
        final moreStatuseIds = resp.data.map((e) => e.id);
        _statuseIds.addAll(moreStatuseIds);
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  selectSearch(String query) {
    final hashtagPrefix = RegExp(r'^#');
    final accountPrefix = RegExp(r'^@');
    if (hashtagPrefix.hasMatch(query)) {
      // hash
      _searchText = query.replaceAll(hashtagPrefix, '');
      _searchType = SearchType.hashtags;
    } else if (accountPrefix.hasMatch(query)) {
      // account
      _searchText = query.replaceAll(accountPrefix, '');
      _searchType = SearchType.accounts;
    } else {
      // text
      _searchText = query;
      // _searchType = SearchType.all;
    }
  }

  clear() {
    _searchText = '';
    _searchType = SearchType.all;
  }
}
