import 'package:flutter/material.dart';

import 'package:mastodon/dao/setting_dao.dart';
import 'package:mastodon/enties/setting_model.dart';
import 'package:mastodon/helpers/mastodon_helper.dart';
import 'package:mastodon_api/mastodon_api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../models/access_token_response.dart';

enum StorageKeys {
  accessToken('accessToken'),
  instanceName('instanceName');

  const StorageKeys(this.storageKey);
  final String storageKey;
}


class Authorization {
  final String token;
  final String instance;

  const Authorization({
    required this.token,
    required this.instance,
  });
}

class AuthorizationProvider extends ChangeNotifier {
  final String clientId;
  final String clientSecret;
  final SettingDao settingDao;
  bool _isAuthorized = false;
  bool get isAuthorized => _isAuthorized;
  
  bool _loading = false;
  bool get loading => _loading;

  AuthorizationProvider({
    required this.clientId,
    required this.clientSecret,
    required this.settingDao,
  });

  Future<Authorization> getAuthorization() async {
    return Authorization(
      token: (await settingDao.findSettingByName(StorageKeys.accessToken.storageKey))?.value ?? '', 
      instance: (await settingDao.findSettingByName(StorageKeys.instanceName.storageKey))?.value ?? ''
    );
  }

  Future checkAuthorization() async {
    final auth = await getAuthorization();
    _isAuthorized = auth.token.isNotEmpty;

    if (_isAuthorized && MastodonHelper.api == null) {
      MastodonHelper.init(instance: auth.instance, token: auth.token);
    }
    notifyListeners();
  }

  Future setAuthorization(Authorization auth) async {
    MastodonHelper.init(instance: auth.instance, token: auth.token);

    await settingDao.insertSetting(Setting(name: StorageKeys.instanceName.storageKey, value: auth.instance));
    await settingDao.insertSetting(Setting(name: StorageKeys.accessToken.storageKey, value: auth.token));
    await checkAuthorization();
  }

  Future removeAuthorization() async {
    MastodonHelper.clear();

    await settingDao.removeSettingByName(StorageKeys.instanceName.storageKey);
    await settingDao.removeSettingByName(StorageKeys.accessToken.storageKey);
    await checkAuthorization();
  }

  openLogin(String instance) async {
    _loading = true;
    notifyListeners();

    try {
      final url = Uri(
          scheme: 'https',
          host: instance,
          path: '/oauth/authorize',
          queryParameters: {
            'response_type': 'code',
            'client_id': clientId,
            'redirect_uri': 'urn:ietf:wg:oauth:2.0:oob'
          });

      if (!await launchUrl(url)) {
        throw 'Could not launch ${url.toString()}';
      }
      
    } catch (e) {
      debugPrint(e.toString());
    }
    finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<AccessTokenResponse?> getToken(String instance, String code) async {
    final url = Uri(
          scheme: 'https',
          host: instance,
          path: '/oauth/token',
    );

    final Map<String, String> body = {
      "code": code,
      "grant_type": "authorization_code",
      "client_id": clientId,
      "client_secret": clientSecret,
      "redirect_uri": "urn:ietf:wg:oauth:2.0:oob"
    };
    
    final response = await http
        .post(url, body: body);

    if (response.statusCode == 200) {
      return AccessTokenResponse.fromJson(response.body);
    } else {
      throw Exception('Failed to load album');
    }

  }
}
