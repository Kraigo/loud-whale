import 'package:flutter/material.dart';
import 'package:mastodon/dao/account_dao.dart';
import 'package:mastodon/dao/relationship_dao.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/helpers/mastodon_helper.dart';

class ProfileProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  AccountDao accountDao;
  RelationshipDao relationshipDao;

  AccountEntity? _profile;
  AccountEntity? get profile => _profile;

  RelationshipEntity? _relationship;
  RelationshipEntity? get relationship => _relationship;

  ProfileProvider({
    required this.accountDao,
    required this.relationshipDao,
  });

  refresh(String accountId) async {
    _profile = await accountDao.findAccountById(accountId);
    _profile?.relationship =
        await relationshipDao.findRelationshipByAccountId(accountId);
    notifyListeners();
  }

  Future<void> loadProfile(String accountId) async {
    _loading = true;
    notifyListeners();
    try {
      final resp = await MastodonHelper.api?.v1.accounts
          .lookupAccount(accountId: accountId);
      if (resp != null) {
        final account = AccountEntity.fromModel(resp.data);
        await accountDao.insertAccount(account);
      }
      await refresh(accountId);
    } finally {
      _loading = false;
      notifyListeners();
    }
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
      if (resp != null) {
        final relationship =
            RelationshipEntity.fromModel(accountId, resp.data.first);
        await relationshipDao.insertRelationship(relationship);
      }
      await refresh(accountId);
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
