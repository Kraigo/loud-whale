import 'package:flutter/material.dart';
import 'package:mastodon_api/mastodon_api.dart';
import 'package:url_launcher/url_launcher.dart';

class MastodonProvider extends ChangeNotifier {
  MastodonApi? api;
  bool _loading = false;
  bool get loading => _loading;

  init(String instanceName) async {
    _loading = true;
    notifyListeners();

    api = MastodonApi(instance: '$instanceName');

    try {
      final resp = await api?.v1.apps.createApplication(
        clientName: 'Loud Whale',
        scopes: [Scope.read],
      );
      if (resp != null) {
        final url = Uri(
            scheme: 'https',
            host: instanceName,
            path: '/oauth/authorize',
            queryParameters: {
              'response_type': 'code',
              'client_id': resp.data.clientId,
              'redirect_uri': 'urn:ietf:wg:oauth:2.0:oob'
            });

        if (!await launchUrl(url)) {
          throw 'Could not launch ${url.toString()}';
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    finally {
      _loading = false;
      notifyListeners();
    }
  }
}
