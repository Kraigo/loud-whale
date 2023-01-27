import 'package:mastodon_api/mastodon_api.dart';

class MastodonHelper {
  static MastodonApi? api;

  static init({
    required String instance,
    required String token
  }) {
    api = MastodonApi(instance: instance, bearerToken: token);
  }

  static clear() {
    api = null;
  }
}