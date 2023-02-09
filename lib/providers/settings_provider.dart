import 'package:flutter/material.dart';
import 'package:mastodon/base/store_key.dart';
import 'package:mastodon/dao/setting_dao.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/helpers/mastodon_helper.dart';

class SettingsProvider extends ChangeNotifier {
  SettingDao settingDao;
  Map<StorageKeys, String> settings = {};

  SettingsProvider({required this.settingDao});

  String? getSettingValue(StorageKeys key) {
    if (settings.containsKey(key)) {
      return settings[key];
    }
    return null;
  }

  int get statusMaxLength {
    return int.parse(getSettingValue(StorageKeys.statusesMaxCharacter) ?? '0');
  }

  Future<void> refresh() async {
    for (final s in StorageKeys.values) {
      final setting = await settingDao.findSettingByName(s.storageKey);
      settings.addAll({
        s: setting?.value ?? '',
      });
    }
    notifyListeners();
  }

  Future<void> loadInstanceSettings() async {
    try {
      // ignore: deprecated_member_use
      final resp = await MastodonHelper.api?.v1.instance.lookupInformation();
      if (resp != null) {
        final settings = [
          SettingEntity(
              name: StorageKeys.statusesMaxCharacter.storageKey,
              value: '${resp.data.configuration?.statuses.maxCharacters}'),
          SettingEntity(
              name: StorageKeys.statusesMaxAttachments.storageKey,
              value:
                  '${resp.data.configuration?.statuses.maxMediaAttachments}'),
          SettingEntity(
              name: StorageKeys.pollMaxCharacters.storageKey,
              value:
                  '${resp.data.configuration?.polls.maxCharactersPerOption}'),
          SettingEntity(
              name: StorageKeys.pollMaxOptions.storageKey,
              value: '${resp.data.configuration?.polls.maxOptions}')
        ];
        await settingDao.insertSettings(settings);
        await refresh();
      }
    } catch (_) {}
  }
}
