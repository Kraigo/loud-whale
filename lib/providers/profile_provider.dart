import 'package:flutter/material.dart';
import 'package:mastodon/dao/account_dao.dart';
import 'package:mastodon/dao/setting_dao.dart';
import 'package:mastodon/enties/account_entity.dart';
import 'package:mastodon/helpers/mastodon_helper.dart';

class ProfileProvider extends ChangeNotifier {
  AccountDao accountDao;
  SettingDao settingDao;

  AccountEntity? _profile;
  AccountEntity? get profile => _profile;

  ProfileProvider({
    required this.accountDao,
    required this.settingDao,
  });

  refresh() async {
    _profile = await accountDao.findCurrentAccount();
    notifyListeners();
  }
}
