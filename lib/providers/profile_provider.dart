import 'package:flutter/material.dart';
import 'package:mastodon/dao/account_dao.dart';
import 'package:mastodon/dao/setting_dao.dart';
import 'package:mastodon/enties/account_entity.dart';
import 'package:mastodon/helpers/mastodon_helper.dart';

class ProfileProvider extends ChangeNotifier {
  AccountDao accountDao;
  SettingDao settingDao;
  ProfileProvider({
    required this.accountDao,
    required this.settingDao,
  });

  verifyAccount() async {
    try {
      final resp =
          await MastodonHelper.api?.v1.accounts.verifyAccountCredentials();
      if (resp != null) {
        await accountDao.insertAccount(AccountEntity.fromModel(resp.data));
      }
    } catch (_) {}
  }
}
