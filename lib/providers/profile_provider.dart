import 'package:flutter/material.dart';
import 'package:mastodon/dao/account_dao.dart';
import 'package:mastodon/dao/setting_dao.dart';
import 'package:mastodon/enties/account_entity.dart';
import 'package:mastodon/helpers/mastodon_helper.dart';
import 'package:mastodon_api/src/service/entities/relationship.dart';

class ProfileProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  AccountDao accountDao;

  AccountEntity? _profile;
  AccountEntity? get profile => _profile;

  Relationship? _relationship;
  Relationship? get relationship => _relationship;

  ProfileProvider({
    required this.accountDao,
  });

  refresh() async {
    _profile = await accountDao.findCurrentAccount();
    notifyListeners();
  }

  follow(String accountId) async {
    try {
      await MastodonHelper.api?.v1.accounts.createFollow(accountId: accountId);
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadRelationship(String accountId) async {
    try {
      final resp = await MastodonHelper.api?.v1.accounts
          .lookupRelationships(accountIds: [accountId]);

      _relationship = resp?.data.first;
    } finally {
      notifyListeners();
    }
  }

  unfollow(String accountId) async {
    try {
      await MastodonHelper.api?.v1.accounts.destroyFollow(accountId: accountId);
    } finally {
      notifyListeners();
    }
  }
}
