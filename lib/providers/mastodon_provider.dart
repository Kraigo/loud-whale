import 'package:flutter/material.dart';
import 'package:mastodon_api/mastodon_api.dart';
import 'package:url_launcher/url_launcher.dart';

class MastodonProvider extends ChangeNotifier {
  String clientId;
  static MastodonApi? api;
  bool _loading = false;
  bool get loading => _loading;

  MastodonProvider({
    required this.clientId
  });

  init({
    required String instance,
    required String token
  }) {
    api = MastodonApi(instance: instance, bearerToken: token);
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
}
